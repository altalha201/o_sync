import '../enum/table_type.dart';
import '../models/up/upload_table.dart';
import 'o_sync_table.dart';

class OSyncNotUploadedData {
  final OSyncTable table;
  final OSUploadData data;

  OSyncNotUploadedData({required this.table, required this.data});

  factory OSyncNotUploadedData.file(int id, String filePath) =>
      OSyncNotUploadedData(
        table: OSyncTable(
          id: 0,
          label: "file_tables",
          apiEndPoint: "",
          tableType: OSyncTableType.fileTable,
        ),
        data: OSUploadData(id: id, data: {'path': filePath}),
      );
}
