import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedDateFormatter {
  final DateTime lastUpdate;

  LastUpdatedDateFormatter({this.lastUpdate});

  String lastUpdateStatusText() {
    if (lastUpdate != null) {
      final formatter = DateFormat().add_yMd().add_Hms();
      final formatted = formatter.format(lastUpdate);
      return 'Last updated :$formatted';
    }
    return '';
  }
}

class LastUpdatedStatusText extends StatelessWidget {
  final String text;

  const LastUpdatedStatusText({Key key, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
