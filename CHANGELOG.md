# Changelog

## 0.1.0-beta.1

- **Breaking changes:**
  - `NodePlatform` is no longer exported from `node_interop.dart` library.
  - Library-level `exports` getter was removed. Now  `exports` is a direct reference
    to native JS object. Replace any calls to `exports.setProperty(name, value)`
    with new API: `node.export(name, value)`.
  - "http" module: `Agent`, `Server`, `AgentOptions` renamed to
    `HttpAgent`, `HttpServer`, `HttpAgentOptions` respectively.
  - "http" module: `createAgent` renamed to `createHttpAgent`.
  - `node_interop/bindings.dart` was removed. All bindings are available
    through main `node_interop/node_interop.dart` import.
- **New:**
  - Many updates to documentation.
  - Main package's library now exposes all (implemented) Node API bindings.
  - New `node` library object with centralized access to the Node platform and
    runtime information, as well as module globals like `require` and `exports`.
  - Exposed parts of "https", "tls", "dns" and "net" module bindings.
  - Added HTTPS support to `NodeClient` from `node_interop/http.dart`.
  - Updated examples.
  - Gitter channel is now up: https://gitter.im/pulyaevskiy/node-interop.

## 0.0.7

- Added `node_interop/test.dart` library with `installNodeModules()`
  helper function. See dartdoc for more details.

## 0.0.6

- `jsObjectToMap`: added null-check.
- Added basic HTTP client implementation for Node, based on an interface
  from 'http' package. Use with `import package:node_interop/http.dart`.

## 0.0.5

- Streamlined bindings layer and exposed as it's own library. Use
  `import package:node_interop/bindings.dart` to get access.
- Added bindings for 'http' module (work in progress).

## 0.0.4

- Upgraded to `test` package with support for running tests in Node
- Implemented `NodeFileSystem.file()` and `File.writeAsStringSync()`.

## 0.0.3

- Added bindings for `Console`.

## 0.0.2

- Switched to use official `node_preamble` package

## 0.0.1

- Initial version
