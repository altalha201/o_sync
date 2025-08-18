part of '../extensions.dart';

extension OSFileExt on File {
  String get name => path.split('/').last;

  String get fileType => path.split('.').last;

  String get realSize {
    final bytes = lengthSync();
    if (bytes <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (bytes == 0) ? 0 : (bytes.bitLength / 10).floor();

    double size = bytes / (1 << (10 * i));
    return "${size.toStringAsFixed(2)} ${suffixes[i]}";
  }

  String get type {
    return p.extension(path).replaceFirst('.', '').toLowerCase();
  }

  String get category {
    final ext = type;

    const imageExts = ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'heic'];
    const videoExts = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm'];
    const audioExts = ['mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a'];
    const docExts   = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf', 'md'];
    const archiveExts = ['zip', 'rar', '7z', 'tar', 'gz'];

    if (imageExts.contains(ext)) return "Image";
    if (videoExts.contains(ext)) return "Video";
    if (audioExts.contains(ext)) return "Audio";
    if (docExts.contains(ext)) return "Document";
    if (archiveExts.contains(ext)) return "Archive";

    return "Other";
  }
}
