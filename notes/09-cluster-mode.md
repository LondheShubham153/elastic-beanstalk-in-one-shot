# 9. Cluster Mode

Cluster Mode is the second deployment mode in Elastic Beanstalk. You hand it a container image and AWS runs the operations around it.

Steps: [Project 1, Cluster Mode section](../projects/project-1-single-tier.md) and [Project 2, Cluster Mode deploy](../projects/project-2-two-tier.md).

## What differs from Standard Mode
| | Standard | Cluster |
|---|---|---|
| You provide | Compose file, Dockerrun, ZIP or Dockerfile | One container image |
| Roles | Service role and EC2 instance profile (chapter 3) | Three Cluster Mode roles, picked by the console |
| Port | Whatever you publish in compose | Service port, default 8080 |
| URL | HTTP | HTTPS only |
| First environment | About 2.5 to 3.5 minutes | About 22 minutes (builds shared infrastructure) |
| Next environments | Same | About 3 minutes |
| Environment variables | One option per variable | One JSON option, `env-variables` |

All timings come from real runs in `us-west-2`.

## Gotchas
- The environment URL does not answer on plain HTTP. Always use `https://`.
- If the image listens on a port other than 8080, set `service-port`. Project 2 needs 5000.
- A database has to be outside the environment. Allow the environment's security group on port 3306.
- Environment variables set one by one are rejected. Use the single JSON option.
- `env-variables` stores values as plain text. Use the `secrets` option for real passwords (not tested here).
- Shared infrastructure is deleted up to 3 hours after the last Cluster Mode environment ends, and billing continues until then.
- The first environment is slow. Start it, then read the rest while it builds.

