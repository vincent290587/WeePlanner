
import 'package:flutter_test/flutter_test.dart';
import 'package:wee_planner/Workout.dart';
import 'package:wee_planner/constants.dart';

import 'package:wee_planner/nanopb/Workout.pb.dart';

void main() {
  group('WorkoutSimple', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        Interval(duration: 3600, powerStart: FTP, powerEnd: FTP, cadence: 85),
      ]),
    ];
    Workout workout = Workout(RawWorkout(reps: reps));
    test('Duration', () {
      expect(workout.duration, equals(3600));
    });
    test('NP', () {
      expect(workout.NP, equals(FTP));
    });
    test('TSS', () {
      expect(workout.TSS, equals(100));
    });
    test('IF', () {
      expect(workout.IF, equals(100));
    });
  });

  group('WorkoutRamp1', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        Interval(duration: 3600, powerStart: 0, powerEnd: FTP, cadence: 85),
      ]),
    ];
    Workout workout = Workout(RawWorkout(reps: reps));
    test('Duration', () {
      expect(workout.duration, equals(3600));
    });
    test('NP', () {
      expect(workout.NP, equals(185));
    });
  });

  group('WorkoutRamp2', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        Interval(duration: 3600, powerStart: FTP, powerEnd: 0, cadence: 85),
      ]),
    ];
    Workout workout = Workout(RawWorkout(reps: reps));
    test('Duration', () {
      expect(workout.duration, equals(3600));
    });
    test('NP', () {
      expect(workout.NP, equals(185));
    });
  });

  group('Workout1', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        Interval(duration: 360, powerStart: 252, powerEnd: 252, cadence: 85),
        Interval(duration: 180, powerStart: 154, powerEnd: 154, cadence: 85),
        Interval(duration: 360, powerStart: 252, powerEnd: 252, cadence: 85),
        Interval(duration: 180, powerStart: 154, powerEnd: 154, cadence: 85),
        Interval(duration: 360, powerStart: 252, powerEnd: 252, cadence: 85),
        Interval(duration: 180, powerStart: 154, powerEnd: 154, cadence: 85),
      ]),
    ];
    Workout workout = Workout(RawWorkout(reps: reps));
    test('Duration', () {
      expect(workout.duration, equals(1620));
    });
    test('NP', () {
      expect(workout.NP, equals(232));
    });
    test('TSS', () {
      expect(workout.TSS, equals(32));
    });
    test('IF', () {
      expect(workout.IF, equals(84));
    });
  });

}
