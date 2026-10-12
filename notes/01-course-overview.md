# 1. Course overview

Elastic Beanstalk is a powerful PaaS on AWS. You bring your code or a container image, and AWS sets up the servers, load balancer, health checks and scaling for you. This repo walks you through it with three projects, from a single page to a pipeline that deploys on every push.

## What you will learn

| Part | What you do |
|------|-------------|
| Concepts | Application, environment, version, platform, and the two deployment modes |
| Console tour | Where everything is, and the IAM roles to create first |
| Project 1 | Deploy a one-page store from a Docker Hub image with one small file |
| Deep dive | Configuration, scaling, deployment strategies, health and logs |
| Cluster Mode | The same image on a managed engine, and what changes |
| Project 2 | A Flask app with MySQL, on Standard Mode and then on Cluster Mode with RDS |
| Legacy apps | Move old PHP, Java or .NET code as it is |
| Project 3 | A GitHub Actions pipeline that deploys on every push |
| Wrap-up | Cleanup, cost, and next steps |

## What it costs

- Elastic Beanstalk has no service fee. You pay for the resources it creates, such as EC2 instances and load balancers.
- For new AWS accounts the AWS Free Tier covers Standard Mode during the first 6 months. Cluster Mode is not Free Tier eligible.
- It supports Java, .NET, Node.js, Python, PHP, Ruby, Go and Docker, so an existing app does not need a rewrite.

Delete what you create when you finish each project. See [14-cleanup-and-cost.md](14-cleanup-and-cost.md).

## What you need

- An AWS account, and an IAM user (not the root user) that can create Elastic Beanstalk environments and IAM roles
- AWS CLI v2, signed in
- The EB CLI for the shorter deploys
- Python 3, Git, curl, zip and openssl
- A bash-style shell (WSL 2 or Git Bash on Windows)
- A GitHub account (Project 3)
- Docker installed locally (optional)

Install steps for macOS, Linux and Windows are in [setup/README.md](../setup/README.md).

## Where to start

Work through [setup/README.md](../setup/README.md), which ends with the two IAM roles ([setup/iam-roles.md](../setup/iam-roles.md)). Then open [chapter 2](02-primitives-and-concepts.md).
