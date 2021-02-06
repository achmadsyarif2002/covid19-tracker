import 'package:covid_tracker_app/app/services/api.dart';
import 'package:covid_tracker_app/app/services/api_services.dart';
import 'package:covid_tracker_app/app/services/data_cache_services.dart';
import 'package:covid_tracker_app/app/services/endpoint_data.dart';
import 'package:covid_tracker_app/app/services/repositories/endpoints_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({
    @required this.apiServices,
    @required this.dataCacheService,
  });
  final APIServices apiServices;
  final DataCacheService dataCacheService;

  String _accessToken;
  Future<EndpointData> getEndPointData(EndPoint endPoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        onGetData: () => apiServices.getEndPointData(
          accessToken: _accessToken,
          endPoint: endPoint,
        ),
      );
  EndpointsData getAllEndpointsCacheData() {
    return dataCacheService.getData();
  }

  Future<EndpointsData> getAllEndpointsData() async {
    final endPointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEnpdointsData,
    );
    await dataCacheService.setData(endPointsData);
    return endPointsData;
  }

  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiServices.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiServices.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEnpdointsData() async {
    final values = await Future.wait(
      [
        apiServices.getEndPointData(
            accessToken: _accessToken, endPoint: EndPoint.cases),
        apiServices.getEndPointData(
            accessToken: _accessToken, endPoint: EndPoint.casesSuspected),
        apiServices.getEndPointData(
            accessToken: _accessToken, endPoint: EndPoint.casesConfirmed),
        apiServices.getEndPointData(
            accessToken: _accessToken, endPoint: EndPoint.deaths),
        apiServices.getEndPointData(
          accessToken: _accessToken,
          endPoint: EndPoint.recovered,
        ),
      ],
    );
    return EndpointsData(values: {
      EndPoint.cases: values[0],
      EndPoint.casesConfirmed: values[1],
      EndPoint.casesSuspected: values[2],
      EndPoint.deaths: values[3],
      EndPoint.recovered: values[4],
    });
  }
}
