

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

class Distribution {

  static const List<double> _pwLims = [
    -100.0,
    0.55,
    0.75,
    0.90,
    1.05,
    1.20,
    1.50,
    100.0
  ];

  late List<double> bins;

  Distribution.empty() {
    bins = [0,0,0,0,0,0];
  }

  Distribution(RawWorkout _rawWorkout) {

    bins = [0,0,0,0,0,0];

    for (var rep in _rawWorkout.reps) {
      for (var interval in rep.intervals) {
        int duri = interval.getField(1);
        double pow1 = interval.getField(2);
        double pow2 = interval.getField(3);
        double pw_meas = (pow1 + pow2) / 2;
        // find the bin
        for (int i=0; i < bins.length; i++) {
          if (pw_meas >= _pwLims[i] &&
              pw_meas < _pwLims[i+1]) {
            // update bin i
            bins[i] += duri;
          }
        }
      }
    }
  }

  void cumulate(Distribution other) {
    for (int i=0; i < bins.length; i++) {
      this.bins[i] += other.bins[i];
    }
  }
}

class Workout {

  late int duration;
  late int TSS;
  late int _NP;
  late int IF;
  //late WorkoutFocus focus;
  late Distribution distribution;

  late RawWorkout rawWorkout;

  Workout({required this.rawWorkout}) {

    distribution = Distribution(rawWorkout);
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