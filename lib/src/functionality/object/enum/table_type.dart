// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

/// Represents the type of an Offline Sync table.
///
/// Used to distinguish between upload tables, download tables, file tables,
/// or a placeholder/none type.
enum OSyncTableType {
  /// Table containing data to be uploaded to the server.
  uploadTable,

  /// Table containing data downloaded from the server.
  downloadTable,

  /// Table storing files for offline sync.
  fileTable,

  /// Represents no table type or an uninitialized state.
  none,
}

/// Extension providing helper methods for [OSyncTableType].
extension OSyncTableTypeExt on OSyncTableType {
  /// Returns the enum value as a simple string without the enum class prefix.
  String get name => toString().split('.').last;

  /// Returns `true` if this is an upload table.
  bool get isUpload => this == OSyncTableType.uploadTable;

  /// Returns `true` if this is a download table.
  bool get isDownload => this == OSyncTableType.downloadTable;

  /// Returns `true` if this is a file table.
  bool get isFile => this == OSyncTableType.fileTable;

  /// Returns `true` if this represents no table type.
  bool get isNone => this == OSyncTableType.none;
}
