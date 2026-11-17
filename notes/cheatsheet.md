# Elastic Beanstalk cheatsheet

A quick reference for the commands you use most. The project pages hold the full, tested steps for each project. This sheet is a general reference, so check `eb <command> --help` if a flag differs on your version.

## EB CLI

| Task | Command |
|---|---|
| Set up an app folder | `eb init` |
| Set up with a platform and region | `eb init my-app --platform docker --region us-west-2` |
| Create an environment | `eb create my-env` |
| Deploy the current code | `eb deploy` |
| See environment status | `eb status` |
| See health | `eb health` |
| Open the app in a browser | `eb open` |
| Recent events | `eb events` |
| Download logs | `eb logs` |
| Set environment properties | `eb setenv KEY=value OTHER=value` |
| Show environment properties | `eb printenv` |
| Change instance count | `eb scale 2` |
| Edit environment settings | `eb config` |
| Clone an environment | `eb clone my-env` |
| Swap URLs for blue/green | `eb swap my-env --destination_name other-env` |
| List environments | `eb list` |
| Switch environment | `eb use my-env` |
| Delete an environment | `eb terminate my-env` |

## AWS CLI

| Task | Command |
|---|---|
| List environments | `aws elasticbeanstalk describe-environments` |
| Full health detail | `aws elasticbeanstalk describe-environment-health --environment-name my-env --attribute-names All` |
| Recent events | `aws elasticbeanstalk describe-events --environment-name my-env` |
| Application versions | `aws elasticbeanstalk describe-application-versions --application-name my-app` |
| Terminate an environment | `aws elasticbeanstalk terminate-environment --environment-name my-env` |
| Delete an application | `aws elasticbeanstalk delete-application --application-name my-app` |

Always pass `--region` or set a default region, so you look at the right place.

## Files Elastic Beanstalk reads

| File or folder | Purpose |
|---|---|
| `Dockerfile` or `docker-compose.yml` | What to run on a Docker platform |
| `Dockerrun.aws.json` | Container settings for a single container image |
| `.ebextensions/*.config` | Settings and resources as YAML or JSON |
| `.platform/hooks/` | Scripts that run at predeploy, postdeploy and similar stages |
| `.platform/nginx/` | Proxy configuration overrides |
| `.elasticbeanstalk/config.yml` | EB CLI settings created by `eb init` |

A working example is in [`examples/ebextensions-demo`](../examples/ebextensions-demo).

## Deployment policies

| Policy | Downtime | Speed | Use when |
|---|---|---|---|
| All at once | Yes, briefly | Fastest | Development and testing |
| Rolling | No | Medium | Small capacity loss is fine |
| Rolling with additional batch | No | Medium | You need full capacity during the release |
| Immutable | No | Slower | You want a clean rollback |
| Blue/green (clone and swap URLs) | No | Slowest | You want to test before switching traffic |

More in [chapter 7](07-deployment-strategies.md).

## Troubleshooting order

1. `eb health --refresh` or the console **Health** tab.
2. `eb events` for the first error in the sequence.
3. `eb logs` and read `eb-engine.log` first.
4. Check the load balancer target health and the health check path.
5. Check security groups, especially the database port.
6. Check environment properties for typos and missing values.
7. Redeploy a known good version if you need service back first.

## Cost reminders

- Terminate environments you are not using, then delete the application.
- Standard Mode is Free Tier eligible for new AWS accounts. Cluster Mode is not.
- Check the load balancer, RDS instances and unused Elastic IPs after cleanup.

Full checklist: [cleanup and cost](14-cleanup-and-cost.md).
