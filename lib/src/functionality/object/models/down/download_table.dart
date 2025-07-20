import 'package:hive_ce/hive.dart';

import '../../../../core/constants/hive.dart';

part 'download_table.g.dart';

@HiveType(typeId: HiveBoxType.downloadTable)
class OSDownloadTable extends HiveObject {
  @HiveField(0)
  int tableKey;

  @HiveField(1)
  String tableName;

  @HiveField(2)
  DateTime lastUpdated;

  @HiveField(3)
  List<OSDownloadData> rows;

  OSDownloadTable({
    required this.tableKey,
    required this.tableName,
    required this.lastUpdated,
    required this.rows,
  });
}

@HiveType(typeId: HiveBoxType.downloadData)
class OSDownloadData extends HiveObject {
  @HiveField(0)
  int index;

  @HiveField(1)
  Map<String, dynamic>? data;

  OSDownloadData({required this.index, this.data});
}

extension SyncDownTableExt on OSDownloadTable {
  Future<void> get saveToHive async {
    final box = HiveBoxes.downloadTable;
    await box.put(tableKey, this);
  }
}
