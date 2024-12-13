# Actions

Here you can find the available actions. Each section will provide a description about the action and how you can use it in your project.

Available actions:

- Python
    - [Python - Poetry install](#python---poetry-install)
    - [Python - venv package](#python---venv-package)
- PHP
    - [PHP - composer install](#php---composer-install)

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

## Python - venv package

This pipeline is designed to export a venv package for the specified Python version with the installed requirements. When [Poetry](https://python-poetry.org/) is used, the requirements will be exported and the requirements will be installed in the venv.

### Usage

Here are basic examples on how you can integrate it in your project.

<details>
  <summary>Example workflow</summary>

This workflow is executed automatically on push of tags.

In the code below you need to replace the `<python_version>` and `<package_file_name>`. See the [configuration section](#configuration-1).

```yml
name: Build Python project

on:
  push:
    tags:
      - v*

jobs:
  venv-package:
    runs-on: ubuntu-latest
    steps:
      # Using the action
      - name: Build venv package
        uses: minvws/nl-irealisatie-generic-pipelines/.github/actions/python-venv-package@main
        with:
          python_version: <python_version>
          package_file_name: <package_file_name>

```

</details>

<details>
  <summary>Example workflow self checkout</summary>

This workflow is executed automatically on push of tags. The workflow will checkout the repo and the action won't. Now it is possible to run additional actions before using the venv package action.

In the code below you need to replace the `<python_version>` and `<package_file_name>`. See the [configuration section](#configuration-1).

```yml
name: Build Python project

on:
  push:
    tags:
      - v*

jobs:
  venv-package:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # Using the action
      - name: Build venv package
        uses: minvws/nl-irealisatie-generic-pipelines/.github/actions/python-venv-package@main
        with:
          python_version: <python_version>
          package_file_name: <package_file_name>
          checkout_repository: 'false'
```

</details>

### Configuration

The action has inputs. The inputs are:

- python_version: Semver version of the Python version you want to use. For example `3.11` or `3.9`.
- package_file_name: File name for the venv package. For example `nl-example-package`.
- checkout_repository: Boolean value inside string to enable or disable checkout repository
 in the action. For example `'true'` or `'false'`. Default `'true'`.
- working_directory: Directory containing the Python project. The directory should contain
 a `requirements.txt` file or a `pyproject.toml` file. Default `'.'`.

### Result

This action will create a `.tar.gz` file containing the `.venv` directory. The file will be available as an artifact.

The name of the artifact will be `<package_file_name>_venv_<tag_version>_python<python_version>.tar.gz`. For example `nl-example-package_venv_v0.0.1_python3.9.tar.gz`.

## PHP - Composer install

This pipeline is designed to install the dependencies of a PHP project that uses Composer. It will install the dependencies and cache them for future runs.

### Usage

Here is a basic example on how you can integrate it in your project.

<details>
  <summary>Example workflow</summary>

This workflow is executed automatically on push to the main branch, on a pull request and can also be executed manually from the actions tab `workflow_dispatch`.

In the code below you need to replace `<php_version>` with the PHP version you want to use. For example `8.3` (default) or `8.4`.

```yml
name: Build PHP project

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
        uses: minvws/nl-irealisatie-generic-pipelines/.github/actions/composer-install@main
        with:
          php_version: <php_version>
```

</details>

### Configuration

The action has inputs. The inputs are:

- php_version: Semver version of the PHP version you want to use. For example `8.2` or `8.3`.
