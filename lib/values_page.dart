import 'package:flutter/material.dart';

class ValuesPage extends StatelessWidget {
  final Map<String, dynamic> values;

  const ValuesPage({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Values')),
      body: ListView(
        children: values.entries
            .map(
              (entry) => ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}
