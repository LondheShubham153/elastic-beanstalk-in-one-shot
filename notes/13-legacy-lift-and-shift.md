# 13. Legacy lift and shift

Companies still run old PHP, Java and .NET applications. Elastic Beanstalk can run them without a rewrite, as long as the runtime is still on a supported platform. This chapter shows an old PHP app moving onto Elastic Beanstalk and then to a newer PHP version.

Steps: [projects/legacy-lift-and-shift.md](../projects/legacy-lift-and-shift.md)

## Gotchas
- Non-Docker platforms need a source bundle, which is a ZIP (or a WAR for Java). The EB CLI makes it for you. With the AWS CLI you make and upload it yourself, with the files at the top level of the archive.
- Old platform branches cannot create new environments. The oldest PHP that worked in this test is 8.2.
- The EB CLI prints that there is no `composer.json`. It is only information for an app with no dependencies.
- Check your own app against the newer PHP version before moving it. The move itself is a single command.
- Platform versions change often. List them again before you start.

