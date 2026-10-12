# 2. Primitives and concepts

Six words carry most of Elastic Beanstalk. Learn these once and the rest of the course reads easily. Definitions follow the AWS concepts page.

## The six primitives
| Term | Plain meaning |
|------|---------------|
| Application | A folder for everything about one app: its environments, versions and saved settings |
| Application version | One labeled, deployable build of your code. It points at a file in S3 |
| Environment | The running AWS resources (instances, load balancer and so on) for one application version |
| Environment tier | What kind of environment: web server (answers HTTP), worker (reads an SQS queue) or Cluster Mode |
| Environment configuration | The settings that define how the environment behaves. Changing them updates or replaces resources |
| Platform | The operating system, runtime, web server and Elastic Beanstalk software that your code targets |

A saved configuration is a template of settings. You can start a new environment from it. The API and CLI call it a configuration template.

One environment runs one version at a time. You can run the same version in many environments, for example staging and production.

## Draw this on the board
```
Application: my-store
  Versions:      v1  v2  v3
  Environments:  my-store-prod (runs v3)    my-store-staging (runs v2)
```

## Two deployment modes
| | Standard Mode | Cluster Mode |
|---|---|---|
| Runs your app on | EC2 instances | Containers, managed for you |
| You provide | Code, a compose file, a Dockerfile or a ZIP | A container image |
| Tiers | Web server, worker | Cluster |
| Free Tier | Eligible for new accounts | Not eligible |

Most of this course uses Standard Mode. Cluster Mode arrives in chapter 9.

## What Elastic Beanstalk does for you
Provisioning, load balancing, health monitoring, scaling, rolling updates and automatic rollback on a failed deployment. You keep full access to the underlying resources if you want them.

## Gotchas
- An environment, not an application, is what costs money. Applications and versions are free to keep.
- "Platform" is the Elastic Beanstalk word for the runtime stack. It has versions, and AWS retires old ones.
- A worker environment needs an SQS queue and does not serve web traffic. This course does not build one.

