import '../../../core/network/enum/api_method.dart';
import '../enum/table_type.dart';

/// Represents a table that can be synchronized with the backend.
///
/// Contains information about the table's type, API endpoint,
/// and network method for communication.
class OSyncTable {
  /// Unique identifier of the table.
  final int id;

  /// HTTP method to use when communicating with the API.
  ///
  /// Defaults to [OSyncNetworkMethod.get].
  final OSyncNetworkMethod apiMethode;

  /// Human-readable label for the table.
  final String label;

  /// Type of the table (upload, download, file, or none).
  final OSyncTableType tableType;

  /// API endpoint associated with this table.
  final String apiEndPoint;

  /// Creates a new instance of [OSyncTable].
  ///
  /// [id] is the unique identifier of the table.
  /// [label] is a human-readable name for the table.
  /// [apiEndPoint] is the backend API endpoint associated with the table.
  /// [tableType] specifies the type of the table (upload, download, file, none).
  /// [apiMethode] specifies the HTTP method to use when calling the API.
  OSyncTable({
    required this.id,
    required this.label,
    required this.apiEndPoint,
    required this.tableType,
    this.apiMethode = OSyncNetworkMethod.get,
  });
}
