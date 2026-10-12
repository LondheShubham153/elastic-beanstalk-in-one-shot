# 10. Project 2: two-tier Flask and MySQL app

A Flask app that stores messages in MySQL, deployed first on Standard Mode (MySQL in a container) and then on Cluster Mode (database on Amazon RDS).

Steps: [projects/project-2-two-tier.md](../projects/project-2-two-tier.md)

## What you will do

1. Look at the repo's `beanstalk/docker-compose.yml` and its placeholder passwords.
2. Standard Mode: create the environment on a `t3.small` (console, or `eb init` and `eb create`), wait for Green, post a message.
3. Cluster Mode: create the RDS instance and allow the environment's security group on port 3306.
4. Create the environment with the image, service port 5000 and the `env-variables` option.
5. Open the HTTPS URL, post a message and confirm it landed in RDS.

Two tiers means the web app and the database. Standard Mode runs both from one compose file. Cluster Mode runs only the app, so the database moves to RDS. That is a good habit anyway: terminating the environment does not delete your data.

## Common problems

- The EB CLI covers Standard Mode only. Cluster Mode uses the AWS CLI or the console.
- `t3.micro` hangs on the MySQL plus Flask compose file. Use `t3.small`.
- Service port must be 5000 on Cluster Mode.
- The RDS security group must allow the environment's security group.
- The Cluster Mode URL answers on HTTPS only.
- Do not leave `opts.json` (it holds the database password) in a repo.
- Delete the RDS instance and both environments afterwards.
