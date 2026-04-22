#!/bin/bash

prs=(
  "https://github.com/clouddrove/terraform-aws-route53/pull/24"
  "https://github.com/clouddrove/terraform-aws-security-group/pull/84"
  "https://github.com/clouddrove/terraform-aws-eks/pull/93"
  "https://github.com/clouddrove/terraform-aws-dynamodb/pull/16"
)

BASE_DIR=$(pwd)

# -----------------------------
# 1. Clone PR branches
# -----------------------------
for pr in "${prs[@]}"; do
  repo=$(echo "$pr" | awk -Fgithub.com/ '{print $2}' | cut -d/ -f1,2)
  pr_num=$(echo "$pr" | awk -F/ '{print $NF}')

  # extract repo name only (without owner)
  repo_name=$(echo "$repo" | cut -d/ -f2)
  
  echo "Processing PR: $repo #$pr_num"

  branch_name=$(gh pr view "$pr_num" -R "$repo" --json headRefName --jq '.headRefName')

  echo "Cloning branch: $branch_name"

  git clone -b "$branch_name" "git@github.com:$repo.git"

  # -----------------------------
  # 2. Update workflow files
  # -----------------------------
  cd $repo_name
  FILE="$BASE_DIR/$repo_name/.github/workflows/tf-checks.yml"

  if [ -f "$FILE" ]; then

    if grep -q "permissions:" "$FILE"; then
      echo "Skipping (already has permissions): $FILE"
      cd ..
      continue
    fi

    sed -i '/name: tf-checks/a\
permissions:\n  id-token: write\n  contents: read
' "$FILE"
    echo "Updated: $FILE -> $pr"

    git add .github/workflows/tf-checks.yml
    git commit -m "ci: Add OIDC permissions to tf-checks workflow"
    git push origin "$branch_name"

  else
    echo "File not found: $FILE in -> $pr"
  fi
  cd ..
done


echo "Done."
