

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

  return np;
}

int calculateDuration(RawWorkout rawWorkout)
{
  int dur = 0;

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

    NP = calculateNP(rawWorkout).round();
    IF = ((100 * NP) / FTP).round();
    TSS = (calculateDuration(rawWorkout) * NP * IF / (FTP * 3600)).round();
  }

  String toString() {
    return rawWorkout.toDebugString();
  }

}