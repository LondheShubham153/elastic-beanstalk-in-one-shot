# ebextensions demo

A Project 1 style bundle with two extension points added:

- `.ebextensions/01-options.config` sets an environment property and the load balancer health check path.
- `.platform/hooks/postdeploy/01-hello.sh` is a script that runs on each instance after every deploy. Its output goes to `/var/log/eb-hooks.log`.

This is the one place in the repo where you do upload a ZIP, because extension folders only work from a bundle. Build it from inside this folder so the files sit at the root of the ZIP:

```bash
zip -r ../ebextensions-demo.zip . -x README.md
```

Chapter 5 shows how to deploy it and what to check.
