const { assert } = require("chai");
const cli = require("../lib/terraform-cli");
const jsutil = require("util"); // Utils to run child process
const fs = require("fs");
const jsExec = jsutil.promisify(require("child_process").exec); // Exec from child process
const tfxInit = require("../lib/tfx-init");
let tf;
let tfLogs = [];

describe("example-test terraformCli", () => {
  beforeEach(() => {
    tfLogs = [];
    tf = new cli("../example-tests", jsExec, true);
    tf.log = (log) => {
      tfLogs.push(log);
    };
  });
  describe("plan", () => {
    it("should get plan data", () => {
      return tf.plan(
        {
          trigger_value: "this-is-the-plan-test",
          shuffle_count: 2,
        },
        (data) => {
          assert.deepEqual(
            data,
            require("./data-files/plan.json"),
            "should return correct data"
          );
        },
        { cleanup: true }
      );
    });
    it("should correctly cleanup data", () => {
      return tf.cdAndExec("ls").then((data) => {
        let fileList = [
          "README.md",
          "example-module",
          "local-files",
          "main.tf",
          "ping_module",
          "test-output.sh",
          "tests",
          "variables.tf",
          "versions.tf",
          "",
        ];
        assert.deepEqual(
          data.stdout.split("\n"),
          fileList,
          "it should return correct data"
        );
      });
    });
  });
  describe("apply", () => {
    it("should get the state after apply", () => {
      return tf.apply(
        {
          trigger_value: "this-is-the-apply",
          shuffle_count: 5,
        },
        (data) => {
          let template = require("./data-files/tfstate.json");
          assert.deepEqual(
            data.resources.length,
            template.resources.length,
            "should have number of resources in state"
          );
        },
        true
      );
    });
    it("should correctly cleanup data", () => {
      return tf.cdAndExec("ls").then((data) => {
        let fileList = [
          "README.md",
          "example-module",
          "local-files",
          "main.tf",
          "ping_module",
          "test-output.sh",
          "tests",
          "variables.tf",
          "versions.tf",
          "",
        ];
        assert.deepEqual(
          data.stdout.split("\n"),
          fileList,
          "it should return correct data"
        );
      });
    });
  });
  describe("clone", () => {
    it("should create a clone directory", () => {
      let cloneLs;
      return tf
        .clone("./clone")
        .then(() => {
          return tf.execPromise("ls ./clone/example-tests");
        })
        .then((lsData) => {
          cloneLs = lsData;
        })
        .then(() => {
          return tf.execPromise("ls ../example-tests");
        })
        .then((expectedData) => {
          assert.deepEqual(cloneLs, expectedData);
        });
    });
    it("should correctly purge the directory", () => {
      tf.directory = "./clone";
      return tf
        .purgeClone()
        .then(() => {
          return tf.execPromise("ls ./clone");
        })
        .catch((err) => {
          assert.deepEqual(
            err.stderr,
            "ls: ./clone: No such file or directory\n",
            "it should have correct error"
          );
        });
    });
  });
  describe("init", () => {
    it("should create the needed files", () => {
      let command;
      // version 1.0.0 is not available yet so to prevent
      // compilation errors this placeholder is used. after
      // 1.0.0 release convert to using actual exec
      let tfxInitPlaceholderMockExec = (command) => {
        return new Promise((resolve, reject) => {
          resolve(command);
        });
      };
      return tfxInit(fs, tfxInitPlaceholderMockExec, "e2e_test_tfx_init")
        .then(() => {
          assert.deepEqual(
            fs.readFileSync("./e2e_test_tfx_init/package.json", "utf-8"),
            JSON.stringify(
              {
                name: "tfxjs generated acceptance tests",
                version: "0.0.1",
                description: "acceptance tests for terraform directory",
                main: "tfxjs.test.js",
                scripts: {
                  test: "tfx .",
                  build: "npm i && npm i -g tfxjs mocha",
                },
                author: "This file was automatically generated by tfxjs",
                license: "ISC",
                dependencies: {
                  tfxjs: "^1.1.0",
                },
              },
              null,
              2
            ),
            "should have correct json"
          );
          assert.isTrue(
            fs.existsSync("./e2e_test_tfx_init/tfxjs.test.js"),
            "should exist"
          );
        })
        .finally(() => {
          jsExec("rm -rf e2e_test_tfx_init");
        });
    });
  });
});
