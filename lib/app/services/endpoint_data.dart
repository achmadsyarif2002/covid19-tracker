import 'package:flutter/foundation.dart';

class EndpointData {
  final int value;
  final DateTime date;

  EndpointData({
    @required this.value,
    @required this.date,
  });

  @override
  String toString() => 'date:$date,value:$value';
}
