import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sample_fitpage/models/stock_model.dart';

class ApiCalling {
  String url = "http://coding-assignment.bombayrunning.com/data.json";

  Future<List<StockScan>> calling() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as List<dynamic>;
      List<StockScan> stocks =
          body.map((json) => StockScan.fromJson(json)).toList();

      // Iterate over each StockScan
      for (var stock in stocks) {
        print('Stock ID: ${stock.id}');
        print('Criteria:');
        // Iterate over each criteria
        for (var criteria in stock.criteria) {
          print('  Type: ${criteria.type}');
          print('  Text: ${criteria.text}');
          if (criteria.type == 'variable') {
            // Print variable if it exists
            if (criteria.variable != null) {
              print('  Variable:');
              // Check the type of the variable and print its values accordingly
              var variable = criteria.variable;
              if (variable!.containsKey('\$1')) {
                print('    \$1: ${variable['\$1']}');
              }
              if (variable.containsKey('\$2')) {
                print('    \$2: ${variable['\$2']}');
              }
              // Add conditions for other possible keys as needed
            }
          }
        }
        print('------------------');
      }

      return stocks;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
