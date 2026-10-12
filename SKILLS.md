---
name: elastic-beanstalk-in-one-shot
description: Deploy, configure, scale, troubleshoot and clean up apps on AWS Elastic Beanstalk (Standard Mode and Cluster Mode) using the tested commands in this repo. Use when someone asks how to deploy a Docker, PHP, Java, .NET, Node.js or Python app on Elastic Beanstalk, add an RDS database, set up CI/CD, fix a failed environment, or avoid surprise AWS costs.
---

# Elastic Beanstalk skill for AI assistants

This file tells an AI assistant or code assistant how to use this repo to help someone with Amazon Elastic Beanstalk. Read it first, then open the file that matches the question. Every command in the repo was run on a real AWS account in `us-west-2`, so prefer them over commands you remember from elsewhere.

## How to use this skill

1. Work out which situation the person is in (table below), then read only that file.
2. Give them the command for the route they use: **console**, **EB CLI** or **AWS CLI**. Every project page has all three.
3. Quote commands from the repo as written. Change names and regions, not the structure.
4. Before you run or suggest anything that creates AWS resources, say what it will cost and how to delete it. Cleanup commands are on every page.
5. If the repo says something was not tested, say so. Do not fill the gap with a guess.

## Where to look

| The person wants to | Open |
|---------------------|------|
| Install tools, sign in, check their machine | [setup/README.md](setup/README.md), then run `bash setup/check-setup.sh` |
| Create the IAM roles Standard Mode needs | [setup/iam-roles.md](setup/iam-roles.md) |
| Understand applications, environments, versions, tiers | [notes/02-primitives-and-concepts.md](notes/02-primitives-and-concepts.md) |
| Deploy a single-container app fast | [projects/project-1-single-tier.md](projects/project-1-single-tier.md) |
| Deploy an app with a database | [projects/project-2-two-tier.md](projects/project-2-two-tier.md) |
| Set up a GitHub Actions pipeline | [projects/project-3-cicd.md](projects/project-3-cicd.md) |
| Move an old PHP, Java or .NET app over | [projects/legacy-lift-and-shift.md](projects/legacy-lift-and-shift.md) |
| Change environment variables, saved configurations, `.ebextensions` | [notes/05-environments-config.md](notes/05-environments-config.md) |
| Scale, schedule capacity, load balancer health checks | [notes/06-scaling-load-balancing.md](notes/06-scaling-load-balancing.md) |
| Pick a deployment policy, blue/green, roll back | [notes/07-deployment-strategies.md](notes/07-deployment-strategies.md) |
| Read health, events and logs | [notes/08-observability.md](notes/08-observability.md) |
| Choose between Standard Mode and Cluster Mode | [notes/09-cluster-mode.md](notes/09-cluster-mode.md) |
| Delete everything and understand the bill | [notes/14-cleanup-and-cost.md](notes/14-cleanup-and-cost.md) |
| Share what they built | [community/README.md](community/README.md) |

## Decide the mode first

| | Standard Mode | Cluster Mode |
|---|---|---|
| Input | Source bundle, or a `docker-compose.yml` | A container image (Docker Hub or Amazon ECR) |
| Platforms | Docker, Java, .NET, Node.js, Python, PHP, Ruby, Go | One container image |
| Free Tier | Yes, for new accounts | No |
| First environment | About 3 minutes | About 22 minutes, then about 3 minutes for each next one |
| EB CLI | Yes | No. Use the AWS CLI or the console |
| Database | Container in the compose file, or RDS | RDS or another external database |

Default to Standard Mode for a first deploy, a single app and anything on the Free Tier. Suggest Cluster Mode when several apps should share infrastructure.

## Workflows

### Deploy a container app (Standard Mode)

1. Confirm setup: `bash setup/check-setup.sh`, and the two IAM roles exist.
2. Follow [Project 1](projects/project-1-single-tier.md). The shortest route is the EB CLI: `eb init`, then `eb create --single --instance-type ... --instance_profile aws-elasticbeanstalk-ec2-role --service-role aws-elasticbeanstalk-service-role`.
3. Check the URL and `/health`.
4. Remind them to run the cleanup commands.

### Deploy an app with a database

