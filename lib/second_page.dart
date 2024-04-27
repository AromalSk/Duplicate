import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sample_fitpage/last_scaffold.dart';
import 'package:sample_fitpage/models/stock_model.dart';

class SecondPage extends StatelessWidget {
  final List<StockScan> scan;
  final int index;

  SecondPage({Key? key, required this.scan, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, Variable>?> variableMaps =
        scan[index].criteria.map((e) => e.variable).toList();

// Filter out null values from variableMaps
    variableMaps.removeWhere((variable) => variable == null);

    List<String?> replacedTexts = replaceVariablesInList(
      scan[index].criteria.map((e) => e.text).toList(),
      variableMaps.cast<Map<String, dynamic>>(), // Cast to remove null values
    );

// Filter out null values from replacedTexts
    replacedTexts.removeWhere((text) => text == null);

    print(replacedTexts);

    return Scaffold(
      appBar: AppBar(title: Text(scan[index].name)),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: replacedTexts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildRichTextWithClickableNumbers(
                    replacedTexts[index]!, context),
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }

  Widget buildRichTextWithClickableNumbers(
      String segment, BuildContext context) {
    List<TextSpan> textSpans = [];

    // Replace incorrect characters with correct ones
    segment = segment.replaceAll('â', '\'');

    // Use regular expression to match numbers enclosed in parentheses
    RegExp regExp = RegExp(r"\(-?\d*\.?\d+\)");

    // Find all matches of the regular expression
    Iterable matches = regExp.allMatches(segment);

    // Start index for the next match
    int startIndex = 0;

    // Iterate through each match
    for (RegExpMatch match in matches) {
      // Add the text before the match
      if (match.start > startIndex) {
        textSpans.add(
          TextSpan(
            text: segment.substring(startIndex, match.start),
            style: TextStyle(color: Colors.green),
          ),
        );
      }

      // Add the matched number
      String number = segment.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: number,
          style: TextStyle(color: Colors.purple),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Handle the click action
              print("You tapped on number: $number");
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return LastScaffold(
                    scan: scan,
                    index: index,
                  );
                },
              ));
            },
        ),
      );

      // Update the start index for the next iteration
      startIndex = match.end;
    }

    // Add any remaining text after the last match
    if (startIndex < segment.length) {
      textSpans.add(
        TextSpan(
          text: segment.substring(startIndex),
          style: TextStyle(color: Colors.green),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.green),
        children: textSpans,
      ),
    );
  }

  // Widget buildRichTextWithClickableNumbers(List<String> segments) {
  //   List<TextSpan> textSpans = [];

  //   for (int i = 0; i < segments.length; i++) {
  //     String segment = segments[i];
  //     if (i % 2 == 0) {
  //       // Regular text segment
  //       textSpans.add(
  //           TextSpan(text: segment, style: TextStyle(color: Colors.green)));
  //     } else {
  //       // Number segment enclosed in parentheses
  //       textSpans.add(
  //         TextSpan(
  //           text: segment,
  //           style: TextStyle(color: Colors.purple),
  //           recognizer: TapGestureRecognizer()
  //             ..onTap = () {
  //               print(
  //                   "You tapped on number: ${segment.replaceAll('(', '').replaceAll(')', '')}");
  //             },
  //         ),
  //       );
  //     }
  //   }

  //   return RichText(
  //       text: TextSpan(
  //           style: TextStyle(color: Colors.green), children: textSpans));
  // }

  List<String> splitString(String inputString) {
    RegExp pattern = RegExp(r'\(-?\d+\)');
    Iterable<RegExpMatch> matches = pattern.allMatches(inputString);
    List<String> segments = [];
    int previousIndex = 0;
    for (RegExpMatch match in matches) {
      segments.add(inputString.substring(previousIndex, match.start));
      segments.add(match.group(0)!);
      previousIndex = match.end;
    }
    segments.add(inputString.substring(previousIndex));

    return segments;
  }

  List<String> extractPlainText(List<dynamic> criteriaList) {
    List<String> plainTexts = [];

    for (var criteria in criteriaList) {
      // Check if criteria is an instance of Criteria class
      if (criteria is Criteria && criteria.type == 'plain_text') {
        plainTexts
            .add(criteria.text); // Accessing properties using dot notation
      }
    }
    return plainTexts;
  }

  List<String> replaceVariablesInList(
      List<String> texts, List<Map<String, dynamic>> variablesList) {
    List<String> replacedTexts = [];

    for (var text in texts) {
      String replacedText = text;
      for (var variable in variablesList) {
        for (var i = 1; i <= 5; i++) {
          if (variable.containsKey('\$$i')) {
            var value = variable['\$$i'];
            if (value != null && value['type'] == 'value') {
              var values = value['values'] as List<dynamic>?;
              if (values != null && values.isNotEmpty) {
                replacedText =
                    replacedText.replaceAll('\$$i', '(${values[0]})');
              }
            } else if (value != null && value['type'] == 'indicator') {
              replacedText =
                  replacedText.replaceAll('\$$i', '(${value['defaultValue']})');
            }
          }
        }
      }
      replacedTexts.add(replacedText);
    }

    return replacedTexts;
  }

  List<String> numberConverter() {
    List<String> result = [];
    for (var criterion in scan[index].criteria) {
      if (criterion.type == "variable") {
        var variable = criterion.variable;
        if (variable != null) {
          for (var key in variable.keys) {
            var value = variable[key];
            if (value != null && value['type'] == 'value') {
              var values = value['values'];
              if (values != null) {
                for (var val in values) {
                  result.add(val.toString());
                }
              }
            }
          }
        }
      }
    }
    print(result);
    return result;
  }

  String? defaultValueFromIndicator() {
    for (var criterion in scan[index].criteria) {
      if (criterion.type == "variable") {
        var variable = criterion.variable;
        if (variable != null) {
          for (var key in variable.keys) {
            var value = variable[key];
            if (value != null && value['type'] == 'indicator') {
              print(value['defaultValue'].toString());
              return value['defaultValue'].toString();
            }
          }
        }
      }
    }
    return null; // Return null if no default value found
  }

  // List<String> numberConverter() {
  //   List<String> result = scan[index].criteria.map((e) => e.text).toList();
  //   final answer =  scan[index].criteria.map((e){
  //     if (e.type == "variable") {
  //       e.variable!.map((key, value) {
  //         if (value.type == "value") {
  //           return value!.values!.toList();
  //         }else{

  //         }
  //       });
  //     }else{
  //       return ;
  //     }
  //   });

  //   print(result);
  //   return result;
  // }
}






   // print(scan[index!].criteria[0].variable!["\$1"]!.values);
          // print(scan[index!].criteria[0].variable!["\$2"]!.values);