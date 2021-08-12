import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String auth_key = 'test_auth_key';
import 'Workout.dart';
import 'WorkoutDB.dart';

const String athleteID = 'i30899';

// GET /api/v1/athlete/{id}/folders List all folders and workouts
// POST /api/v1/athlete/{id}/folders Create a folder
// PUT /api/v1/athlete/{id}/folders/{folderId} Update folder
// DELETE /api/v1/athlete/{id}/folders/{folderId} Delete folder
// GET /api/v1/athlete/{id}/folders/{folderId}/shared-with Show who folder has been shared with
// PUT /api/v1/athlete/{id}/folders/{folderId}/shared-with Update folder sharing
// GET /api/v1/athlete/{id}/workouts List all workouts (excluding those shared by others)
// GET /api/v1/athlete/{id}/workouts/{workoutId} Get a workout
// POST /api/v1/athlete/{id}/workouts Create a workout
// PUT /api/v1/athlete/{id}/workouts/{workoutId} Update a workout
// DELETE /api/v1/athlete/{id}/workouts/{workoutId} Delete a workout
// POST /api/v1/download-workout{ext} Download a workout in .zwo .mrc or .erg format


// {
//   "category": "WORKOUT",
//   "start_date_local": "2021-08-15T00:00:00",
//   "type": "Ride",
//   "filename": "4x8m.zwo",
//   "file_contents": "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><workout_file><author></author><name>test</name><description></description><sportType>bike</sportType><tags></tags><workout><Warmup Duration=\"600\" PowerLow=\"0.25\" PowerHigh=\"0.75\"/><Ramp Duration=\"600\" PowerLow=\"0.75\" PowerHigh=\"0.25\"/><FreeRide Duration=\"600\" FlatRoad=\"1\"/></workout></workout_file>"
// }

// reponse:

// {
//   "id": 610062,
//   "icu_training_load": 116,
//   ...
//   "name": "4x8m VO2 Max",
//   "description": "These are horribly nasty.\nCategory: Horrible\n\n- 20m 60% 90-100rpm\n\nMain set 4x\n- 8m 110%\n- 8m 50%\n\n- 10m 60%\n",
//   ...
//   "workout_doc": {
//     "steps": [
//       {
//         "power": {"units": "%ftp", "value": 60},
//         "cadence": {"end": 100, "start": 90, "units": "rpm"}, "duration": 1200
//       }, ...
//     ],
//     "duration": 5640,
//     "zoneTimes": [1920, 1800, 0, 0, 1920, 0, 0, 0],
//     "hrZoneTimes": [1920, 1800, 0, 0, 1920, 0, 0, 0]
//   },
//   "icu_intensity": 86.04798
// }

Map<String, String> workoutToIcuJson(Workout workout, String date) {

  String content = '';
  if (!workout.rawContent.startsWith('<?xml')) {
    content = '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n';
  }
  content += workout.rawContent;

  return {
    'category': 'WORKOUT',
    'start_date_local': date,
    'type': 'Ride',
    'filename': workout.rawWorkout.name + '.zwo',
    'file_contents': content,
  };
}

Future<void> postSingleCalendar(Workout workout, String date) async {

  final response = await http.post(
    Uri.parse('https://intervals.icu/api/v1/athlete/${athleteID}/events'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
    body: json.encode(workoutToIcuJson(workout, date)),
  );

  debugPrint('Response code: ${response.statusCode}');
  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to create calendar entry.');
    print(workoutToIcuJson(workout, date).toString());
  }
}

Future<void> postWeekCalendar(BuildContext context, PlannedWeek week) async {

  Future<DateTime?> selectedDate = showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2018),
    lastDate: DateTime(2030),
  );

  DateTime? time = await selectedDate;

  if (time == null) return;

  for (var workout in week.workouts) {
    String date = time!.toIso8601String();
    print('Date upload: ${date}');
    //print(workoutToIcuJson(workout, date).toString());
    await postSingleCalendar(workout, date); //
    time = time.add(Duration(days: 1));
  }
}