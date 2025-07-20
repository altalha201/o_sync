import 'package:hive_ce/hive.dart';

import '../../../../core/constants/hive.dart';

part 'upload_table.g.dart';

@HiveType(typeId: HiveBoxType.uploadTable)
class OSUploadTable extends HiveObject {
  @HiveField(0)
  int tableKey;

  @HiveField(1)
  String tableName;

  @HiveField(2)
  List<OSUploadData> rows;

  OSUploadTable({
    required this.tableKey,
    required this.tableName,
    this.rows = const [],
  });
}

@HiveType(typeId: HiveBoxType.uploadData)
class OSUploadData extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  bool uploaded;

  @HiveField(2)
  Map<String, dynamic>? data;

  OSUploadData({required this.id, this.uploaded = false, this.data});
}

extension UploadTableExt on OSUploadTable {
  Future<void> get saveToHive async {
    final box = HiveBoxes.uploadTable;
    await box.put(tableKey, this);
  }

  OSUploadTable withNewData(List<OSUploadData> data) =>
      OSUploadTable(tableKey: tableKey, tableName: tableName, rows: data);
}

extension UploadDataExt on OSUploadData {
  OSUploadData get withSynced =>
      OSUploadData(id: id, data: data, uploaded: true);
}
