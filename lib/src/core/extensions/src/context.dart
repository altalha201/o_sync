part of '../extensions.dart';

extension OSBuildContextExt on BuildContext {
  Future<void> copyToClipboard({required String textToCopy}) async {
    final context = this;
    if (textToCopy.isEmpty) {
      if (context.mounted) {
        showSnackBarOS(message: "Text to copy is empty");
      }
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: textToCopy));
      if (context.mounted) {
        showSnackBarOS(message: "Copied to clipboard");
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBarOS(message: "Failed to copy to clipboard");
      }
    }
  }

  void showSnackBarOS({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
