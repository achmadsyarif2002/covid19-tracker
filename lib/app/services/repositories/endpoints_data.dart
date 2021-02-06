import 'package:covid_tracker_app/app/services/api.dart';
import 'package:covid_tracker_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';

class EndpointsData {
  EndpointsData({
    @required this.values,
  });
  final Map<EndPoint, EndpointData> values;
  EndpointData get cases => values[EndPoint.cases];
  EndpointData get casesConfirmed => values[EndPoint.casesConfirmed];
  EndpointData get casesSuspected => values[EndPoint.casesSuspected];
  EndpointData get deaths => values[EndPoint.deaths];
  EndpointData get recovered => values[EndPoint.recovered];
}
