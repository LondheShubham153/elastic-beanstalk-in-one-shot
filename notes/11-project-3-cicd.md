# 11. Project 3: TWS Labs with CI/CD on GitHub Actions

Push to `main`, and a pipeline tests the app, builds the image and deploys it to Elastic Beanstalk. TWS Labs already ships this pipeline, so this chapter walks through it.

Steps: [projects/project-3-cicd.md](../projects/project-3-cicd.md)

## What you will learn

- A deploy in a team is a push to `main`, not a click.
- Elastic Beanstalk fits a pipeline well: create a new application version, point the environment at it, and the rest is automatic.
- GitHub signs in to AWS through OIDC, so no access keys are stored in GitHub.
- An app that gives visitors a live terminal must not be left open. Invite codes gate every lab.

## What you will do

1. Read the two workflow files, `ci.yml` and `deploy.yml`.
2. Set up the roles, the one-time Terraform apply and the repo variables.
3. Set the invite-code secret.
4. Merge a small change to `main` and watch the Actions run.
5. Open the HTTPS URL when the run is green, enter an invite code and start a lab.
6. Check the new version in Deployment history, then tear down with `deploy/04-teardown.sh`.

## Common problems

- Never paste the invite-code secret or the repo variable values anywhere public.
- The ECR repo and application are named `beanstalk-grows`, from before the product was renamed.
- The first Cluster Mode environment takes 15 to 20 minutes. Later updates are quick.
- Terminate the environment afterwards. Billing runs until the shared infrastructure is gone, which can take up to 3 hours.
- The repo's own `deploy/CHECKLIST.md` lists a full push-to-`main` run as not yet confirmed, so test once yourself.
