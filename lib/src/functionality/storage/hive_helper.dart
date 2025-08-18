// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/hive.dart';
import '../../core/logger/logger.dart';
import '../object/entity/o_sync_app_dir.dart';
import '../object/exports.dart';

/// Internal helper class to initialize and manage Hive DB
/// for Offline Sync.
///
/// Handles:
/// - App directory setup
/// - Hive database initialization
/// - Adapter registration
/// - Opening required boxes
class HiveHelper {
  /// Initializes Hive DB for the given [package].
  ///
  /// - Creates an app-specific directory (if not web).
  /// - Sets up Hive database.
  /// - Registers adapters and opens required boxes.
  Future<void> init(String package) async {
    final appDir = await _initDir(package);
    await _initDb(appDir);
  }

  /// Prepares the application directory for storing Hive DB.
  ///
  /// Returns `null` if running on web (no local filesystem).
  Future<OSyncAppDir?> _initDir(String package) async {
    if (kIsWeb) return null;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final appDir = OSyncAppDir.define(
        p.join(dir.path, '.$package', '.offline_sync'),
      );

      await appDir.create(); // Ensure directory exists
      return appDir;
    } catch (e, st) {
      Logger.error('Failed to create app directory: $e', stackTrace: st);
      return null;
    }
  }

  /// Initializes Hive DB with adapters and opens boxes.
  Future<void> _initDb(OSyncAppDir? appDir) async {
    try {
      await Hive.initFlutter(kIsWeb ? null : appDir?.db.path);
      await _registerAdapters();
      await _openBoxes();
    } catch (e, st) {
      Logger.error("Failed to initialize Hive DB: $e", stackTrace: st);
      throw Exception('Hive initialization failed: $e');
    }
  }

  /// Registers all Hive adapters for Offline Sync entities.
  ///
  /// Uses `isAdapterRegistered` to avoid duplicate registration.
  Future<void> _registerAdapters() async {
    void safeRegister<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    safeRegister(OSBasicInfoAdapter());
    safeRegister(OSDownloadDataAdapter());
    safeRegister(OSDownloadTableAdapter());
    safeRegister(OSUploadDataAdapter());
    safeRegister(OSUploadTableAdapter());
    safeRegister(OSFileTableAdapter());
  }

  /// Opens all necessary Hive boxes.
  Future<void> _openBoxes() async {
    await Hive.openBox<OSBasicInfo>(HiveBoxName.baseInfo);
    await Hive.openBox<OSFileTable>(HiveBoxName.fileTable);
    await Hive.openBox<OSDownloadData>(HiveBoxName.downloadData);
    await Hive.openBox<OSDownloadTable>(HiveBoxName.downloadTable);
    await Hive.openBox<OSUploadData>(HiveBoxName.uploadData);
    await Hive.openBox<OSUploadTable>(HiveBoxName.uploadTable);
  }
}
