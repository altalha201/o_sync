import 'package:hive_ce/hive.dart';

import '../../functionality/object/models/basic_info/basic_info.dart';
import '../../functionality/object/models/down/download_table.dart';
import '../../functionality/object/models/file/file_table.dart';
import '../../functionality/object/models/up/upload_table.dart';

class HiveBoxes {
  static Box<OSBasicInfo> basicInfo = Hive.box<OSBasicInfo>(HiveBoxName.baseInfo);
  static Box<OSDownloadData> downloadData = Hive.box<OSDownloadData>(HiveBoxName.downloadData);
  static Box<OSDownloadTable> downloadTable = Hive.box<OSDownloadTable>(HiveBoxName.downloadTable);
  static Box<OSUploadData> uploadData = Hive.box<OSUploadData>(HiveBoxName.uploadData);
  static Box<OSUploadTable> uploadTable = Hive.box<OSUploadTable>(HiveBoxName.uploadTable);
  static Box<OSFileTable> fileTable = Hive.box<OSFileTable>(HiveBoxName.fileTable);
}

class HiveBoxType {
  static const int baseInfo = 5001;
  static const int downloadData = 5002;
  static const int downloadTable = 5003;
  static const int fileTAble = 5004;
  static const int uploadData = 5005;
  static const int uploadTable = 5006;
}

class HiveBoxName {
  static const String baseInfo = "baseInfo";
  static const String downloadData = "downloadData";
  static const String downloadTable = "downloadTable";
  static const String fileTable = "fileTable";
  static const String uploadData = "uploadData";
  static const String uploadTable = "uploadTable";
}
