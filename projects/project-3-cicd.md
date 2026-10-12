# Project 3: TWS Labs with CI/CD on GitHub Actions

TWS Labs is a browser-based lab platform with a real Linux terminal. It is one container on port 8080 with no database. The repo already ships a complete pipeline that tests it, builds the image and deploys it to Elastic Beanstalk on every push to `main`. This project uses the repo as it is.

- Repo: https://github.com/trainwithshubham/tws-labs
- Pipeline files: `.github/workflows/ci.yml` and `deploy.yml`, scripts in `deploy/`, infrastructure code in `deploy/infra/`
- Deployment mode: Cluster Mode, with the image stored in Amazon ECR

> Status: written from reading the repo. The pipeline was not re-run for this guide. The repo's own `deploy/CHECKLIST.md` marks a full push-to-`main` run of `deploy.yml` as still to be confirmed, so do a dry run before you rely on it.

## At a glance

| | |
|---|---|
| App | TWS Labs, one container on port 8080, no database |
| Source | https://github.com/trainwithshubham/tws-labs |
| Mode | Cluster Mode, image stored in Amazon ECR |
| Runs with | GitHub Actions (every push to `main`), or the AWS CLI scripts in `deploy/` by hand |
| Time | 15 to 20 minutes for the first environment, quick for later pushes |
| You need | A GitHub account, the AWS CLI, Terraform, and the Cluster Mode IAM roles |

There is no console or EB CLI route here. The pipeline and its scripts use the AWS CLI, because the EB CLI has no Cluster Mode option.

## What the pipeline does

`ci.yml` runs on every pull request and every push to `main`:

| Job | What it checks |
|-----|----------------|
| Tests | Node 22, `npm ci`, hygiene check, lab lint, `npm test` |
| Image | Builds the `linux/amd64` image, validates every lab, runs the tests again as root inside the image |
| Local run | `docker compose up`, then the smoke test against `localhost:8080` |
| Terraform | `terraform fmt -check` and `terraform validate` |

`deploy.yml` runs on every push to `main`, one deploy at a time (new pushes queue):

1. Check out the code and assume an AWS role through GitHub OIDC, so no long-lived AWS keys are stored in GitHub.
2. Terraform applies the durable pieces: IAM roles, the ECR repository, a budget alert, and the deploy role itself.
3. `deploy/02-build-and-push.sh` builds the image and pushes it to ECR.
4. `deploy/03-deploy.sh` creates a new application version from that image and updates the environment, or creates it the first time.
5. The workflow waits for the environment to be Ready, then runs `deploy/smoke-test.py` against the live URL as the last gate.

The Elastic Beanstalk application and environment are created by AWS CLI scripts, not by Terraform, because the Terraform AWS provider does not support Cluster Mode environments yet (its `tier` argument accepts only `Worker` or `WebServer`, per the repo's `deploy/README.md`).

## One-time setup

The first Terraform run has to be done by a person, because it creates the OIDC role the pipeline signs in with. The exact commands are in the "Bootstrap" section of the repo's `deploy/README.md`. In short:

1. Create the three Cluster Mode IAM roles (`deploy/01-create-roles.sh`).
2. Run `terraform init` and `terraform apply` once in `deploy/infra`, with your repo name, owner ID, repo ID and email as variables.
3. In the GitHub repo, under Settings, Secrets and variables, Actions, set these variables:
   - `AWS_DEPLOY_ROLE_ARN`, from the Terraform output
   - `AWS_REGION`
   - `BUDGET_NOTIFICATION_EMAIL`
4. Set the secret `LAB_ACCESS_TOKENS` (see "Keep it safe to share" below).

After that, every push to `main` deploys.

If you rename the GitHub repo, run the Terraform apply by hand once more. The deploy role trusts the repo by name, and the pipeline cannot fix its own trust policy.

## Run the manual order first

Before trusting the pipeline, run the same steps by hand, in this order, from the `deploy/` folder:

```bash
./01-create-roles.sh    # one-time: the three Cluster Mode roles
./02-build-and-push.sh  # build the image and push it to ECR
./03-deploy.sh          # create or update the Cluster Mode environment
./04-teardown.sh        # terminate and verify nothing billable remains
```

The first environment in a region takes 15 to 20 minutes. In this guide's own tests of Project 1 it took about 22 minutes. Later updates are quick.

## Keep it safe to share

The app gives visitors a real shell, so the hosted profile is locked down:

- Every hosted lab refuses to start without an invite code. Codes live in the GitHub secret `LAB_ACCESS_TOKENS`, comma separated, one per cohort so a single one can be revoked. Create one with `openssl rand -base64 18 | gh secret set LAB_ACCESS_TOKENS`.
- With no secret set, every hosted lab is closed to everyone, and the deploy prints a warning.
- Each visitor runs as their own unprivileged user with CPU, memory and process limits.
- Capacity is five seats per replica. A flood of visitors does not add replicas on its own, so raise `MIN_REPLICA` before announcing the link, then lower it afterwards. For example `MIN_REPLICA=6 MAX_REPLICA=10 ./03-deploy.sh`.

## Cost

Cluster Mode bills for the shared foundation and a load balancer while the environment exists. The repo's default budget alert of $5 a month is lower than what a live environment costs, so set `budget_limit_usd` to what you intend to spend. Delete the environment when you finish with `./04-teardown.sh`, then check the account again the next day.

## Verify

```bash
aws elasticbeanstalk describe-environments --environment-names beanstalk-grows-env \
  --query 'Environments[0].[Status,Health,HealthStatus,CNAME]' --output text
```

Then open `https://<cname>/`. The load balancer answers on HTTPS only. The pipeline's smoke test walks a lab through a real terminal connection and checks that requests without a code get a 401.

## Gotchas

- The AWS resources keep older names (`beanstalk-grows` for the application, environment and ECR repo) from before the product was renamed. They are not a typo.
- Do not add an `environment:` key to the deploy job. It changes the OIDC token's subject and breaks the role's trust policy.
- The environment hostname is random. Look it up with the command above instead of saving it.
- Changing the invite codes restarts the running copies of the app and ends live sessions, so rotate them between events.
