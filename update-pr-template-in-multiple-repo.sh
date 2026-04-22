#!/bin/bash

BASE_DIR=$(pwd)

repos=(
  "terraform-aws-reference"
)

ORG="clouddrove"

for repo in "${repos[@]}"; do
  echo "Cloning $repo ..."

  if [ -d "$repo" ]; then
    echo "Skipping (already exists): $repo"
    cd ..
    continue
  fi

  git clone git@github.com:$ORG/$repo.git
  cd $repo
  git checkout -b ci/update-workflows-and-pr-template
  cat /home/vineet/module_workspace/updatetfchecks/PULL_REQUEST_TEMPLATE.md > .github/PULL_REQUEST_TEMPLATE.md
  cd ..
done

echo "All repositories cloned successfully."
