import 'package:covid_tracker_app/app/services/api_keys.dart';
import 'package:flutter/foundation.dart';

enum EndPoint { cases, casesSuspected, casesConfirmed, deaths, recovered }

class API {
  API({@required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);

  static final String host = 'ncov2019-admin.firebaseapp.com';

  Uri tokenUri() {
    return Uri(
      scheme: 'https',
      host: host,
      path: 'token',
    );
  }

  Uri endPointUri(EndPoint endPoint){
    return Uri(
      scheme: 'https',
      host: host,
      path: _paths[endPoint],
    );
  }

  static Map<EndPoint, String> _paths = {
    EndPoint.cases: 'cases',
    EndPoint.casesConfirmed: 'casesConfirmed',
    EndPoint.casesSuspected: 'casesSuspected',
    EndPoint.deaths: 'deaths',
    EndPoint.recovered: 'recovered',
  };
}
