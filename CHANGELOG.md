## 0.0.6

- Added support for multipart uploads combining JSON fields and file attachments
- Extended upload records to include associated file data
- Updated upload process to use multipart requests for improved API compatibility

## 0.0.5

- Added ability to delete a row from a table via `OSyncFunctionality.deleteRowFromTable`
- Improved upload behavior to continue processing even if some requests fail

## 0.0.4+2

- Fix `saveToHive` issue in hive models.

## 0.0.4+1

- Copyright (c) 2025 OSync Authors. All rights reserved.

## 0.0.4

- Renamed `FileExt` → `OSFileExt`
- Added `realSize`, `type`, and `category` getters to `OSFileExt`
- Added `OSMapExt` with `toBeautifiedString` for formatted JSON
- Added `OSBuildContextExt` with `copyToClipboard` and `showSnackBarOS`
- Renamed `StringExtension` → `OSStringExtension`
- Updated exports to include `context.dart` and `map.dart`

## 0.0.3

- Added `getFileData` static method to `OSyncFunctionality` to retrieve file table data
- Implemented `osGetFileTable` function to fetch records from `HiveBoxes.fileTable`
- Added `snakeCase` extension on `String`
- Updated exports in `functions.dart` and `extensions.dart` to include new files

## 0.0.2

- Updated file upload functionality

## 0.0.1

- Added Download Data
- Added Upload Data
- Added Upload File
- Added Get Download/Upload Data
