import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(EmojiTableApp());
}

class EmojiTableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Table',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EmojiTableScreen(),
    );
  }
}

class EmojiTableScreen extends StatefulWidget {
  @override
  _EmojiTableScreenState createState() => _EmojiTableScreenState();
}

class _EmojiTableScreenState extends State<EmojiTableScreen> {
  List<dynamic>? _emojiData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEmojiData();
  }

  Future<void> _loadEmojiData() async {
    final String jsonString = await rootBundle.loadString('lib/emoji_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _emojiData = jsonData;
      _loading = false;
    });
  }

  String _unicodeToEmoji(String unicode) {
    final codePoints = unicode.split(' ').map((u) => int.parse(u.replaceAll('U+', ''), radix: 16));
    return String.fromCharCodes(codePoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emoji Table from JSON')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : _emojiData == null
                ? Text('No data loaded.')
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('SrNo')),
                          DataColumn(label: Text('Emoji')),
                          DataColumn(label: Text('Unicode')),
                          DataColumn(label: Text('Description')),
                        ],
                        rows: List<DataRow>.generate(
                          _emojiData!.length,
                          (index) {
                            final row = _emojiData![index];
                            final unicode = row['Unicode'].toString();
                            return DataRow(
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(_unicodeToEmoji(unicode), style: TextStyle(fontSize: 24))),
                                DataCell(Text(unicode)),
                                DataCell(Text(row['Description'].toString())),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
