const { assert } = require("chai");
const mocks = require("./tfx.mocks"); // import mocks
let mock = new mocks(); // initialize mocks
const sinon = require("sinon");
const tfxInit = require("../lib/tfx-init");
const { prettyJSON } = require("../lib/utils");

let exec, fs; // mock placeholders

describe("tfxInit", () => {
  beforeEach(() => {
    exec = new sinon.spy();
    fs = new mock.mockFs();
    foundFilePathFs = new mock.mockFs(true);
  });
  it("should run mkdirSync if the filepath is not found", () => {
    fs.mkdirSync = new sinon.spy();
    tfxInit(fs, exec, "testPath");
    assert.isTrue(
      fs.mkdirSync.calledOnceWith("testPath"),
      "it should call mkdirSync"
    );
  });
  it("should not run mkdirSync if the filepath is found", () => {
    foundFilePathFs.mkdirSync = new sinon.spy();
    tfxInit(foundFilePathFs, exec, "testPath");
    assert.isTrue(
      foundFilePathFs.mkdirSync.callCount === 0,
      "it should not call mkdirSync"
    );
  });
  it("should call fs with the correct params and data for package.json and create tfxjs.test.js", () => {
    fs.writeFileSync = new sinon.spy();
    tfxInit(fs, exec, "testPath");
    assert.isTrue(
      fs.writeFileSync.callCount === 2,
      "it should call writeFileSync twice"
    );
    assert.deepEqual(
      fs.writeFileSync.lastCall.args,
      ["testPath/tfxjs.test.js", ""],
      "it should create an empty test file"
    )
    assert.deepEqual(
      fs.writeFileSync.firstCall.args,
      [
        "testPath/package.json",
        prettyJSON({
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
            tfxjs: "^1.0.0",
          },
        }),
      ],
      "it should have the correct package.json data"
    );
  });
  it("should call exec with the correct function", () => {
    tfxInit(fs, exec, "testPath");
    assert.isTrue(
      exec.calledOnceWith(`cd testPath && npm run build`),
      "it should cd and run npm build"
    )
  })
});
