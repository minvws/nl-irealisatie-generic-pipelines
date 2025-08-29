# Pipelines

> [!WARNING]  
> The workflows in this repository have been moved to standalone repositories.
> You can find links to the new repositories above the instructions for each
> workflow below.

Here you can find the available pipelines. Each section will provide a description about the pipeline and how you can use it in your project.

Available pipelines:

- [Repo sync](#repo-sync)

## Repo sync

> [!WARNING]
> Please use [minvws/workflow-repo-sync](https://github.com/minvws/workflow-repo-sync) instead.

This pipeline synchronizes:

- a branch on a private repository with a branch on a public repository by merging all commits from the configured branch to the shadow branch.
  This shadow branch is then pushed to the public repository;
- all tags on the private repository to the public repository.

> [!CAUTION]
> This pipeline pushes all commits from a branch on the private repository to a branch on the public repository.
> Ensure that the private repository does not contain any sensitive or unwanted commits before running the sync.

### Usage

The repo sync workflow is called from a workflow in the private repository. Here is a basic example on how you can integrate it in your project.

<details>
  <summary>Example workflow</summary>
  
This workflow is executed automatically when a tag is pushed and can also be executed manually from the actions tab `workflow_dispatch`.

In the code below you need to replace `<repo>` with the repo name and `<branch>` with the branch you want to sync. Most of the time the branch is `main`.

```yml
name: Public repo sync

on:
  workflow_dispatch:
  push:
    tags:
      - v*

jobs:
  sync-public:
    uses: minvws/nl-irealisatie-generic-pipelines/.github/workflows/repo-sync.yml@main
    with:
      repository: git@github.com:minvws/<repo>.git
      ref: <branch>
      push_tags: true
    secrets:
      REPO_SYNC_PUSH_KEY: ${{ secrets.REPO_SYNC_PUSH_KEY }}
```

</details>

### Configuration

The action has inputs and secrets. The inputs are:

- repository: An SSH URL, like `git@github.com:user/repo.git`
- ref: The ref (e.g. branch) that needs to be synced
- push_tags: Boolean if you want to push tags or not

The secret that is needed is `REPO_SYNC_PUSH_KEY`. This is a SSH Key. In the public repository a deploy key with Read-write permissions can be configured.
The private key should be added to the secrets of the private repository.

More information about deploy keys can be found in [the GitHub documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#set-up-deploy-keys).
