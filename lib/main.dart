import 'package:covid_tracker_app/app/services/api.dart';
import 'package:covid_tracker_app/app/services/api_services.dart';
import 'package:covid_tracker_app/app/services/data_cache_services.dart';
import 'package:covid_tracker_app/app/services/endpoint_data.dart';
import 'package:covid_tracker_app/app/services/repositories/data_repository.dart';
import 'package:covid_tracker_app/app/services/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en_GB';
  await initializeDateFormatting();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key key, @required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (ctx) => DataRepository(
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
        ),
        apiServices: APIServices(
          API.sandbox(),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid-19 Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _accessToken = '';
  EndpointData _cases;
  EndpointData _deaths;
  void _updateAccessToken() async {
    final apiService = APIServices(API.sandbox());
    final accessToken = await apiService.getAccessToken();
    final cases = await apiService.getEndPointData(
      accessToken: accessToken,
      endPoint: EndPoint.cases,
    );
    final deaths = await apiService.getEndPointData(
      accessToken: accessToken,
      endPoint: EndPoint.deaths,
    );
    setState(() {
      _accessToken = accessToken;
      _cases = cases;
      _deaths = deaths;
    });
    // print(_accessToken);
    print('Total Cases:$_cases');
    print('Total Deaths:$_deaths');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_accessToken',
              style: Theme.of(context).textTheme.headline4,
            ),
            if (_cases != null)
              Text(
                'Cases:$_cases',
                style: Theme.of(context).textTheme.headline4,
              ),
            if (_deaths != null)
              Text(
                'Deaths:$_deaths',
                style: Theme.of(context).textTheme.headline4,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateAccessToken();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
