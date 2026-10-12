#!/usr/bin/env bash
# Checks that the tools used in this repo are installed and signed in.
# Usage: bash setup/check-setup.sh

fail=0
ok()   { printf '  [ok]   %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=1; }
warn() { printf '  [skip] %s\n' "$1"; }

echo "Required"

if command -v aws >/dev/null 2>&1; then
  v=$(aws --version 2>&1)
  case "$v" in
    aws-cli/2.*) ok "AWS CLI v2 (${v%% *})" ;;
    *) bad "AWS CLI is not version 2 ($v). Install v2: see setup/README.md step 3" ;;
  esac
else
  bad "AWS CLI not found. See setup/README.md step 3"
fi

if command -v aws >/dev/null 2>&1; then
  if id=$(aws sts get-caller-identity --query Arn --output text 2>/dev/null); then
    case "$id" in
      *:root) bad "Signed in as the root user. Use an IAM user or role instead" ;;
      *) ok "Signed in to AWS as ${id##*:}" ;;
    esac
  else
    bad "Not signed in to AWS. See setup/README.md step 4"
  fi
  region=${AWS_REGION:-$(aws configure get region 2>/dev/null)}
  if [ -n "$region" ]; then
    ok "Region is $region"
    [ "$region" = "us-west-2" ] || warn "Commands in this repo were tested in us-west-2"
  else
    bad "No region set. Run: aws configure set region us-west-2"
  fi
fi

if command -v eb >/dev/null 2>&1; then
  ebv=$(eb --version 2>/dev/null | head -1)
  ok "EB CLI (${ebv%% (*})"
else
  bad "EB CLI not found (or its virtual environment is not active). See setup/README.md step 5"
fi

for t in python3 git curl; do
  if command -v "$t" >/dev/null 2>&1; then ok "$t"; else bad "$t not found. See setup/README.md step 6"; fi
done

echo
echo "Needed in a few places"
for t in zip unzip openssl; do
  if command -v "$t" >/dev/null 2>&1; then ok "$t"; else warn "$t not found (used in Project 2 and chapter 5)"; fi
done

echo
echo "Optional"
if command -v docker >/dev/null 2>&1; then ok "docker"; else warn "docker not found (only for testing images locally)"; fi

echo
if [ "$fail" -eq 0 ]; then
  echo "Ready. Next: create the IAM roles (setup/iam-roles.md)."
else
  echo "Fix the [FAIL] lines above, then run this again."
  exit 1
fi
