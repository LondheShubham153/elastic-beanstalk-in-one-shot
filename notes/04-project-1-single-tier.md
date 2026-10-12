# 4. Project 1: single-tier app on Standard Mode

A one-page store goes from a public Docker Hub image to a live URL on Elastic Beanstalk with one small file.

Step-by-step: [projects/project-1-single-tier.md](../projects/project-1-single-tier.md)

## What you will do

1. Look at the one-file `beanstalk/docker-compose.yml` (the image and the port).
2. Create a Standard Mode environment on the Docker platform, uploading that file.
3. Pick the two roles from chapter 3 on the Service access step.
4. Accept the defaults and create the environment.
5. Watch the Events tab while it launches, then open the URL.
6. Do it again from the AWS CLI and the EB CLI, and try the same image on Cluster Mode.

The same flow works for Java, .NET, Node.js, Python, PHP, Ruby, Go or Docker. We deploy first and explain later: chapters 5 to 8 cover what you just clicked.

## Common problems

- Build the image for amd64 (and arm64 for Apple silicon laptops), or the instance cannot run it.
- Pin the image tag instead of using `latest`.
- Leave Version label blank. AWS generates one.
- Check that health is Green before sharing the URL.
- Delete the environment when you finish.
