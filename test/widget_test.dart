
import 'package:flutter_test/flutter_test.dart';
import 'package:wee_planner/Workout.dart';

import 'package:wee_planner/nanopb/Workout.pb.dart';

void main() {
  group('Workout', () {
    test('Power_single', () {
      List<Repetition> reps = [
        Repetition(intervals: [
          Interval(duration: 3600, powerStart: 277, powerEnd: 277, cadence: 85),
        ]),
      ];
      Workout workout = Workout(RawWorkout(reps: reps));
      expect(workout.TSS, equals(100));
    });

  });

}
