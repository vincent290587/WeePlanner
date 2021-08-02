

import 'dart:math';

import 'package:flutter/foundation.dart';

import 'nanopb/Workout.pb.dart';

// int getIntervalTSS(Interval interval)
// {
//   int tss = 0;
//
//   return tss;
// }

double calculateNP(RawWorkout rawWorkout)
{
  double np = 0;
  double dur = 0;

  for (var rep in rawWorkout.reps) {
    for (var interval in rep.intervals) {
      int? duri = interval.getField(1);
      double? pow1 = interval.getField(2);
      double? pow2 = interval.getField(3);
      if (duri != null && pow1 != null && pow2 != null) {
        if (pow1 == pow2) {
          np += duri * pow(pow1, 4);
        } else {
          double b = pow2 - pow1;
          np += duri * (pow(pow2, 5) - pow(pow1, 5)) / (5 * b);
        }
        dur += duri;
      }
    }
  }

  np = pow(np / dur, 0.25).toDouble();

  return np;
}

int calculateDuration(RawWorkout rawWorkout)
{
  int dur = 0;

  for (var rep in rawWorkout.reps) {
    for (var interval in rep.intervals) {
      int? ret = interval.getField(1);
      if (ret != null) {
        dur += ret;
      }
    }
  }

  return dur;
}

class Workout {

  late int duration;
  late int TSS;
  late int _NP;
  late int IF;
  late WorkoutFocus focus;

  final RawWorkout rawWorkout;

  Workout(this.rawWorkout) {

    duration = calculateDuration(rawWorkout);
    _NP = (100 * calculateNP(rawWorkout)).round();
    IF = _NP;
    TSS = (duration * _NP * IF / 360000).round();

    debugPrint('Computed TSS: ${TSS}');
  }

  String toString() {
    return rawWorkout.toDebugString();
  }

}