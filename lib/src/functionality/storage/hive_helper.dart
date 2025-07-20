import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/hive.dart';
import '../../core/logger/logger.dart';
import '../object/entity/o_sync_app_dir.dart';
import '../object/exports.dart';

class HiveHelper {
  Future<void> init(String package) async {
    final appDir = await _initDir(package);
    await _initDb(appDir);
  }

  Future<OSyncAppDir?> _initDir(String package) async {
    if (kIsWeb) return null;

    final dir = await getApplicationDocumentsDirectory();

    final appDir = OSyncAppDir.define(
      join(dir.path, ".$package", ".offline_sync"),
    );

    appDir.create;

    return appDir;
  }

  Future<void> _initDb(OSyncAppDir? appDir) async {
    try {
      await Hive.initFlutter(kIsWeb ? null : appDir?.db.path);
      await _registerAdapter();
      await _openBoxes();
    } catch (e) {
      Logger.error("Failed to initialize Hive DB: $e");
      throw Exception(e);
    }
  }

  Future<void> _registerAdapter() async {
    Hive.registerAdapter(OSBasicInfoAdapter());
    Hive.registerAdapter(OSDownloadDataAdapter());
    Hive.registerAdapter(OSDownloadTableAdapter());
    Hive.registerAdapter(OSUploadDataAdapter());
    Hive.registerAdapter(OSUploadTableAdapter());
    Hive.registerAdapter(OSFileTableAdapter());
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<OSBasicInfo>(HiveBoxName.baseInfo);
    await Hive.openBox<OSFileTable>(HiveBoxName.fileTable);
    await Hive.openBox<OSDownloadData>(HiveBoxName.downloadData);
    await Hive.openBox<OSDownloadTable>(HiveBoxName.downloadTable);
    await Hive.openBox<OSUploadData>(HiveBoxName.uploadData);
    await Hive.openBox<OSUploadTable>(HiveBoxName.uploadTable);

  }
}