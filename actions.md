# Actions

Here you can find the available actions. Each section will provide a description about the action and how you can use it in your project.

Available actions:

- [Python - Poetry install](#python---poetry-install)

## Python - Poetry install

This pipeline is designed to install the dependencies of a Python project that uses Poetry. It will install the dependencies and cache them for future runs.

### Usage

Here is a basic example on how you can integrate it in your project.

<details>
  <summary>Example workflow</summary>

This workflow is executed automatically on push to the main branch, on a pull request and can also be executed manually from the actions tab `workflow_dispatch`.

In the code below you need to replace `<python_version>` with the Python version you want to use. For example `3.11` or `3.9`.

```yml
name: Build Python project

on:
  workflow_dispatch:
  pull_request:
  push:
    branches:
      - main

jobs:
  build-python:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # Using the action
      - name: Install dependencies
        uses: minvws/nl-irealisatie-generic-pipelines/.github/actions/poetry-install@main
        with:
          python_version: <python_version>
```

</details>

### Configuration

The action has inputs. The inputs are:

- python_version: Semver version of the Python version you want to use. For example `3.11` or `3.9`.
