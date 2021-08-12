
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'Workout.dart';

num getZoneName(double val, int pos) {
  return pos+1;
}

Color getZoneColor(gPoint point, int pos) {

  // 0.55,
  // 0.75,
  // 0.90,
  // 1.05,
  // 1.20,
  // 1.50,
  double val = point.y;

  if (val < 0.55) {
    return Colors.grey;
  } else if (val < 0.75) {
    return Colors.lightBlue;
  } else if (val < 0.90) {
    return Colors.green;
  } else if (val < 1.05) {
    return Colors.yellow;
  } else if (val < 0.90) {
    return Colors.orange;
  } else {
    return Colors.red;
  }

  return Colors.grey;
}

class gPoint {

  double x;
  double y;

  gPoint({required this.x, required this.y});

}

Widget getWorkoutGraph(Workout workout) {

  dynamic spots ;

  List<gPoint> xPoints = [];

  double xDuration = 0.0;
  for (var rep in workout.rawWorkout.reps) {
    for (var interval in rep.intervals) {
      int duri = interval.getField(1);
      double pow1 = interval.getField(2);
      double pow2 = interval.getField(3);
      xPoints.add(gPoint(x: xDuration, y: pow1));
      xDuration += duri;
      xPoints.add(gPoint(x: xDuration, y: pow2));
    }
  }

  try {
    spots = <ChartSeries>[
      // Initialize line series
      StepAreaSeries<gPoint, num>(
        dataSource: xPoints,
        pointColorMapper: getZoneColor,
        xValueMapper: (gPoint prm, _) => prm.x,
        yValueMapper: (gPoint prm, _) => prm.y*100.0,
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
    primaryXAxis: NumericAxis(
        isVisible: true
    ),
    primaryYAxis: NumericAxis(
      isVisible: true,
      // minimum: 0.0,
      // maximum: 40.0,
    ),
  );
}