# tfxjs

tfxjs is a terrafrom acceptance test framework built with [mocha](https://mochajs.org/) and [chai](https://www.chaijs.com/) to allow users to quickly and easily create acceptance tests for terraform templates.

[View on Github](https://github.com/IBM/tfxjs).

---

## Table of Contents

1. [Installation](#installation)
2. [Prerequisites](#prerequisites)
3. [Usage](#usage)
4. [Example Usage](#example-usage)
5. [Methods](#methods)
5. [CLI](#cli)
5. [Contributing](#contributing)
6. [Code Test Coverage](#code-test-coverage)

---

## Installation

```shell
npm install tfxjs -g
```

---

## Prerequisites

- [Terraform CLI](https://www.terraform.io/cli/commands)
- If [mocha](https://mochajs.org/) is not installed globally run:
```shell
npm install mocha -g
```
- [GNU Netcat version 0.7.1](http://netcat.sourceforge.net/). On MacOS, use 
```shell
brew install netcat
```

---

## Example Usage

For a detailed example of using this framework, see [example tests](./example-tests/)

### Example File

```js

const tfxjs = require("tfxjs"); // Initialize tfxjs
const tfx = new tfxjs(" <path to template directory> ", {
  my_tf_value_1 : "<data>", // export variable data to template directory
  my_tf_value_2 : "<data>"
}); // Create a new constructor for terraform teplate

tfx.plan("MyModule", () => { // Gerate a plan in the directory
  // Run tests for the module
  tfx.module(
    "Root Module", // decorative module name
    "module.my_module", // module address
    tfx.resource(
      "Activity Tracker Route", // Name of the resource (decorative)
      "ibm_atracker_route.atracker_route", // Expected address within module
      // values to check in that resource
      { 
        name: "tfx-atracker-route",
        receive_global_events: true,
      },
    ),
    ...
  );
});
```

### Example Output

```
* tfxjs testing

##############################################################################
# 
#  Running `terraform plan`
#  Teplate File:
#     < your file path >
# 
##############################################################################



  MyModule

    ✔ Successfully generates a terraform plan file
    ✔ module.my_module should not contain additional resources

  Module Root Module
    ✔ Plan should contain the module module.my_module
    Activity Tracker Route
      ✔ Module module.my_module should contain resource ibm_atracker_route.atracker_route
      ✔ Activity Tracker Route should have the correct name value
      ✔ Activity Tracker Route should have the correct receive_global_events value


  5 passing (7s)
```

---

## Methods

For detailed use of the methods see the documentation [here](./.docs/tfxjs.md).

Name     | Description
---------|-------------------------------------------------------------
plan     | Plan Terraform template from directory and get plan data
module   | Test a module inside existing terraform plan
resource | Create a test to check the values of a resource inside a module
apply    | Apply Terraform template from directory and return tfstate
state    | Runs a set of tests against the tfstate data
address  | Create a set of tests for any number of instances at a single address within the terraform state
expect   | Test the value in a resource or instance against a function

---

## CLI

The tfx CLI allows users to run test files. Additionally, the tfx CLI now supports methods to automatically generate tfx test files from a terraform template directory

## Usage

### Running Test File

```shell
tfx <path to js test file>
```

### Initializing a Test Directory

This command creates a folder or needed files in an existing folder. A package.json is created and needed npm packages are insalled locally and globally.

```shell
tfx init <directory path>
```

#### package.json

```json
{
  "name": "tfxjs generated acceptance tests",
  "version": "0.0.1",
  "description": "acceptance tests for terraform directory",
  "main": "tfxjs.test.js",
  "scripts": {
    "test": "tfx .",
    "build": "npm i && npm i -g tfxjs mocha",
  },
  "author": "This file was automatically generated by tfxjs",
  "license": "ISC",
  "dependencies": {
    "tfxjs": "^1.0.0",
  },
}
```

### Generating a Plan Test File

```shell
tfx plan --in <terraform file path> --out <filepath> --type <tfx or yaml>
```

Additionally the `-v | --tf-var` can be used any number of times to set variable within the terraform template. Currently only string, boolean, and numbers are accepted.

```shell
tfx plan --in <terraform file path> --out <filepath> --type <tfx or yaml> --tf-var example_variable="test"
```

YAML files cannot be read directly by using `tfx <path>` but they can be translated using the `tfx decode` command. Due to the size of file, YAML can be used to make code more human readable and uses fewer lines.

### Decoding a tfx .yaml file

```shell
tfx decode <yaml file path> --out <filepath>
```

This code creates a valid `.test.js` file that can be used with `tfx <path>` command from a yaml plan file.

Additionally the `-v | --tf-var` can be used any number of times to set variable within the terraform template. Currently only string, boolean, and numbers are accepted.

```shell
tfx decode <yaml file path> --out <filepath> --tf-var example_variable="test"
```


## Contributing

If you have any questions or issues you can create a new [issue here][issues]. See the full contribution guidelines [here](./CONTRIBUTING.md). 

This repo uses [Prettier JS](https://prettier.io/) for formatting. We recommend using the [VS Code extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode).

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

--- 

## Code Test Coverage

This module uses [nyc](https://www.npmjs.com/package/nyc) for unit test coverage.

To get test coverage, run the command 
```shell
npm run coverage
```

## End to End Tests

To run end-to-end tests, use the following command
```shell
tfx e2e-tests/
```

---

### Current Test Coverage

File               | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s 
-------------------|---------|----------|---------|---------|-------------------
All files          |     100 |      100 |     100 |     100 | 🏆                                   
 lib               |     100 |      100 |     100 |     100 | 🏆                   
  builders.js      |     100 |      100 |     100 |     100 | 🏆                   
  cli.js           |     100 |      100 |     100 |     100 | 🏆                   
  connect.js       |     100 |      100 |     100 |     100 | 🏆                   
  constants.js     |     100 |      100 |     100 |     100 | 🏆                   
  extract.js       |     100 |      100 |     100 |     100 | 🏆                   
  helpers.js       |     100 |      100 |     100 |     100 | 🏆                   
  index.js         |     100 |      100 |     100 |     100 | 🏆                   
  requests.js      |     100 |      100 |     100 |     100 | 🏆                   
  terraform-cli.js |     100 |      100 |     100 |     100 | 🏆                   
  tf-utils.js      |     100 |      100 |     100 |     100 | 🏆                   
  tfx-cli.js       |     100 |      100 |     100 |     100 | 🏆                   
  tfx-init.js      |     100 |      100 |     100 |     100 | 🏆                   
 unit-tests        |     100 |      100 |     100 |     100 | 🏆                   
  axios.mocks.js   |     100 |      100 |     100 |     100 | 🏆                   
  tfx.mocks.js     |     100 |      100 |     100 |     100 | 🏆 