
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wee_planner/Planner.dart';
import 'package:wee_planner/Workout.dart';
import 'package:wee_planner/WorkoutDB.dart';

import 'package:wee_planner/nanopb/Workout.pb.dart';

void main() {
  group('WorkoutSimple', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        RawInterval(duration: 3600, powerStart: 1.00, powerEnd: 1.00, cadence: 85),
      ]),
    ];
    Workout workout = Workout(rawWorkout: RawWorkout(reps: reps), rawContent: '');
    test('Duration', () {
      expect(workout.duration, equals(3600));
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
        RawInterval(duration: 3600, powerStart: 0.00, powerEnd: 1.00, cadence: 85),
      ]),
    ];
    Workout workout = Workout(rawWorkout: RawWorkout(reps: reps), rawContent: '');
    test('Duration', () {
      expect(workout.duration, equals(3600));
    });
    test('IF', () {
      expect(workout.IF, equals(67));
    });
  });

  group('WorkoutRamp2', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        RawInterval(duration: 3600, powerStart: 1.00, powerEnd: 0, cadence: 85),
      ]),
    ];
    Workout workout = Workout(rawWorkout: RawWorkout(reps: reps), rawContent: '');
    test('Duration', () {
      expect(workout.duration, equals(3600));
    });
    test('IF', () {
      expect(workout.IF, equals(67));
    });
  });

  group('Workout1', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        RawInterval(duration: 360, powerStart: 1.20, powerEnd: 1.20, cadence: 85),
        RawInterval(duration: 180, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
        RawInterval(duration: 360, powerStart: 1.20, powerEnd: 1.20, cadence: 85),
        RawInterval(duration: 180, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
        RawInterval(duration: 360, powerStart: 1.20, powerEnd: 1.20, cadence: 85),
        RawInterval(duration: 180, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
      ]),
    ];
    Workout workout = Workout(rawWorkout: RawWorkout(reps: reps), rawContent: '');
    test('Duration', () {
      expect(workout.duration, equals(1620));
    });
    test('TSS', () {
      expect(workout.TSS, equals(53));
    });
    test('IF', () {
      expect(workout.IF, equals(109));
    });
  });

  group('Workout2', () {
    List<Repetition> reps = [
      Repetition(intervals: [
        RawInterval(duration: 30, powerStart: 1.40, powerEnd: 1.40, cadence: 85),
        RawInterval(duration: 240, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
        RawInterval(duration: 30, powerStart: 1.40, powerEnd: 1.40, cadence: 85),
        RawInterval(duration: 240, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
        RawInterval(duration: 30, powerStart: 1.40, powerEnd: 1.40, cadence: 85),
        RawInterval(duration: 240, powerStart: 0.55, powerEnd: 0.55, cadence: 85),
      ]),
    ];
    Workout workout = Workout(rawWorkout: RawWorkout(reps: reps), rawContent: '');
    test('Duration', () {
      expect(workout.duration, equals(810));
    });
    test('TSS', () {
      expect(workout.TSS, equals(16)); // 13
    });
    test('IF', () {
      expect(workout.IF, equals(84)); // 75
    });
  });

  group('Distribution', () {

    test('Size', () {

      Distribution distribution1 = Distribution.phase1();
      Distribution distribution3 = Distribution.phase2();
      double affinity = distribution1.affinity(distribution1);
      double affinity2 = distribution1.affinity(distribution3);

      expect(affinity.toInt(), equals(2227));
      expect(affinity2.toInt(), lessThan(distribution1.maxAffinity()));
    });

  });

  group('Darwin', () {
    WorkoutDB workoutDB = WorkoutDB();
    PlannerSettings settings = PlannerSettings(DistributionType.Phase1, workoutsNb: 5, targetScore: 300);
    Directory dir = Directory('db');

    print(dir.toString());

    test('Size', () async {

      //print(Directory.current);
      await workoutDB.startDB(dir);

      expect(workoutDB.workoutDB.length, greaterThan(50));

      var plannedWeek = await plan(workoutDB.workoutDB, settings);
      debugPrint(plannedWeek.toString());
    });

  });

}
