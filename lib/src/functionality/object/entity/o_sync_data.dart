/// Generic wrapper representing a table and its data for Offline Sync.
///
/// [T] is the type of data stored in the table, e.g., [OSUploadData], [OSDownloadData], or [OSFileTable].
class OSyncData<T> {
  /// Name of the offline sync table.
  final String tableName;

  /// Unique identifier of the table.
  final int tableId;

  /// List of data rows contained in the table.
  final List<T> tableData;

  /// Creates a new instance of [OSyncData].
  ///
  /// All fields are required.
  OSyncData({
    required this.tableName,
    required this.tableData,
    required this.tableId,
  });
}
