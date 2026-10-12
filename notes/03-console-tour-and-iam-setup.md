# 3. Console tour and AWS/IAM setup

Finish the [setup](../setup/README.md) and create the IAM roles first ([setup/iam-roles.md](../setup/iam-roles.md), about 2 minutes), then open Elastic Beanstalk. The Standard Mode wizard can create them for you with **Create default role**, but making them first is more reliable and the CLI routes need them.

## Order

1. Sign in as an IAM user, not the root user. Pick a region and stay in it. The tested commands use `us-west-2`.
2. Create the roles from the setup page.
3. Open Elastic Beanstalk and look through the left menu.
4. Open Create environment and stop before submitting. Project 1 does the real create.

## Pages to look at

| Page | What to look for |
|------|------------------|
| Applications and environments | One row per environment, with its health color |
| Create environment | Deployment mode (Standard or Cluster), environment tier, platform, application code |
| Service access step | The service role and the EC2 instance profile. Choose **Use another role** and pick the ones from the setup page, or keep **Create default role** |
| Environment overview | Health, the running version, the URL |
| Events | A running log of what Elastic Beanstalk is doing |
| Configuration | The settings groups you change in chapter 5 |
| Application versions | Every uploaded version, with its S3 source |
| Saved configurations | Reusable settings |

## Common problems

- The roles must exist before you create the environment, so do the setup page first.
- Console labels change between releases. The names above come from the AWS docs and CLI, so a label in your console may differ slightly.
- Do not use the root user.