1. Standard Mode with a MySQL container: Part A of [Project 2](projects/project-2-two-tier.md). Use `t3.small` or larger.
2. Cluster Mode with RDS: Part B. The order matters: database, then security group rule, then environment.
3. If the launch fails with `Target.Timeout`, go straight to [the troubleshooting section](projects/project-2-two-tier.md#the-launch-fails-with-targettimeout).

### Troubleshoot a failed or unhealthy environment

1. Read the events: `aws elasticbeanstalk describe-events --environment-name <env> --max-items 20`.
2. Match the message against the table below.
3. Chapter 8 covers health states, instance health and logs.

### Clean up

Use the cleanup block on the page they followed. Order matters: terminate the environment, wait for `environment-terminated`, then delete the application. Cluster Mode leaves shared infrastructure that AWS removes up to about 3 hours after the last environment ends, and it keeps billing until then.

## Known problems and fixes

| Symptom | Cause and fix | Where |
|---------|---------------|-------|
| `t3.micro` hangs or times out with MySQL and Flask in one compose file | Too little memory. Use `t3.small` or larger | Project 2 |
| `delete-application` fails right after `terminate-environment` | Wait first: `aws elasticbeanstalk wait environment-terminated --environment-names <env>` | Project 1 |
| Cluster Mode environment fails with `Target.Timeout`, then `Rollback skipped` | The database security group has no inbound rule on port 3306 from the environment's group. Add it, then rebuild | Project 2 |
| Cluster Mode launch fails with `Target.ResponseCodeMismatch` and `[500]` | The app is reachable but errors on the database. Read the app log in CloudWatch (`/aws/elasticbeanstalk/application/logs`). `Unknown database` means the instance was created without `--db-name` | Project 2 |
| Cluster Mode URL does not answer on `http://` | The load balancer is HTTPS only. Use `https://` | Project 1 |
| Cluster Mode app unreachable on the wrong port | Set the service port to the port the app listens on (default 8080, Flask in Project 2 uses 5000) | Project 2 |
| Cluster Mode rejects one option per variable | Pass all variables as one JSON option, `env-variables`, in `aws:elasticbeanstalk:eks:environment` | Project 2 |
| `aws rds create-db-subnet-group` fails with "control characters" on zsh | Pass the subnet list as quoted JSON, as in step 1 of Project 2 | Project 2 |
| `aws: command not found`, or `aws-cli/1.` in `aws --version` | Install AWS CLI v2 and reopen the terminal | Setup |
| `eb: command not found` | The EB CLI virtual environment is not active in this terminal | Setup |
| 502 after moving a compose container to port 8080 | With a compose file that publishes port 80, the container owns the port. Do not add nginx extensions | Chapter 5 |
| `eb setenv` stops waiting after 4 minutes | The update continues. Watch with `eb events -f` | Chapter 5 |
| `eb scale 2` removes the autoscaling range | It sets both minimum and maximum. Use the AWS CLI for a range | Chapter 6 |
| Scheduled action rejected | The name must be letters and digits only | Chapter 6 |
| Environment goes Red with traffic splitting | We saw 5xx failures and did not find the cause. Test it with your own app first | Chapter 7 |
| Failed deployment is easy to miss | Check the Events tab for `Failed to deploy application` | Chapter 7 |
| `eb logs` fails with a certificate error | Seen with one local Python install. Use the console log tail or CloudWatch | Chapter 8 |

## Facts to get right

- **Region.** Commands were tested in `us-west-2`. Set `AWS_REGION` and the default region to match.
- **Platform name.** Examples use `64bit Amazon Linux 2023 v4.13.10 running Docker`. The version changes. List the current ones with `aws elasticbeanstalk list-available-solution-stacks`.
- **Roles.** Standard Mode needs `aws-elasticbeanstalk-service-role` and `aws-elasticbeanstalk-ec2-role`. The Standard wizard can create them (**Create default role**), but the EB CLI and AWS CLI routes need them to exist first. Cluster Mode uses three of its own roles, which you pick or create in its wizard.
- **Legacy platforms.** PHP 8.2 was the oldest PHP version we could create. Platform branches retire on published dates, so check the legacy page before promising long-term support.
- **Docker images.** Build for amd64, and for arm64 too if people use Apple silicon, or the instance cannot run the image. Pin the tag instead of `latest`.
- **Shell.** The commands are bash-style. On Windows, use WSL 2 or Git Bash, not PowerShell.

## Safety rules

- Never use the root user. Never paste access keys, passwords or tokens into a chat, a file in a repo or a screenshot.
- Ask before creating resources that cost money. Say the instance type, the likely cost and the cleanup command.
- Keep database passwords out of version control. The `change-me-...` values in the Project 2 compose file are placeholders. `env-variables` stores values in plain text, so use it only for demos.
- Do not delete resources the person did not create in this session. Check names and ownership first.

## What is not covered

Say this plainly if it comes up:

- The final clicks of the console steps were not tested. The CLI routes were.
- The Project 3 pipeline was read, not run end to end.
- Java and .NET deployments were not tested.
- The Cluster Mode `secrets` option, CloudWatch log streaming and a real managed platform update were not tested.

## Use this file in your assistant

- **Claude Code.** Copy this file to `.claude/skills/elastic-beanstalk/SKILL.md` in your project, or to `~/.claude/skills/elastic-beanstalk/SKILL.md` for all projects. Keep the repo cloned and tell the assistant where it is.
- **Other assistants and editors.** Add this file to the assistant's custom instructions or rules (for example `AGENTS.md`, `.cursorrules` or a Copilot instructions file) and point it at a local clone of this repo.
- **Chat assistants.** Paste this file at the start of the conversation, then share the project page you are following.
