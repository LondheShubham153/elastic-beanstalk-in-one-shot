# 14. Cleanup and cost

Deleting what you built is part of the lesson. People forget, and the bill arrives later. Say this before Project 1 and again at the end.

## What costs money
Elastic Beanstalk has no service fee in either mode. You pay for the resources it creates.

| Resource | Standard Mode | Cluster Mode |
|---|---|---|
| Compute | The EC2 instances you pick | EC2 compute sized to the CPU and memory you ask for |
| Load balancer | One if the environment is load balanced, none for single-instance | One Application Load Balancer per environment |
| Storage | EBS volumes | Container image storage |
| Managed foundation | None | A flat hourly fee per shared foundation, plus a management fee on the compute |
| Database | RDS, if you use one (Project 2 Cluster) | Same |

For a single app at low traffic, AWS guidance says Standard Mode is usually cheaper. The new-account Free Tier applies to Standard Mode only. Source: [AWS Elastic Beanstalk pricing](https://aws.amazon.com/elasticbeanstalk/pricing/) and the pricing and cost modeling page in the AWS docs.

## Clean up checklist
- [ ] Terminate every environment (`aws elasticbeanstalk terminate-environment`, or `eb terminate`)
- [ ] Delete the application once its environments are gone (`aws elasticbeanstalk wait environment-terminated` first)
- [ ] Delete the RDS instance, then its security group and subnet group (Project 2 Cluster Mode)
- [ ] Remove uploaded versions and files from the S3 bucket whose name starts with `elasticbeanstalk-`
- [ ] Check the EC2 console for leftover instances and Elastic IPs
- [ ] Check again the next day: shared Cluster Mode infrastructure goes up to 3 hours after your last environment ends, and billing continues until it is gone

## Verify nothing is left
```bash
aws elasticbeanstalk describe-environments --query 'Environments[?Status!=`Terminated`].EnvironmentName' --output text
aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier' --output text
aws ec2 describe-instances --filters Name=instance-state-name,Values=running,pending \
  --query 'Reservations[].Instances[].InstanceId' --output text
```

All three should print nothing. These checks were run at the end of every test in this repo.

## Gotchas
- Terminating an environment that is still updating can fail. Wait for it to finish and try again.
- `delete-application` fails right after `terminate-environment`. Wait for the termination first.
- The two IAM roles from the setup page cost nothing, so leave them.
- Put a budget alert on the account before the first deploy.

