// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.

import 'dart:io';

void main() async {
  const header = """
// Copyright (c) 2025 OSync Authors. All rights reserved.
// Licensed under the MIT License. See LICENSE in the root directory.
""";

  final dir = Directory.current;

  await for (var entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith(".dart")) {
      final content = await entity.readAsString();

      // Skip if header already exists
      if (content.startsWith("// Copyright")) continue;

      final newContent = "$header\n$content";
      await entity.writeAsString(newContent);
      print("✔ Added header to ${entity.path}");
    }
  }
}
