

import 'dart:math';

import 'constants.dart';
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
      int? pow1 = interval.getField(2);
      int? pow2 = interval.getField(3); // TODO
      if (duri != null && pow1 != null && pow2 != null) {
        np += duri * pow(pow1.toDouble(), 4);
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
  late int NP;
  late int IF;
  late WorkoutFocus focus;

  final RawWorkout rawWorkout;

  Workout(this.rawWorkout) {

    duration = calculateDuration(rawWorkout);
    NP = calculateNP(rawWorkout).round();
    IF = ((100 * NP) / FTP).round();
    TSS = (duration * NP * IF / (FTP * 3600)).round();
  }

  String toString() {
    return rawWorkout.toDebugString();
  }

}