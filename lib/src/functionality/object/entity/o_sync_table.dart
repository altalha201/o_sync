import '../../../core/network/enum/api_method.dart';
import '../enum/table_type.dart';

class OSyncTable {
  final int id;
  final OSyncNetworkMethod apiMethode;
  final String label;
  final OSyncTableType tableType;
  final String apiEndPoint;

  OSyncTable({
    required this.id,
    required this.label,
    required this.apiEndPoint,
    required this.tableType,
    this.apiMethode = OSyncNetworkMethod.get,
  });
}
