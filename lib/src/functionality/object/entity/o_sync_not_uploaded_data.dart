import '../enum/table_type.dart';
import '../models/up/upload_table.dart';
import 'o_sync_table.dart';

/// Represents a piece of data that has not yet been uploaded,
/// linking it with its corresponding offline sync table.
class OSyncNotUploadedData {
  /// The sync table to which this data belongs.
  final OSyncTable table;

  /// The actual data row to be uploaded.
  final OSUploadData data;

  /// Creates a new instance of [OSyncNotUploadedData] linking
  /// [data] with its [table].
  OSyncNotUploadedData({required this.table, required this.data});

  /// Factory constructor for creating a file upload entry.
  ///
  /// [id] is the unique identifier for the upload data.
  /// [filePath] is the path of the file to be uploaded.
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
