![Linting](https://github.com/beatlabs/release-changelog-action/workflows/Linting/badge.svg)
# Release Changelog GitHub Action

## Introduction
This simple GitHub Action allows to generate a Changelog body suitable to be used with [github/create-release](https://github.com/marketplace/actions/create-a-release) action.
It will build the changelog text based on commits that happened between current and
previous tags that match the `tag_regex` grep ERE.

## Example usage

```
name: "production release"
on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
jobs:
  build:
    name: Create Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Produce release body
        id: git_log
        uses: beatlabs/release-changelog-action@v0.0.3
        with:
          tag_regex: "v[0-9]+.[0-9]+.[0-9]+"
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1.0.1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: ${{ github.ref }}
          body: ${{ steps.git_log.outputs.release_body }}
          draft: false
          prerelease: false
```

#### Example 2
It also allows tagging commits by incrementing semver based on the `version_bump` input. Best used in conjunction with `workflow_dispatch` event.

```
name: "production release"
on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
  workflow_dispatch:
    inputs:
      version_bump:
        description: "Version to bump (major/minor/patch)"
        required: false
        default: patch
jobs:
  build:
    name: Create Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Produce release body
        id: git_log
        uses: beatlabs/release-changelog-action@0.0.3
        with:
          tag_regex: "v[0-9]+.[0-9]+.[0-9]+"
          version_bump: ${{ github.event.inputs.version_bump }}
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1.1.4
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ steps.git_log.outputs.release_tag }}
          release_name: ${{ steps.git_log.outputs.release_tag }}
          body: ${{ steps.git_log.outputs.release_body }}
          draft: false
          prerelease: false
```
