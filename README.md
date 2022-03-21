# GitHub Action for Meshery plugins
Purpose: Fetch GitHub Release asset(s) from one repository and publish to another repository. Private repositories are supported.

## Inputs

### `repo`

The `org/repo`. Defaults to the current repo.

### `version`

The release version to fetch from. Default `"latest"`. If not `"latest"`, this has to be in the form `tags/<tag_name>` or `<release_id>`.

### `name`

**Required** The name of the ACTION to b triggered.

### `token`

Optional Personal Access Token to access repository. You need to either specify this or use the ``secrets.GITHUB_TOKEN`` environment variable. Note that if you are working with a private repository, you cannot use the default ``secrets.GITHUB_TOKEN`` - you have to set up a personal access token with at least the scope org.

## Outputs

### `version`

The version number of the release tag. Can be used to deploy for example to v1.0.0

## Example usage

```yaml
uses: layer5labs/action-mmeshery-plugins@master
with:
  repo: "layer5labs/random"
  version: "latest"
  name: "publish action"
  token: ${{ secrets.YOUR_TOKEN }}
```
