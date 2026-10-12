# Setup: everything you need before you start

Do this page once. It takes about 20 minutes. At the end, one script checks that your machine is ready, and the IAM roles are the last step.

| Step | What | Time |
|------|------|------|
| 1 | [An AWS account and a safe sign-in](#1-an-aws-account-and-a-safe-sign-in) | 5 min |
| 2 | [A shell that runs the commands](#2-a-shell-that-runs-the-commands) | 2 min |
| 3 | [Install the AWS CLI v2](#3-install-the-aws-cli-v2) | 3 min |
| 4 | [Sign in from the AWS CLI](#4-sign-in-from-the-aws-cli) | 3 min |
| 5 | [Install the EB CLI](#5-install-the-eb-cli) | 3 min |
| 6 | [Other tools](#6-other-tools) | 2 min |
| 7 | [Check everything](#7-check-everything) | 1 min |
| 8 | [Create the IAM roles](iam-roles.md) | 2 min |

The commands in this repo were tested on macOS with AWS CLI 2.37.5, EB CLI 3.27.3 and Python 3.14, in `us-west-2`. The Linux and Windows install steps below come from the AWS documentation and were not run on those systems for this guide.

## 1. An AWS account and a safe sign-in

1. Create an AWS account at [aws.amazon.com](https://aws.amazon.com). New accounts get a Free Tier plan for Standard Mode. [Chapter 14](../notes/14-cleanup-and-cost.md) explains what costs money.
2. Do not use the root user for daily work. Sign in as an IAM user, or as an IAM Identity Center user, that can create Elastic Beanstalk environments and IAM roles. In a personal practice account, the `AdministratorAccess` policy is the simplest choice. In a shared or company account, ask your admin for the permissions.
3. Turn on a billing alert so a forgotten environment cannot surprise you. In the console, open **Billing and Cost Management**, then **Budgets**, and create a small monthly budget with an email alert.

## 2. A shell that runs the commands

Every command in this repo is written for a bash-style shell.

| System | Use |
|--------|-----|
| macOS | Terminal. zsh and bash both work |
| Linux | Any terminal. bash and zsh both work |
| Windows | **WSL 2** with Ubuntu (best), or **Git Bash** from [Git for Windows](https://git-scm.com/download/win). Do not paste the commands into PowerShell or Command Prompt, because `export`, `$(...)` and `<<EOF` blocks will fail there |

Windows with WSL 2: open PowerShell as administrator, run `wsl --install`, restart, then open **Ubuntu** from the Start menu. From here on, follow the **Linux** steps inside Ubuntu.

Windows with Git Bash: follow the **Windows** steps for installing, and run the repo commands inside Git Bash.

## 3. Install the AWS CLI v2

Install **version 2**. Version 1 uses the same `aws` command, so check the version at the end.

### macOS

```bash
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
```

This installs for the current user. Prefer a point-and-click installer? Download [AWSCLIV2.pkg](https://awscli.amazonaws.com/AWSCLIV2.pkg) and run it.

### Linux

```bash
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
```

This works on x86 and ARM, and installs under `~/.local`. If `aws` is not found afterwards, add `~/.local/bin` to your `PATH`. The older route, if you have `sudo`:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"    # ARM: awscli-exe-linux-aarch64.zip
unzip awscliv2.zip
sudo ./aws/install
```

You need `curl` and `unzip` for this. On Ubuntu: `sudo apt install curl unzip`.

### Windows

Download and run the installer: [AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi) (all users, needs admin) or [AWSCLIV2-User.msi](https://awscli.amazonaws.com/AWSCLIV2-User.msi) (current user, no admin). Then close and reopen your terminal.

If you use WSL 2, skip this and follow the Linux steps inside Ubuntu instead.

### Check it

```bash
aws --version
```

You should see `aws-cli/2.` at the start. If it says `aws-cli/1.`, you have the old version. Remove it and install v2. Source: [AWS CLI install guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

## 4. Sign in from the AWS CLI

Pick the option that matches how you sign in to AWS.

**Console sign-in (short-lived, recommended).** Works for IAM users and federated users:

```bash
aws login
```

**IAM Identity Center (SSO).** If your company or school gave you an SSO start URL:

```bash
aws configure sso
```

**Access keys.** Create an access key for your IAM user in the console (**IAM**, **Users**, your user, **Security credentials**), then:

```bash
aws configure
```

Enter the key ID and secret, `us-west-2` as the default region, and `json` as the output format. Keep the keys private. Never put them in a repo, a screenshot or a chat. Delete the key from the console when you finish the course.

Then set the region for your shell session, because some commands read it from the environment:

```bash
export AWS_REGION=us-west-2
```

In Git Bash and WSL this is the same. The commands in this repo were tested in `us-west-2`. You can use another region, but then list the platform names again with `aws elasticbeanstalk list-available-solution-stacks`, and expect Cluster Mode availability to differ.

Check who you are signed in as:

```bash
aws sts get-caller-identity
```

You should see an account ID and an ARN that is **not** `:root`. The EB CLI in this repo was tested with access keys stored by `aws configure`. If `eb` cannot find your credentials with another sign-in method, use that route for the EB CLI steps.

## 5. Install the EB CLI

The EB CLI is a separate tool from the AWS CLI. It makes the single-instance Standard Mode deploys much shorter. You need Python 3 and either of the two routes below.

### Route A: a virtual environment with pip (tested)

This keeps the EB CLI separate from your other Python tools.

```bash
python3 -m venv ~/eb-ve
source ~/eb-ve/bin/activate
pip install awsebcli --upgrade
eb --version
```

On **Windows with Git Bash**, activate with `source ~/eb-ve/Scripts/activate` and use `python` instead of `python3`. In Windows PowerShell or Command Prompt it is `%USERPROFILE%\eb-ve\Scripts\activate`.

You activate it again in every new terminal. When you finish, run `deactivate`.

### Route B: AWS installer script

AWS recommends this one. It needs Git, Python and `virtualenv`.

```bash
git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
python ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py
```

On Windows PowerShell, the second line is `python .\aws-elastic-beanstalk-cli-setup\scripts\ebcli_installer.py`. The script prints the line to add to your `PATH` when it finishes.

### Route C: Homebrew on macOS

```bash
brew install awsebcli
```

Homebrew can lag a few days behind pip.

### Check it

```bash
eb --version
```

You should see `EB CLI 3.` and a Python version. Source: [EB CLI install guide](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html).

## 6. Other tools

| Tool | Needed for | Install |
|------|------------|---------|
| Python 3 | The EB CLI, and a short script in Project 2 | macOS: `brew install python` or [python.org](https://www.python.org/downloads/). Ubuntu: `sudo apt install python3 python3-venv python3-pip`. Windows: [python.org](https://www.python.org/downloads/), tick **Add python.exe to PATH** |
| Git | Cloning, and Route B above | macOS: `xcode-select --install`. Ubuntu: `sudo apt install git`. Windows: [Git for Windows](https://git-scm.com/download/win) |
| curl | Downloading the project files | Already on macOS, Linux and Windows 10 and later. In Windows PowerShell, call it as `curl.exe`. Git Bash has it |
| zip and unzip | Chapter 5 and the legacy page | macOS: built in. Ubuntu: `sudo apt install zip unzip`. Git Bash: add `zip` from [GnuWin32](https://gnuwin32.sourceforge.net/packages/zip.htm), or use WSL 2 |
| openssl | Project 2 (a random database password) | macOS and Linux: built in. Git Bash: included |
| Docker (optional) | Testing an image on your machine before you deploy | [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine. Not needed to follow the course |
| A GitHub account | Project 3 and Community Projects | [github.com](https://github.com) |

## 7. Check everything

From the repo folder, run:

```bash
bash setup/check-setup.sh
```

It prints a tick or a cross for each item and tells you what to fix. Everything required should show a tick before you start Project 1.

## 8. Create the IAM roles

Last step: [create the two IAM roles](iam-roles.md) that Standard Mode needs. You can use the console or the CLI, and it takes about 2 minutes. You do it once per AWS account.

Then go to [Project 1](../projects/project-1-single-tier.md).

## Common problems

- `aws: command not found` right after installing. Close and reopen the terminal. On Linux, add `~/.local/bin` to your `PATH`.
- `aws --version` shows `aws-cli/1.`. You still have version 1. Uninstall it (for example `pip uninstall awscli`) and install v2.
- `eb: command not found`. You did not activate the virtual environment in this terminal. Run the `source ... activate` line again.
- `Unable to locate credentials`. Run `aws sts get-caller-identity`. If it fails too, repeat step 4.
- `You must specify a region`. Run `aws configure set region us-west-2` and `export AWS_REGION=us-west-2`.
- A command fails with `<<`, `$(` or `export` errors on Windows. You are in PowerShell or Command Prompt. Switch to Git Bash or WSL 2.
- `eb` fails on `eb logs` with a certificate error. We saw this with one local Python install. It does not block the course.
