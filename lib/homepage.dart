import 'package:flutter/material.dart';
import 'package:sample_fitpage/function.dart';
import 'package:sample_fitpage/models/stock_model.dart';
import 'package:sample_fitpage/second_page.dart';
import 'package:sample_fitpage/text_converter.dart';

class ListviewPage extends StatefulWidget {
  ListviewPage({Key? key}) : super(key: key);

  @override
  _ListviewPageState createState() => _ListviewPageState();
}

class _ListviewPageState extends State<ListviewPage> {
  late Future<List<StockScan>> futureStockScans;
  final apiCalling = ApiCalling();
  List<StockScan> scans = [];
  @override
  void initState() {
    super.initState();
    futureStockScans = apiCalling.calling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              numberConverter();
            },
            child: Text("Fetch Data"),
          ),
          Expanded(
            child: FutureBuilder<List<StockScan>>(
              future: futureStockScans,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  scans = snapshot.data!;
                  return ListView.builder(
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(scans[4].criteria.length);
                          print(index);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SecondPage(
                              scan: scans,
                              index: index,
                            ),
                          ));
                        },
                        child: ListTile(
                          title: Text(scans[index].name),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return TextCoverter(
                text:
                    "Max of last 5 days close > Max of last 120 days close by \$1 %",
              );
            },
          ));
        },
      ),
    );
  }

  numberConverter() {
    int length = scans.length;

    for (var i = 0; i < length; i++) {
      scans[i].criteria.map((e) => print(e.text)).toList();
    }
  }
}
