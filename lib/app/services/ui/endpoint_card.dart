import 'package:covid_tracker_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  final String title;
  final String assetName;
  final Color color;

  EndpointCardData(this.title, this.assetName, this.color);
}

class EndpointCard extends StatelessWidget {
  final EndPoint endPoint;
  final int value;

  const EndpointCard({Key key, this.endPoint, this.value}) : super(key: key);

  static Map<EndPoint, EndpointCardData> _cardsData = {
    EndPoint.cases: EndpointCardData(
      'Cases',
      'assets/count.png',
      Color(0xFFFFF492),
    ),
    EndPoint.casesSuspected: EndpointCardData(
      'Suspected Cases',
      'assets/suspect.png',
      Color(0xFFEEDA28),
    ),
    EndPoint.casesConfirmed: EndpointCardData(
      'Confirmed Cases',
      'assets/fever.png',
      Color(0xFFE99600),
    ),
    EndPoint.deaths: EndpointCardData(
      'Deaths',
      'assets/death.png',
      Color(0xFFE40000),
    ),
    EndPoint.recovered: EndpointCardData(
      'Recovered',
      'assets/patient.png',
      Color(0xFF70A901),
    ),
  };

  String get formatedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endPoint];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData.title,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: cardData.color,
                    ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      cardData.assetName,
                      color: cardData.color,
                    ),
                    Text(
                      formatedValue,
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: cardData.color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
