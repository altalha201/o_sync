import 'package:hive_ce/hive.dart';

import '../../functionality/object/models/basic_info/basic_info.dart';
import '../../functionality/object/models/down/download_table.dart';
import '../../functionality/object/models/file/file_table.dart';
import '../../functionality/object/models/up/upload_table.dart';

/// Centralized access to Hive boxes used in the app.
class HiveBoxes {
  /// Stores basic app info like package name and base URL.
  static Box<OSBasicInfo> basicInfo = Hive.box<OSBasicInfo>(HiveBoxName.baseInfo);

  /// Stores downloaded data entries for offline usage.
  static Box<OSDownloadData> downloadData = Hive.box<OSDownloadData>(HiveBoxName.downloadData);

  /// Stores metadata about downloaded tables.
  static Box<OSDownloadTable> downloadTable = Hive.box<OSDownloadTable>(HiveBoxName.downloadTable);

  /// Stores uploaded data entries awaiting sync.
  static Box<OSUploadData> uploadData = Hive.box<OSUploadData>(HiveBoxName.uploadData);

  /// Stores metadata about upload tables.
  static Box<OSUploadTable> uploadTable = Hive.box<OSUploadTable>(HiveBoxName.uploadTable);

  /// Stores file table entries for file uploads.
  static Box<OSFileTable> fileTable = Hive.box<OSFileTable>(HiveBoxName.fileTable);
}

/// Hive type IDs for different stored objects.
///
/// These IDs are used by Hive to identify the type when reading/writing objects.
class HiveBoxType {
  static const int baseInfo = 5001;
  static const int downloadData = 5002;
  static const int downloadTable = 5003;
  static const int fileTable = 5004;
  static const int uploadData = 5005;
  static const int uploadTable = 5006;
}

/// Standardized Hive box names used throughout the app.
class HiveBoxName {
  static const String baseInfo = "baseInfo";
  static const String downloadData = "downloadData";
  static const String downloadTable = "downloadTable";
  static const String fileTable = "fileTable";
  static const String uploadData = "uploadData";
  static const String uploadTable = "uploadTable";
}
