class OSyncData<T> {
  final String tableName;
  final int tableId;
  final List<T> tableData;

  OSyncData({
    required this.tableName,
    required this.tableData,
    required this.tableId,
  });
}
