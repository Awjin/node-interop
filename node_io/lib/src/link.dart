// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:node_interop/path.dart' as nodePath;

import 'file_system_entity.dart';

class Link extends FileSystemEntity implements io.Link {
  @override
  final String path;

  Link(this.path);

  factory Link.fromRawPath(Uint8List rawPath) {
    throw new UnimplementedError();
  }

  /// Creates a [Link] object.
  ///
  /// If [path] is a relative path, it will be interpreted relative to the
  /// current working directory (see [Directory.current]), when used.
  ///
  /// If [path] is an absolute path, it will be immune to changes to the
  /// current working directory.
  factory Link.fromUri(Uri uri) => new Link(uri.toFilePath());

  @override
  Future<bool> exists() async {
    var stat = await FileStat.stat(path);
    return stat.type == io.FileSystemEntityType.link;
  }

  @override
  bool existsSync() {
    var stat = FileStat.statSync(path);
    return stat.type == io.FileSystemEntityType.link;
  }

  @override
  Link get absolute => new Link(_absolutePath);

  String get _absolutePath => nodePath.path.resolve(path);

  @override
  Future<Link> create(String target, {bool recursive: false}) {
    // TODO: implement create
    throw new UnimplementedError();
  }

  @override
  void createSync(String target, {bool recursive: false}) {
    // TODO: implement createSync
    throw new UnimplementedError();
  }

  @override
  Future<FileSystemEntity> delete({bool recursive: false}) {
    // TODO: implement delete
    throw new UnimplementedError();
  }

  @override
  void deleteSync({bool recursive: false}) {
    // TODO: implement deleteSync
    throw new UnimplementedError();
  }

  @override
  Future<Link> rename(String newPath) {
    // TODO: implement rename
    throw new UnimplementedError();
  }

  @override
  Link renameSync(String newPath) {
    // TODO: implement renameSync
    throw new UnimplementedError();
  }

  @override
  Future<String> target() {
    // TODO: implement target
    throw new UnimplementedError();
  }

  @override
  String targetSync() {
    // TODO: implement targetSync
    throw new UnimplementedError();
  }

  @override
  Future<Link> update(String target) {
    // TODO: implement update
    throw new UnimplementedError();
  }

  @override
  void updateSync(String target) {
    // TODO: implement updateSync
    throw new UnimplementedError();
  }
}
