# o_sync

**A Mass Data Transaction Package for Flutter & Dart**

o_sync provides a robust way to handle **large-scale data synchronization** between local storage (Hive) and remote servers.  
It supports uploading, downloading, file syncing, and custom table mapping with ease.

---

## ✨ Features
- 📦 Hive-based local data storage.
- 🔄 Mass upload & download synchronization.
- 📂 File sync (upload/download large files).
- 🌐 Built-in network request & logging utilities.
- 🛠 Handy extensions for `DateTime`, `File`, `Map`, `BuildContext`.

---

## 📥 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  o_sync: ^0.0.4
```

Run
```bash
flutter pub get
```

## 🛠️ Setup

Ensure Initialization before running app.

```dart
import 'package:flutter/material.dart';
import 'package:o_sync/o_sync.dart';
/// Other Imports...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await OSync.init(
    basePackage: 'app-name',
    baseUrl: 'https://api.example.com',
    fileUploadPath: 'files', /// Optional endpoint for file uploads
  );
  
  runApp(MyApp());
}

/// Your Remaining Code...
```

## License
This project is licensed under the `MIT License`.

