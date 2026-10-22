#!/usr/bin/env bash
# Creates the dev, staging and production GitHub Environments. Safe to rerun.
# Needs an admin token (gh auth login). Usage: scripts/setup-github-environments.sh <owner/repo> <reviewer-user-id>
set -euo pipefail
repo=${1:?usage: $0 owner/repo reviewer-user-id}
reviewer=${2:?usage: $0 owner/repo reviewer-user-id}

gh api -X PUT "repos/$repo/environments/dev" >/dev/null

# staging: deploys only from protected branches (main).
gh api -X PUT "repos/$repo/environments/staging" --input - >/dev/null <<JSON
{"deployment_branch_policy":{"protected_branches":true,"custom_branch_policies":false}}
JSON

# production: main only, and a named reviewer must approve each deployment.
gh api -X PUT "repos/$repo/environments/production" --input - >/dev/null <<JSON
{"deployment_branch_policy":{"protected_branches":true,"custom_branch_policies":false},
 "reviewers":[{"type":"User","id":$reviewer}]}
JSON

gh api "repos/$repo/environments" --jq '.environments[] | .name'
