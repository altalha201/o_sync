import 'dart:io';
import 'package:path/path.dart';
import '../../../core/logger/logger.dart';

/// Represents the directory structure for Offline Sync.
///
/// Contains:
/// - [root]: base directory for offline sync.
/// - [db]: directory for Hive DB storage.
/// - [files]: directory for offline file storage.
class OSyncAppDir {
  final Directory root;
  final Directory db;
  final Directory files;

  OSyncAppDir({
    required this.root,
    required this.db,
    required this.files,
  });

  /// Defines standard directory paths from a given [rootPath].
  factory OSyncAppDir.define(String rootPath) {
    final rootDir = Directory(rootPath);
    return OSyncAppDir(
      root: rootDir,
      db: Directory(join(rootPath, "db")),
      files: Directory(join(rootPath, "files")),
    );
  }

  /// Creates all required directories if they do not exist.
  ///
  /// - Creates [root], [db], and [files] recursively.
  /// - Logs the initialized directory path.
  Future<void> create() async {
    try {
      for (final dir in [root, db, files]) {
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }
      Logger.info("Sync Directory initialized at: ${root.path}");
    } catch (e, st) {
      Logger.error("Failed to initialize sync directory: $e", stackTrace: st);
      rethrow;
    }
  }
}
