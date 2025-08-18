// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'package:hive_ce/hive.dart';
import '../../../../core/constants/hive.dart';

part 'basic_info.g.dart';

/// Stores basic app information used for offline synchronization.
///
/// This includes the app package name, base API URL, and an optional
/// path for file uploads.
@HiveType(typeId: HiveBoxType.baseInfo)
class OSBasicInfo extends HiveObject {
  /// The unique package name of the application.
  @HiveField(0)
  String packageName;

  /// The base URL used for API requests in offline sync.
  @HiveField(1)
  String baseUrl;

  /// Optional path for file upload operations.
  @HiveField(2)
  String? fileUploadPath;

  /// Creates a new instance of [OSBasicInfo].
  ///
  /// [packageName] and [baseUrl] are required.
  OSBasicInfo({
    required this.packageName,
    required this.baseUrl,
    this.fileUploadPath,
  });
}

/// Extension providing convenience methods for [OSBasicInfo].
extension BasicInfoExt on OSBasicInfo {
  /// Saves the current instance to the Hive basic info box.
  ///
  /// The object is stored with [packageName] as the key.
  Future<void> get saveData async {
    final box = HiveBoxes.basicInfo;
    await box.put(packageName, this);
  }
}
