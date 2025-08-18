part of '../extensions.dart';

/// Extension on [BuildContext] to provide handy utilities for
/// copying text to clipboard and showing snack bars.
extension OSBuildContextExt on BuildContext {
  /// Copies [textToCopy] to the system clipboard.
  ///
  /// If the text is empty, a snack bar is shown with a warning.
  /// On successful copy, a confirmation snack bar is shown.
  /// On failure, an error snack bar is shown.
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

  /// Displays a [SnackBar] with the given [message].
  ///
  /// This is a helper for quick feedback messages in the UI.
  void showSnackBarOS({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
