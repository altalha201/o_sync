import 'package:hive_ce/hive.dart';

import '../../../../core/constants/hive.dart';

part 'basic_info.g.dart';

@HiveType(typeId: HiveBoxType.baseInfo)
class OSBasicInfo extends HiveObject {
  @HiveField(0)
  String packageName;

  @HiveField(1)
  String baseUrl;

  @HiveField(2)
  String? fileUploadPath;

  OSBasicInfo({
    required this.packageName,
    required this.baseUrl,
    this.fileUploadPath,
  });
}

extension BasicInfoExt on OSBasicInfo {
  Future<void> get saveData async {
    final box = HiveBoxes.basicInfo;
    await box.put(packageName, this);
  }
}
