# Project ideas for Elastic Beanstalk

Pick one, change something so it is yours, deploy it and share it. Every idea can run in Standard Mode, and Cluster Mode works for the container ones. Each level builds on the one before.

## Level 1: ship it

| Idea | What you practise |
|---|---|
| Personal portfolio or link page in Docker | One container, one file, a public URL |
| URL shortener | Environment properties and a health check path |
| Status page for your own apps | Calling endpoints and showing uptime |
| Legacy PHP, Java or .NET app lifted as is | Platform branches and managed updates |

## Level 2: add a database

| Idea | What you practise |
|---|---|
| Ticket or helpdesk app with PostgreSQL | Amazon RDS, security groups, secrets in environment properties |
| Expense tracker with MySQL | Schema setup and a safe first deploy |
| Queue or appointment booker for a clinic or office | Real data model and basic auth |
| Invoice or receipt tracker with file upload to S3 | IAM permissions for the instance role |

## Level 3: automate and release safely

| Idea | What you practise |
|---|---|
| GitHub Actions pipeline: test, build, push, deploy | CI/CD, image registry, versioned releases |
| Blue/green release with a CNAME swap and a smoke test | Zero-downtime deployment |
| Rolling and immutable deploys with automatic rollback | Deployment policies and health thresholds |
| Preview environments per pull request | Environment cloning and cleanup automation |
| Scheduled cleanup of idle environments | Cost control with scripts |

## Level 4: observe and operate

| Idea | What you practise |
|---|---|
| Alert grouping dashboard that cuts noisy alerts | Metrics, thresholds, incident logic |
| Deployment risk scorer from error rate and latency | Release gates and rollback decisions |
| Log triage tool that turns a failing log into a diagnosis | Reading `eb logs` and CloudWatch Logs |
| Load test and autoscaling report | Scaling triggers and capacity |
| Cost dashboard that finds idle AWS resources | FinOps, `AssumeRole`, savings estimates |

## Level 5: platform and tooling

| Idea | What you practise |
|---|---|
| Dockerfile and deployment kit generator | Production images, security scans |
| CLI wrapper for `eb` with version history and rollback | Automating the EB CLI and AWS CLI |
| Infrastructure as code for an environment (Terraform or CloudFormation) | Repeatable environments |
| Multi-environment promotion: dev, staging, production | Config management and approvals |

## Ideas that fit public-service problems

Builders in this community chose problems that matter locally: queue times, emergency resources, scholarship portals, scheme eligibility, scam checks and service availability. See them in the [showcase](showcase.md). A real problem also gives you a better story for your [resume](add-to-resume.md).

## Make it count

- Write a README with a screenshot, the stack and the deploy steps.
- Deploy it yourself and show the app running with its Elastic Beanstalk URL.
- Keep keys, passwords and your AWS account ID out of the repo and the screenshot.
- Terminate the environment and delete the application when you finish: [cleanup and cost](../notes/14-cleanup-and-cost.md).
- Submit it: [how to submit](README.md#how-to-submit).
