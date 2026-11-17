# Community Projects

Built something on Elastic Beanstalk? Add it here. The [showcase](showcase.md) lists what learners from the TrainWithShubham community deployed, with a link to each repo. Your entry needs a screenshot of the app running and a link to your code.

It also doubles as your entry for **#BuildOnElasticBeanstalk**. Check the video description for the current hackathon rules and dates.

## What to share

1. A **screenshot of your app running** on its Elastic Beanstalk URL.
2. A **link to your public repo** with the code.
3. A few lines on what you built and how you deployed it.

## How to submit

**Option A: pull request** (best if you are comfortable with Git)

1. Fork this repo.
2. Copy [`projects/_template.md`](projects/_template.md) to `projects/<your-github-username>-<app-name>.md` and fill it in.
3. Put your screenshot in `projects/images/` with the same name prefix, for example `projects/images/asha-todo.png`.
4. Open a pull request titled `Community project: <app name>`.

**Option B: issue** (no Git needed)

Open a [Community project issue](../../issues/new?template=community-project.yml), fill in the form and attach your screenshot. We add it for you.

## Guidelines

**Do**

- Deploy it yourself on Elastic Beanstalk. Standard Mode and Cluster Mode both count.
- Show the app **running**: the page in the browser with the Elastic Beanstalk URL visible, or the console showing health **Ok**.
- Make your repo public and add a README that explains how to run it.
- Say which way you deployed: console, EB CLI, AWS CLI or a CI/CD pipeline.
- Post it on LinkedIn or X with **#BuildOnElasticBeanstalk** and tag TrainWithShubham.

**Do not**

- Share secrets. Check your screenshot and repo for access keys, passwords, tokens and `.env` files.
- Show your **AWS account ID** or ARNs in the screenshot. Crop or blur them.
- Submit a copy of Project 1, 2 or 3 unchanged. Changing the app, the database or the pipeline is what makes it yours.
- Leave the environment running after you take the screenshot. Terminate it, then delete the application. See [cleanup and cost](../notes/14-cleanup-and-cost.md).

**Screenshot tips**

- Use a window of about 1280 px wide. PNG or JPG, under 1 MB.
- Include the URL bar when you can.
- The console's **Environments** list with health **Ok** is a good second image.

## Review

A maintainer checks each submission for secrets, account IDs and a working repo link, then merges it. We may ask you to change the screenshot. We do not judge the hackathon here; follow the official rules for that.

## Showcase

28 community projects are listed in the **[Showcase](showcase.md)**, grouped by theme, with links to each repo and the builder's LinkedIn posts. Add yours with the steps above.

## More for builders

- [Project ideas](project-ideas.md): five levels, from a first deploy to platform tooling
- [Add it to your resume](add-to-resume.md): bullets, LinkedIn post template and a repo checklist
