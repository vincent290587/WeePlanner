
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'Workout.dart';

num getZoneName(double val, int pos) {
  return pos+1;
}

Color getZoneColor(double val, int pos) {
  switch (pos) {
    case 0:
      return Colors.green;
      break;
    case 1:
      return Colors.orange;
      break;
    case 2:
      return Colors.pink;
      break;
  }
  return Colors.grey;
}

Widget getThreeZoneGraph(Distribution distribution) {

  double maxValue = 0;
  dynamic spots;
  ThreeZonesDistribution threeZones = ThreeZonesDistribution(distribution);

  for (int i=0; i < threeZones.bins.length; i++) {

    if (maxValue < threeZones.bins[i]) {
      maxValue = threeZones.bins[i];
    }
  }

  try {
    spots = <ChartSeries>[
      // Initialize line series
      BarSeries<double, num>(
        dataSource: threeZones.bins,
        pointColorMapper: getZoneColor,
        xValueMapper: getZoneName,
        yValueMapper: (double prm, _) => prm,
        borderRadius: BorderRadius.all(Radius.circular(5)), // Sets the corner radius
        //name: paramName,
      ),
    ];
  } catch (e) {
    return Container(
      //color: const Color(0xff262545),
      margin: const EdgeInsets.all(20.0),
      child: Text('Graph error: \n '),
    );
  }

  return SfCartesianChart(
    series: spots,
    primaryXAxis: CategoryAxis(
      // X axis is hidden now
        isInversed: true,
        isVisible: false
    ),
    primaryYAxis: NumericAxis(
      // Y axis is hidden now
      isVisible: false,
      minimum: 0.0,
      //maximum: 40.0,
    ),
  );
}