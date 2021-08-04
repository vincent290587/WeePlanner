

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import 'Planner.dart';
import 'Workout.dart';
import 'ZwoConverter.dart';
import 'nanopb/Workout.pb.dart';

class WorkoutDB extends ChangeNotifier {

  List<Workout> workoutDB = [];

  StreamController<List<Workout>> potentialWeek = new StreamController<List<Workout>>.broadcast();
  Stream<List<Workout>> get getComputation => (potentialWeek.stream);

  WorkoutDB();

  Future<List<Workout>> computeWeek(PlannerSettings settings) async {
    if (workoutDB.length > 0) {
       var ret = await plan(workoutDB, settings);
       if (ret != null) {

         double sumTSS = 0;
         ret.forEach((Workout v) {
           sumTSS += v.TSS;
         });
         debugPrint('Best TSS match: ${sumTSS}');

         potentialWeek.add(ret);
         debugPrint(ret.toString());
         return ret;
       }
    }
    List<Workout> ret = [];
    return ret;
  }

  List<Workout> showWeek(PlannerSettings settings) {

    // TODO
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
    Workout workout = Workout(rawWorkout: RawWorkout(name: 'Workout1',reps: reps));

    List<Workout> ret = [workout, workout, workout, workout, workout];

    return ret;
  }

  Future<void> startDB(Directory dir) async {

    workoutDB.clear();

    //Directory dir = Directory('db');
    //print('Listing ' + dir.path);
    // execute an action on each entry
    dir.list(recursive: true).forEach((entity) {
      if (entity is File &&
        entity.path.endsWith('.zwo')) {

        debugPrint('File ' + entity.path);

        XmlDocument document = XmlDocument.parse(entity.readAsStringSync());

        XmlElement root = document.rootElement;
        //debugPrint('Root name ' + root.name.toString());

        //XmlElement element = root.firstElementChild!;
        //debugPrint('First child name ' + element.name.toString());

        String? wName;
        XmlElement? wName_ = root.getElement('name');
        if (wName_ != null) {
          wName = wName_.text;
        }

        XmlElement? wrkt = root.getElement('workout');
        if (wrkt != null) {
          List<Repetition> intervals = [];
          for (final xmlInterval in wrkt.children) {
            if (xmlInterval is XmlElement) {

              Repetition interval = convertZwo(xmlInterval);
              intervals.add(interval);
            }
          }

          if (intervals.isNotEmpty) {

            RawWorkout rawWorkout = RawWorkout(
              name: wName,
              author: 'Vincent Golle',
              reps: intervals,
            );

            workoutDB.add(Workout(rawWorkout: rawWorkout));
          }
        }
      }
    });
  }
}