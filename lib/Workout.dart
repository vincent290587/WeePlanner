

import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'nanopb/Workout.pb.dart';


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

  late RawWorkout rawWorkout;

  Workout({required this.rawWorkout}) {

    duration = calculateDuration(rawWorkout);
    _NP = (100 * calculateNP(rawWorkout)).round();
    IF = _NP;
    TSS = (duration * _NP * IF / 360000).round();

    // debugPrint('Computed TSS: ${TSS}');
    // debugPrint('Computed Dur: ${duration}');
  }

  String toString() {
    String ret = '${rawWorkout.name}: TSS= ${TSS}: IF= ${IF} \n';
    return ret;
  }

  Workout.fromJson(Map<String, dynamic> json)
      : duration = json['dur'],
        TSS = json['tss'],
        _NP = json['np'],
        IF = json['if'],
        rawWorkout = RawWorkout.fromJson(json['proto']);

  Map<String, dynamic> toJson() {
    return {
      'dur': duration,
      'tss': TSS,
      'np': _NP,
      'if': IF,
      'proto': rawWorkout.writeToJson(),
    };
  }

}