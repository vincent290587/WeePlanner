

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import 'Workout.dart';
import 'ZwoConverter.dart';
import 'nanopb/Workout.pb.dart';

class WorkoutDB extends ChangeNotifier {

  List<Workout> workoutDB = [];

  WorkoutDB();

  Future<void> startDB() async {

    workoutDB.clear();

    Directory dir = Directory('db');
    //print('Listing ' + dir.path);
    // execute an action on each entry
    dir.list(recursive: true).forEach((entity) {
      if (entity is File &&
        entity.path.endsWith('.zwo')) {

        debugPrint('File ' + entity.path);

        XmlDocument document = XmlDocument.parse((entity as File).readAsStringSync());

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

            workoutDB.add(Workout(rawWorkout));
          }
        }
      }
    });
  }
}