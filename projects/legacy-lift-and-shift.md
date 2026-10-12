# Legacy lift and shift: bring old code, run it as it is

Many teams still run PHP, Java or .NET applications that were written years ago. Elastic Beanstalk has managed platforms for those runtimes, so you can bring the code without rewriting it and without learning containers first.

This page deploys a tiny PHP app on the oldest PHP platform that new environments can still use, then moves the same code to a newer PHP in place. Everything was run on a real account in `us-west-2`.


## At a glance

| | |
|---|---|
| App | [examples/legacy-php](../examples/legacy-php), two files: `index.php` and `health.php` |
| Platform | PHP 8.2 on 64bit Amazon Linux 2023 (platform version 4.13.10, PHP 8.2.33) |
| Instance | One `t3.micro`, single-instance environment |
| Time | About 2 minutes to deploy, about 3 minutes to move to PHP 8.4 |
| You need | The tools from [setup/README.md](../setup/README.md) and the [IAM roles](../setup/iam-roles.md) |

Pick one way to run it: [Console](#run-it-with-the-console), [EB CLI](#run-it-with-the-eb-cli) (shortest) or [AWS CLI](#run-it-with-the-aws-cli).

## The app

`examples/legacy-php/index.php` prints the PHP version, the web server and the host name. `health.php` returns JSON with the version. There is no Composer file and nothing to build.

## Run it with the console

1. Zip `index.php` and `health.php` so the files are at the top level of the archive.
2. Elastic Beanstalk, **Create environment**, Standard, platform **PHP**, version PHP 8.2 on Amazon Linux 2023.
3. Application code **Local file**, then choose the ZIP.
4. Service access: as in [Project 1](project-1-single-tier.md#run-it-with-the-console), choose **Use another role** and pick `aws-elasticbeanstalk-service-role` and `aws-elasticbeanstalk-ec2-role`.
5. Open **Infrastructure**, choose a single instance on `t3.micro`, then choose **Create**.

The wizard is the same as in Project 1, with the platform changed to PHP. I did not click through these steps for this guide.

## Run it with the EB CLI

This is the shortest route. Install the EB CLI as shown in [Project 1](project-1-single-tier.md#run-it-with-the-eb-cli). Tested with EB CLI 3.27.3.

```bash
cp -r examples/legacy-php my-legacy-php && cd my-legacy-php
eb init my-legacy-php --platform "PHP 8.2 running on 64bit Amazon Linux 2023" --region us-west-2
eb create my-legacy-php-env --single --instance-type t3.micro \
  --instance_profile aws-elasticbeanstalk-ec2-role \
  --service-role aws-elasticbeanstalk-service-role
```

From `eb init` to a running page took about 2 minutes. The Events output includes a line saying that there is no `composer.json` in the bundle, so no Composer dependencies were installed. That is expected for this app.

Edit a file and run `eb deploy`. A one-line change to `index.php` went live in about 25 seconds.

### Why there is a ZIP

Platforms other than Docker take a source bundle: a ZIP archive, or a WAR for Java. The EB CLI builds that archive from your folder and uploads it, so you never touch it. The log line `Creating application version archive "app-...zip"` is that step. Docker deploys are the only ones in this repo where you upload a single plain file instead.

## Run it with the AWS CLI

Here you make the ZIP yourself. The result is the same environment, built in about 2 minutes. Run it from a folder that holds `index.php` and `health.php`.

```bash
zip -q legacy-php.zip index.php health.php
BUCKET=$(aws elasticbeanstalk create-storage-location --query S3Bucket --output text)
aws s3 cp legacy-php.zip s3://$BUCKET/my-legacy-php/legacy-php-1.zip
aws elasticbeanstalk create-application --application-name my-legacy-php-zip
aws elasticbeanstalk create-application-version --application-name my-legacy-php-zip \
  --version-label v1 --source-bundle S3Bucket=$BUCKET,S3Key=my-legacy-php/legacy-php-1.zip
aws elasticbeanstalk create-environment --application-name my-legacy-php-zip \
  --environment-name my-legacy-php-zip-env --version-label v1 \
  --solution-stack-name "64bit Amazon Linux 2023 v4.13.10 running PHP 8.2" \
  --option-settings \
    Namespace=aws:autoscaling:launchconfiguration,OptionName=IamInstanceProfile,Value=aws-elasticbeanstalk-ec2-role \
    Namespace=aws:elasticbeanstalk:environment,OptionName=ServiceRole,Value=aws-elasticbeanstalk-service-role \
    Namespace=aws:elasticbeanstalk:environment,OptionName=EnvironmentType,Value=SingleInstance \
    Namespace=aws:ec2:instances,OptionName=InstanceTypes,Value=t3.micro
```

Keep the files at the top level of the ZIP, with no parent folder.

## Check it works

![The PHP app running on PHP 8.2](../images/legacy-php-82.png)

```bash
curl http://<your-environment-cname>/             # "Lift and shift", the PHP version
curl http://<your-environment-cname>/health.php   # {"status":"ok","php":"8.2.33"}
```

## Move the same code to a newer PHP

The environment from the EB CLI section can change platform in place. Nothing in the app changes.

```bash
aws elasticbeanstalk update-environment --environment-name my-legacy-php-env \
  --solution-stack-name "64bit Amazon Linux 2023 v4.13.10 running PHP 8.4"
```

The update took about 3 minutes and 20 seconds. Afterwards `/health.php` returned `{"status":"ok","php":"8.4.26"}`, and the environment was Green. The same two files ran on 8.2 and then on 8.4.

Your own application may use features that changed between versions, so run its tests before you move. The point is that the move is one command and the environment keeps its URL.

## Clean up

```bash
eb terminate my-legacy-php-env --force
aws elasticbeanstalk delete-application --application-name my-legacy-php
aws elasticbeanstalk terminate-environment --environment-name my-legacy-php-zip-env
aws elasticbeanstalk wait environment-terminated --environment-names my-legacy-php-zip-env
aws elasticbeanstalk delete-application --application-name my-legacy-php-zip
```

The bundles that were uploaded stay in the account's Elastic Beanstalk S3 bucket (`elasticbeanstalk-<region>-<account-id>`). They are a few hundred bytes each. Delete them under the key prefix you used if you want the bucket empty.

## Which versions are available

The platform lists below come from `aws elasticbeanstalk list-available-solution-stacks` and the AWS platform documentation, checked on 11 October 2026. Platform versions change often, so list them again before you start.

| Runtime | Platforms for new environments |
|---------|--------------------------------|
| PHP | 8.2, 8.3, 8.4 (and 8.5 in the solution stack list), all on Amazon Linux 2023 |
| Java SE | Corretto 8, 11, 17, 21, 25 |
| Tomcat | Tomcat 9 with Corretto 8, 11 or 17. Tomcat 10 with Corretto 17 or 21. Tomcat 11 with Corretto 17, 21 or 25 |
| .NET on Linux | .NET 8, 9, 10 |
| .NET on Windows Server | Windows Server 2019, 2022 and 2025 (plus Server Core) with IIS 10.0. Supports .NET Framework 4.x and 2.0, and .NET 8, 9 and 10 |

Platform branches retire when a part of the stack reaches end of life. The AWS documentation says:

- PHP 8.1 on Amazon Linux 2023 and on Amazon Linux 2 retired on 16 April 2026. All Amazon Linux 2 platform branches were set to retired on 6 August 2026. Older PHP branches, from 5.3 to 8.0, are retired too.
- PHP 8.2 on Amazon Linux 2023 is scheduled for retirement on 31 March 2027, and the .NET 8 and .NET 9 Linux platforms on the same date.
- Once a branch is retired, Elastic Beanstalk stops maintenance and security updates for it, and new customers can no longer create environments on it. Existing environments get a 90 day grace period from the retirement date.
- For an application that cannot move to a supported platform, the documented workaround is to package it as a Docker image and use the Docker platform. That is the route Projects 1 and 2 already follow.

So the lift-and-shift story is real for any runtime that is still supported, and the retirement dates are the ceiling. Do not promise that any old version runs forever.

Source pages: [supported platforms](https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html), [platforms scheduled for retirement](https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-retiring.html), [platform support policy](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-support-policy.html), [PHP 8.1 retirement notice](https://docs.aws.amazon.com/elasticbeanstalk/latest/relnotes/release-2026-04-16-php81-retire.html).

## Cost

Elastic Beanstalk itself has no extra charge. You pay for the resources it creates, such as the instance. The AWS pricing guidance says the AWS Free Tier offer applies to Standard Mode only, for new AWS accounts during the 6 month Free Tier period. Check your own account's Free Tier terms and usage limits before you rely on it.

## Not tested

- Java (Tomcat or Java SE) and .NET (Linux or Windows) were not deployed. The platform tables above come from the AWS documentation and the CLI, not from a run.
- The console flow was not clicked through.
- Platforms older than PHP 8.2 cannot create new environments, so the oldest runtime in this test is PHP 8.2.
