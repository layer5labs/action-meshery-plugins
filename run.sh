#!/bin/bash

GITHUB_API_URL="api.github.com"

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Missing GITHUB_REPOSITORY env variable"
  exit 1
fi

REPO=$GITHUB_REPOSITORY
if ! [[ -z ${INPUT_REPO} ]]; then
  REPO=$INPUT_REPO
fi

NAME=$INPUT_NAME
if ! [[ -z ${INPUT_NAME} ]]; then
  NAME=$INPUT_NAME
fi

# Optional personal access token for external repository
TOKEN=$GITHUB_TOKEN
if ! [[ -z ${INPUT_TOKEN} ]]; then
  TOKEN=$INPUT_TOKEN
fi

echo "Fetching latest revision...."
REVISION_API_URL="https://$GITHUB_API_URL/repos/$REPO/releases"
LATEST_VERSION=$(curl -H "Authorization: token $TOKEN" $REVISION_API_URL | jq -r '.[0]' | jq -r .tag_name)
REVISION=$(cut -d '-' -f2 <<<"$LATEST_VERSION")
echo "Latest revision: $REVISION"

WORKFLOW_API_URL="https://$GITHUB_API_URL/repos/$REPO/actions/workflows"
RELEASE_DATA=$(curl -H "Authorization: token $TOKEN" $WORKFLOW_API_URL)
ACTION_ID=$(echo $RELEASE_DATA | jq -r ".workflows[] | select(.name == \"$NAME\").id")

if [[ "$ACTION_ID" == "" ]]; then
  echo "[!] Action not found"
  exit 1
fi

curl \
  -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  $WORKFLOW_API_URL/$ACTION_ID/dispatches \
  -d '{"ref":"master","inputs": {"version":"'${INPUT_VERSION}'","revision":"'${REVISION}'"}}'

echo "Triggered: "$ACTION_ID