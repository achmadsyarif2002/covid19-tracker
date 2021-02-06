import 'package:covid_tracker_app/app/services/api.dart';
import 'package:covid_tracker_app/app/services/endpoint_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'repositories/endpoints_data.dart';

class DataCacheService {
  final SharedPreferences sharedPreferences;

  DataCacheService({
    @required this.sharedPreferences,
  });

  static String endPointvalueKey(EndPoint endPoint) {
    return '$endPoint/value';
  }

  static String endPointDateKey(EndPoint endPoint) {
    return '$endPoint/date';
  }

  EndpointsData getData() {
    Map<EndPoint, EndpointData> values = {};
    EndPoint.values.forEach((endPoint) {
      final value = sharedPreferences.getInt(endPointvalueKey(endPoint));
      final dateString = sharedPreferences.getString(endPointDateKey(endPoint));
      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[endPoint] = EndpointData(value: value, date: date);
      }
    });
    return EndpointsData(values: values);
  }

  Future<void> setData(EndpointsData data) async {
    data.values.forEach((endPoint, endPointData) async {
      await sharedPreferences.setInt(
          endPointvalueKey(endPoint), endPointData.value);
      await sharedPreferences.setString(
        endPointDateKey(endPoint),
        endPointData.date.toIso8601String(),
      );
    });
  }
}
