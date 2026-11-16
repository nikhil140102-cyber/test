import 'dart:async';

import 'package:flutter/material.dart';

import 'backend.dart';

/// Form values and button actions for pages with fields, sign-in or saving.
mixin PageActions<T extends StatefulWidget> on State<T> {
  final Map<String, TextEditingController> _fields = {};

  /// Values from checkboxes, switches and dropdowns, by field name.
  final Map<String, dynamic> values = {};

  bool busy = false;

  /// Controller for the text field saved as [key].
  TextEditingController field(String key) => _fields.putIfAbsent(key, TextEditingController.new);

  /// Text typed into the field saved as [key].
  String text(String key) => _fields[key]?.text.trim() ?? '';

  /// Every value on the page, ready to save. Password fields are never included.
  Map<String, dynamic> collect() => {
        for (final e in _fields.entries)
          if (!e.key.contains('password')) e.key: e.value.text.trim(),
        ...values,
      };

  /// Runs [task], shows [message] or the error, then optionally opens [goTo].
  /// A "Please wait…" note shows at once, and the task gives up after 60 seconds
  /// so a button never seems to do nothing.
  Future<void> run(Future<void> Function() task, {String? goTo, String? message, bool clear = true}) async {
    if (busy) return;
    setState(() => busy = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(const SnackBar(
      content: Row(children: [
        SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
        SizedBox(width: 12),
        Text('Please wait…'),
      ]),
      duration: Duration(seconds: 60),
    ));
    try {
      await task().timeout(const Duration(seconds: 60));
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      if (message != null) messenger.showSnackBar(SnackBar(content: Text(message)));
      if (goTo != null) {
        if (clear) {
          Navigator.of(context).pushNamedAndRemoveUntil(goTo, (route) => false);
        } else {
          Navigator.of(context).pushNamed(goTo);
        }
      }
    } catch (e) {
      debugPrint('Action failed: $e');
      if (mounted) {
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(SnackBar(content: Text(_explain(e)), duration: const Duration(seconds: 8)));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String _explain(Object e) {
    if (e is TimeoutException) {
      return 'No answer from the server after 60 seconds. Check the internet connection. For email codes, also check the SMTP settings in your backend.';
    }
    final raw = e.toString();
    if (RegExp(r'SocketException|Failed host lookup|ClientException|Connection (refused|reset|closed)', caseSensitive: false).hasMatch(raw)) {
      return 'No internet connection. Check that this phone or emulator is online, then try again.';
    }
    return friendlyError(e);
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }
}
