import 'package:hive_ce/hive.dart';
import '../../../../core/constants/hive.dart';

part 'download_table.g.dart';

/// A Hive model representing a download table in the offline sync system.
///
/// Each table contains multiple download data entries and tracks the
/// last update timestamp.
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
    this.rows = const [],
  });

  /// Returns a copy of this table with updated rows or timestamp.
  OSDownloadTable copyWith({
    int? tableKey,
    String? tableName,
    DateTime? lastUpdated,
    List<OSDownloadData>? rows,
  }) {
    return OSDownloadTable(
      tableKey: tableKey ?? this.tableKey,
      tableName: tableName ?? this.tableName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rows: rows ?? this.rows,
    );
  }
}

/// Represents a single download data row.
@HiveType(typeId: HiveBoxType.downloadData)
class OSDownloadData extends HiveObject {
  @HiveField(0)
  final int index;

  @HiveField(1)
  final Map<String, dynamic>? data;

  OSDownloadData({required this.index, this.data});

  /// Returns a copy with new data.
  OSDownloadData copyWith({int? index, Map<String, dynamic>? data}) {
    return OSDownloadData(index: index ?? this.index, data: data ?? this.data);
  }
}

/// Extension for Hive persistence operations on [OSDownloadTable].
extension OSDownloadTableHiveExt on OSDownloadTable {
  /// Saves the table to Hive.
  Future<void> saveToHive() async {
    final box = HiveBoxes.downloadTable;
    await box.put(tableKey, this);
  }
}
