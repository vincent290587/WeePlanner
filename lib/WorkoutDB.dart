

import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'Workout.dart';

class WorkoutDB extends ChangeNotifier {

  List<Workout> workoutDB = [];

  WorkoutDB();

  Future<void> startDB() async {

    Directory dir = Directory('db');
    print('Listing ' + dir.path);
    // execute an action on each entry
    dir.list(recursive: true).forEach((entity) {
      if (entity is File) {

        print(entity);
      }
    });
  }
}