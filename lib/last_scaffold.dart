import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sample_fitpage/models/stock_model.dart';

class LastScaffold extends StatelessWidget {
  const LastScaffold({super.key, required this.scan, required this.index});

  final List<StockScan> scan;
  final int index;

  @override
  Widget build(BuildContext context) {
    final hello = numberConverter();

    return Scaffold(
      appBar: AppBar(
        title: Text("Last Page"),
      ),
      body: ListView.builder(
        itemCount: hello.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(hello[index]),
          );
        },
      ),
    );
  }

  List<String> numberConverter() {
    List<String> result = [];
    for (var criterion in scan[index].criteria) {
      if (criterion.type == "variable") {
        var variable = criterion.variable;
        if (variable != null) {
          for (var key in variable.keys) {
            var value = variable[key];
            log(value!.values.toString());
            if (value != null && value['type'] == 'value') {
              var values = value['values'];
              result.add(values.toString());
            }
          }
        }
      }
    }
    return result;
  }
}

// List<String> numberConverter(int index, List<String> apiString) {
//   List<String> result = [];

//   // Split the criterion using commas to separate individual criteria
//   List<String> criteriaList = apiString[index].split(', ');

//   // Iterate over each criterion to extract values
//   for (String criterion in criteriaList) {
//     // Find the index of the parenthesis and extract the number within
//     int startIndex = criterion.indexOf('(');
//     int endIndex = criterion.indexOf(')');
//     if (startIndex != -1 && endIndex != -1) {
//       String numberString = criterion.substring(startIndex + 1, endIndex);
//       int dollarIndex = int.parse(numberString) - 1;

//       // Access the criteria directly from the StockScan object
//       var variable = scan[index].criteria[0].variable;
//       var values = variable?['\$$dollarIndex']?['values'];
//       if (values != null) {
//         for (var val in values) {
//           result.add(val.toString());
//         }
//       }
//     }
//   }

//   return result;
// }

