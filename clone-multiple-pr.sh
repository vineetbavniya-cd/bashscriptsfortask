#!/bin/bash

# requirement 
# sudo apt isntall gh
# add your github account in gh tool


prs=(
"https://github.com/clouddrove/terraform-aws-s3/pull/86"
"https://github.com/clouddrove/terraform-aws-redshift/pull/11"
"https://github.com/clouddrove/terraform-aws-mysql/pull/79"
"https://github.com/clouddrove/terraform-aws-ec2/pull/84"
"https://github.com/clouddrove/terraform-aws-cloudfront/pull/33"
"https://github.com/clouddrove/terraform-aws-elasticache/pull/79"
"https://github.com/clouddrove/terraform-aws-iam-user/pull/22"
"https://github.com/clouddrove/terraform-aws-waf/pull/95"
"https://github.com/clouddrove/terraform-aws-iam-role/pull/52"
"https://github.com/clouddrove/terraform-aws-aurora/pull/80"
"https://github.com/clouddrove/terraform-aws-sns/pull/57"
"https://github.com/clouddrove/terraform-aws-sqs/pull/24"
"https://github.com/clouddrove/terraform-aws-kms/pull/64"
"https://github.com/clouddrove/terraform-aws-lambda/pull/46"
"https://github.com/clouddrove/terraform-aws-ecs/pull/82"
"https://github.com/clouddrove/terraform-aws-alb/pull/106"
"https://github.com/clouddrove/terraform-aws-cloudtrail/pull/35"
"https://github.com/clouddrove/terraform-aws-subnet/pull/87"
"https://github.com/clouddrove/terraform-aws-vpc/pull/83"
"https://github.com/clouddrove/terraform-aws-cloudformation/pull/8"
"https://github.com/clouddrove/terraform-aws-route53-record/pull/16"
"https://github.com/clouddrove/terraform-aws-multi-account-peering/pull/36"
"https://github.com/clouddrove/terraform-aws-cognito/pull/30"
"https://github.com/clouddrove/terraform-aws-eventbridge/pull/11"
)

for pr in "${prs[@]}"; do
  repo=$(echo "$pr" | awk -Fgithub.com/ '{print $2}' | cut -d/ -f1,2)
  pr_num=$(echo "$pr" | awk -F/ '{print $NF}')
  branch_name=$(gh pr view "$pr_num" -R "$repo" --json headRefName --jq '.headRefName')
  git clone git@github.com:$repo.git -b $branch_name
done
