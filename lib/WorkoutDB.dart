

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

import 'Planner.dart';
import 'Workout.dart';
import 'ZwoConverter.dart';
import 'nanopb/Workout.pb.dart';

class PlannedWeek {

  List<Workout> workouts;
  Distribution distribution = Distribution.empty();

  double sumTSS = 0;
  double sumDuration = 0;

  PlannedWeek.empty() : this.workouts = [] {
  }

  PlannedWeek(this.workouts) {

    for (var workout in workouts) {
      distribution.cumulate(workout.distribution);
    }

    workouts.forEach((Workout v) {
      sumTSS += v.TSS;
      sumDuration += v.duration;
    });

    for (int i=0; i < distribution.bins.length; i++) {
      distribution.bins[i] /= sumDuration;
      distribution.bins[i] *= 100.0;
    }

  }
}

class WorkoutDB extends ChangeNotifier {

  List<Workout> workoutDB = [];

  StreamController<PlannedWeek> potentialWeek = new StreamController<PlannedWeek>.broadcast();
  Stream<PlannedWeek> get getComputation => (potentialWeek.stream);

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

         potentialWeek.add(PlannedWeek(ret));
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
    Workout workout = Workout(rawWorkout: RawWorkout(name: 'Workout1',reps: reps), rawContent: '');

    List<Workout> ret = [workout, workout, workout, workout, workout];

    return ret;
  }

  Future<void> prepareSummary() async {


    final directory = await getApplicationDocumentsDirectory();
    var endDir = await Directory('${directory.path}/WeeGetter').create(recursive: true);

    File myFile = File('${endDir.path}/Summary.csv');

    String title = 'Name;Z2;Z3;Z4;Z5;Z6\n';
    await myFile.writeAsString(
      title,
      mode: FileMode.write,
    );

    for (Workout workout in workoutDB) {

      String line = workout.rawWorkout.name + ';' + workout.distribution.toCSV() + '\n';
      await myFile.writeAsString(
        line,
        mode: FileMode.append,
      );
    }

  }

  Future<void> startDB(Directory dir) async {

    workoutDB.clear();

    final directory = await getApplicationDocumentsDirectory();
    var endDir = await Directory('${directory.path}/WeePlanner').create(recursive: false);

    // execute an action on each entry
    endDir.list(recursive: true).forEach((entity) {
      if (entity is File &&
        entity.path.endsWith('.zwo')) {

        debugPrint('File ' + entity.path);

        String fileContent = entity.readAsStringSync();
        XmlDocument document = XmlDocument.parse(fileContent);

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

            workoutDB.add(Workout(rawWorkout: rawWorkout, rawContent: fileContent));
          }
        }
      }
    });
    notifyListeners();
  }
}