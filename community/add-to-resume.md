# Add your Elastic Beanstalk project to your resume

A deployed project is proof you can ship. Recruiters and hiring managers skim, so make the project easy to scan: what you built, how it runs on AWS and one result.

## Where it goes

- **Projects section** for most people. Put it near the top if you have little work experience.
- **Experience section** only if you built it for an employer or a client.
- **Skills section**: add the tools you actually used, such as AWS Elastic Beanstalk, Docker, GitHub Actions, Amazon RDS, Linux, CI/CD.

## The bullet formula

> **Action verb** + **what you built** + **how it runs (services and tools)** + **a result you can defend**

Good bullets are specific and short, one line or two.

## Examples to adapt

Replace the details with your own. Only claim numbers you measured.

**Single-tier app (Project 1 style)**

- Deployed a containerised store app to AWS Elastic Beanstalk (Standard Mode) from a Docker Hub image, with health monitoring and a public HTTPS endpoint.

**Two-tier app with a database (Project 2 style)**

- Deployed a Flask and MySQL app on AWS Elastic Beanstalk with Amazon RDS, secured the database with a security group rule and passed settings through environment properties.
- Moved the same app from Standard Mode to Cluster Mode and fixed target health failures by tracing load balancer errors to a missing database and a missing port rule.

**CI/CD (Project 3 style)**

- Built a GitHub Actions pipeline that tests, builds a Docker image and deploys to Elastic Beanstalk on every push to `main`, cutting a manual release from about [X] minutes to a single merge.

**Deployment strategy and reliability**

- Used rolling and blue/green deployments with a CNAME swap to release with no downtime, and rolled back a bad version from the console.
- Configured auto scaling on CPU and request count (min [X], max [Y]) and verified it under load.

**Legacy lift and shift**

- Moved a legacy PHP application to a supported Elastic Beanstalk platform without rewriting the code.

**Cost awareness**

- Cleaned up all environments and applications after testing and kept the project inside the AWS Free Tier.

## Project entry template

```text
Project name | Live link (only if it is running) | GitHub link
Stack: Python, Flask, Docker, Amazon RDS, GitHub Actions
AWS: Elastic Beanstalk (Standard Mode), RDS MySQL, CloudWatch, IAM
- Bullet 1: what it does and who it helps
- Bullet 2: how you deployed it
- Bullet 3: one thing that went wrong and how you fixed it
```

## LinkedIn

1. **Projects section**: add the project, link the repo and tag the skills (AWS Elastic Beanstalk, Docker, CI/CD).
2. **Featured section**: pin your hackathon post so it is the first thing visitors see.
3. **Post template**:

```text
I deployed [app name] on AWS Elastic Beanstalk.

What it does: [one line]
How it runs: [stack, database, pipeline]
The hardest bug: [one line] and how I fixed it.

Code: [GitHub link]

#BuildOnElasticBeanstalk #AWS #DevOps
```

Tag AWS and TrainWithShubham, and add a screenshot of the app running.

## Keywords for applicant tracking systems

Use the words from the job description when they match your work. Common ones for this project type:

`AWS Elastic Beanstalk`, `Docker`, `CI/CD`, `GitHub Actions`, `Amazon RDS`, `Auto Scaling`, `Elastic Load Balancing`, `CloudWatch`, `IAM`, `blue/green deployment`, `rolling deployment`, `infrastructure`, `monitoring`, `Linux`

## Make the repo match the resume

A recruiter will click your GitHub link. In five minutes you can fix the usual gaps:

- [ ] README opens with one line on what the app does, plus a screenshot
- [ ] Architecture in a few lines or a small diagram
- [ ] Steps to run it locally and to deploy it
- [ ] No keys, passwords, `.env` files or AWS account ID anywhere in the history
- [ ] Repo description and topics set (`aws`, `elastic-beanstalk`, `devops`)
- [ ] Pinned on your GitHub profile

## Common mistakes

- Listing every AWS service you touched once. Keep the ones you can explain in an interview.
- Inventing metrics. If you did not measure it, describe what you did instead.
- Leaving a dead live link. Remove it after you tear the environment down, and point to the screenshot.
- Copying a tutorial project unchanged. Change the app, the database or the pipeline so the work is yours.

## Be ready to explain it

Interviewers ask about what you wrote. Prepare a short answer for each:

1. What problem does the app solve?
2. Why Elastic Beanstalk, and what does it manage for you?
3. Standard Mode or Cluster Mode, and why?
4. How do you deploy, and how do you roll back?
5. What broke, and how did you find the cause?

See what others built in the [community showcase](showcase.md), and pick a [project idea](project-ideas.md) to build next.
