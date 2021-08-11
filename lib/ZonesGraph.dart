
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
      return Colors.grey;
      break;
    case 1:
      return Colors.lightBlue;
      break;
    case 2:
      return Colors.green;
      break;
    case 3:
      return Colors.yellow;
      break;
    case 4:
      return Colors.orange;
      break;
    case 5:
      return Colors.red;
      break;
  }
  return Colors.grey;
}

Widget getGraph(List<Workout> workouts) {

  double sumDuration = 0;
  dynamic spots ;
  Distribution distribution = Distribution.empty();

  for (var workout in workouts) {
    distribution.cumulate(workout.distribution);
    sumDuration += workout.duration;
  }

  for (int i=0; i < distribution.bins.length; i++) {
    distribution.bins[i] /= sumDuration;
  }

  try {
    spots = <ChartSeries>[
      // Initialize line series
      ColumnSeries<double, num>(
        dataSource: distribution.bins,
        pointColorMapper: getZoneColor,
        xValueMapper: getZoneName,
        yValueMapper: (double prm, _) => prm,
        borderRadius: BorderRadius.all(Radius.circular(15)), // Sets the corner radius
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

  return FittedBox(
    fit: BoxFit.fitHeight,
    child: SfCartesianChart(
      series: spots,
      primaryXAxis: CategoryAxis(
        // X axis is hidden now
        isVisible: false
      ),
      primaryYAxis: NumericAxis(
        // X axis is hidden now
        isVisible: false
      ),
    ),
  );
}