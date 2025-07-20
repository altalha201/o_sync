import 'dart:io';

import 'package:path/path.dart';

import '../../../core/logger/logger.dart';

class OSyncAppDir {
  final Directory db;
  final Directory root;
  final Directory files;

  OSyncAppDir({required this.db, required this.root, required this.files});

  factory OSyncAppDir.define(String rootPath) {
    return OSyncAppDir(
        root: Directory(rootPath),
        db: Directory(join(rootPath, "db")),
        files: Directory(join(rootPath, "files"))
    );
  }
}

extension AppDirExt on OSyncAppDir {
  void get create {
    if (!root.existsSync()) {
      root.createSync(recursive: true);
    }
    if (!db.existsSync()) {
      db.createSync(recursive: true);
    }
    if (!files.existsSync()) {
      files.createSync(recursive: true);
    }

    Logger.info("Sync Directory: ${root.path}");
  }
}