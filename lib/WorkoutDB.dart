

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';

import 'utils.dart';
import 'Planner.dart';
import 'Workout.dart';
import 'ZwoConverter.dart';
import 'nanopb/Workout.pb.dart';

class PlannedWeek {

  List<Workout> workouts;
  Distribution distribution = Distribution.empty();
  final double score;

  int sumTSS = 0;
  int sumDuration = 0;

  PlannedWeek.empty() : this.workouts = [], score=0;

  PlannedWeek(this.workouts) : this.score=0 {

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

  PlannedWeek.full(this.workouts, this.score) {

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

  StreamController<List<PlannedWeek>> potentialWeek = new StreamController<List<PlannedWeek>>.broadcast();
  Stream<List<PlannedWeek>> get getComputation => (potentialWeek.stream);

  WorkoutDB();

  Future<List<Workout>> computeWeek(PlannerSettings settings) async {
    if (workoutDB.length > 0) {

       PlannerInput input = PlannerInput(workoutDB, settings);

       Future<List<PlannedWeek>>? planned;

       if (isDesktopPlatform()) {
         planned = compute(plan, input);
       } else {
         planned = plan(input);
       }
       var ret = await planned;

       debugPrint('Best TSS match: ${ret.first.sumTSS}');

       if (ret.isNotEmpty) {

         potentialWeek.add(ret);

         return ret.first.workouts;
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

    if (!isDesktopPlatform()) {
      return;
    }

    final directory = await getDocumentsDirectory();
    var endDir = await Directory('${directory.path}/WeeGetter').create(recursive: true);

    File myFile = File('${endDir.path}/Summary.txt');

    String title = 'Name;Z2;Z3;Z4;Z5;Z6;IF\n';
    await myFile.writeAsString(
      title,
      mode: FileMode.write,
    );

    for (Workout workout in workoutDB) {

      String line = workout.rawWorkout.name + ';' +
          workout.distribution.toCSV() + ';' +
          workout.IF.toStringAsFixed(0) +
          '\n';
      await myFile.writeAsString(
        line,
        mode: FileMode.append,
      );
    }

  }

  int _addStringWorkout(String fileContent) {

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
        return 0;
      }
    }

    return 1;
  }

  Future<void> startDBWeb(String subDir) async {

    workoutDB.clear();

    pseudoDB.forEach((element) {

      String fileContent = element.content;

      if (0 == _addStringWorkout(fileContent)) {
        notifyListeners();
      }
    });

  }

  Future<void> startDBDesktop(String subDir) async {

    workoutDB.clear();

    final directory = await getDocumentsDirectory();
    var endDir = await Directory('${directory.path}/${subDir}').create(recursive: false);

    // execute an action on each entry
    endDir.list(recursive: true).forEach((entity) {
      if (entity is File &&
        entity.path.endsWith('.zwo')) {

        debugPrint('File ' + entity.path);

        String fileContent = entity.readAsStringSync();

        if (0 == _addStringWorkout(fileContent)) {
          notifyListeners();
        }
      }
    });
  }

  Future<void> startDB(String subDir) async {

    if (isDesktopPlatform()) {
      return startDBDesktop(subDir);
    } else {
      return startDBWeb(subDir);
    }
  }
}