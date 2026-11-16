import 'package:flutter/material.dart';

import 'backend.dart';

/// Loads rows once and builds [itemBuilder] for each, with loading, error and empty states.
class DataList extends StatefulWidget {
  const DataList({super.key, required this.load, required this.itemBuilder, this.emptyText = 'Nothing here yet.'});

  final Future<List<Map<String, dynamic>>> Function() load;
  final Widget Function(BuildContext context, Map<String, dynamic> item) itemBuilder;
  final String emptyText;

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  late Future<List<Map<String, dynamic>>> future = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Column(
            children: [
              Text(friendlyError(snap.error!), textAlign: TextAlign.center),
              TextButton(onPressed: () => setState(() => future = widget.load()), child: const Text('Try again')),
            ],
          );
        }
        final rows = snap.data ?? const <Map<String, dynamic>>[];
        if (rows.isEmpty) {
          return Padding(padding: const EdgeInsets.all(16), child: Text(widget.emptyText, textAlign: TextAlign.center));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [for (final row in rows) widget.itemBuilder(context, row)],
        );
      },
    );
  }
}
