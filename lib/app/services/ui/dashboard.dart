import 'dart:io';

import 'package:covid_tracker_app/app/services/api.dart';
import 'package:covid_tracker_app/app/services/repositories/data_repository.dart';
import 'package:covid_tracker_app/app/services/repositories/endpoints_data.dart';
import 'package:covid_tracker_app/app/services/ui/endpoint_card.dart';
import 'package:covid_tracker_app/app/services/ui/las_updated_status_text.dart';
import 'package:covid_tracker_app/app/services/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endPointsdata;
  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endPointsdata = await dataRepository.getAllEndpointsData();
      setState(() {
        _endPointsdata = endPointsdata;
      });
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data.Please try again later',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  void initState() {
    _updateData();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endPointsdata = dataRepository.getAllEndpointsCacheData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdate: _endPointsdata != null
          ? _endPointsdata.values[EndPoint.cases]?.date
          : null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Coronavirus Tracker'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatusText(
              text: formatter.lastUpdateStatusText(),
            ),
            for (var endPoint in EndPoint.values)
              EndpointCard(
                endPoint: endPoint,
                value: _endPointsdata != null
                    ? _endPointsdata.values[endPoint]?.value
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
