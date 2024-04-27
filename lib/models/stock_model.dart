class StockScan {
  final int id;
  final String name;
  final String tag;
  final String color;
  final List<Criteria> criteria;

  StockScan({
    required this.id,
    required this.name,
    required this.tag,
    required this.color,
    required this.criteria,
  });

  factory StockScan.fromJson(Map<String, dynamic> json) {
    return StockScan(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      color: json['color'],
      criteria: List<Criteria>.from(
          json['criteria'].map((x) => Criteria.fromJson(x))),
    );
  }
}

class Criteria {
  final String type;
  final String text;
  final Map<String, Variable>? variable;

  Criteria({
    required this.type,
    required this.text,
    this.variable,
  });

  factory Criteria.fromJson(Map<String, dynamic> json) {
    return Criteria(
      type: json['type'],
      text: json['text'],
      variable: json['variable'] != null
          ? Map.from(json['variable']).map(
              (k, v) => MapEntry<String, Variable>(k, Variable.fromJson(v)))
          : null,
    );
  }
}

class Variable {
  final String type;
  final String? studyType;
  final String? parameterName;
  final int? minValue;
  final int? maxValue;
  final dynamic defaultValue;
  final List<dynamic>? values;

  Variable({
    required this.type,
    this.studyType,
    this.parameterName,
    this.minValue,
    this.maxValue,
    this.defaultValue,
    this.values,
  });

  factory Variable.fromJson(Map<String, dynamic> json) {
    return Variable(
      type: json['type'],
      studyType: json['study_type'],
      parameterName: json['parameter_name'],
      minValue: json['min_value'],
      maxValue: json['max_value'],
      defaultValue: json['default_value'],
      values:
          json['values'] != null ? List<dynamic>.from(json['values']) : null,
    );
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'type':
        return type;
      case 'studyType':
        return studyType;
      case 'parameterName':
        return parameterName;
      case 'minValue':
        return minValue;
      case 'maxValue':
        return maxValue;
      case 'defaultValue':
        return defaultValue;
      case 'values':
        return values;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}
