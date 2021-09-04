import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'keys.dart';

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

Future<void> getDailyEvent() async {

  DateTime currentTime = DateTime.now();
  String strTime = currentTime.toString().substring(0, 10);
  String strTime1 = currentTime.subtract(Duration(days:1)).toString().substring(0, 10);
  String strTime2 = currentTime.add(Duration(days:1)).toString().substring(0, 10);

  Map<String, String> qParams = {
    'oldest': '${strTime1}',
    'newest': '${strTime2}',
  };
  Uri uri = Uri.parse('https://intervals.icu/api/v1/athlete/${athleteID}/events');
  uri = uri.replace(queryParameters: qParams); //USE THIS

  debugPrint('Date: ${strTime}');
  final response = await http.get(
    uri,
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
  );

  debugPrint('Response code: ${response.statusCode}');
  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to get calendar events');
    //print(workoutToIcuJson(workout, date).toString());
  } else {
    debugPrint('Response: ${response.contentLength}');
    debugPrint('Body: ${response.body}');

    List<dynamic> listJsons = jsonDecode(response.body);

    for (var item in listJsons) {

      IntervalsCalendar event = IntervalsCalendar.fromJson(item);
      //debugPrint('Body: ${album.toString()}');
      if (event.startDate.contains(strTime) &&
          event.category == 'WORKOUT') {

        debugPrint('Match -- ${event.toString()}');

        getEvent(event);
      }
    }
  }
}

Future<void> saveFile(IcuWorkout wko, String subFolder, String body) async {

  int index = body.indexOf('<workout_file>');
  String wkoBody = body.substring(index);

  // FilePickerCross myFile  = FilePickerCross(Uint8List.fromList(wko.codeUnits),
  //     path: '',
  //     type: FileTypeCross.custom,
  //     fileExtension: 'zwo');

  // for sharing to other apps you can also specify optional `text` and `subject`
  // await myFile.exportToStorage();

  final directory = await getApplicationDocumentsDirectory();
  var endDir = await Directory('${directory.path}/WeeGetter/${subFolder}').create(recursive: false);

  String fname = wko.name.
    replaceAll(' - ', '__').
    replaceAll(' ', '_').
    replaceAll('/', '-').
    replaceAll('\'', '').
    replaceAll('?', '').
    replaceAll(':', '');
  fname += '.zwo';
  File myFile = File('${endDir.path}/${fname}');
  myFile.writeAsBytesSync(Uint8List.fromList(wkoBody.codeUnits));
}

Future<void> getEvent(IntervalsCalendar event) async {

  debugPrint('Getting eventID: ${event.eventId}');
  Uri uri = Uri.parse('https://intervals.icu/api/v1/athlete/${athleteID}/events/${event.eventId}/download.zwo');

  final response = await http.get(
    uri,
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
  );

  debugPrint('Response code: ${response.statusCode}');
  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to get event');
    //print(workoutToIcuJson(workout, date).toString());
  } else {
    //debugPrint('Response: ${response.contentLength}');
    //debugPrint('Body: ${response.body}');

    IcuWorkout wko = IcuWorkout(
      name: event.name,
      workoutId: event.eventId,
    );
    await saveFile(wko, 'Daily', response.body);
  }
}

class IntervalsCalendar {
  final int eventId;
  final String name;
  final String startDate;
  final String category;

  IntervalsCalendar({
    required this.eventId,
    required this.name,
    required this.startDate,
    required this.category,
  });

  String toString() {
    String ret = 'WKO name: ${name} date: ${startDate}';
    return ret;
  }

  factory IntervalsCalendar.fromJson(Map<String, dynamic> json) {
    return IntervalsCalendar(
      eventId: json['id'],
      name: json['name'],
      startDate: json['start_date_local'],
      category : json['category'],
    );
  }
}

// GET /api/v1/athlete/{id}/workouts List all workouts (excluding those shared by others)
// GET /api/v1/athlete/{id}/workouts/{workoutId} Get a workout
// POST /api/v1/download-workout{ext}

Future<void> getWorkoutZwo(IcuWorkout event, dynamic payload) async {

  debugPrint('Found WKO: ${event.toString()}');

  Uri uri = Uri.parse('https://intervals.icu/api/v1/download-workout.zwo');

  final response = await http.post(
    uri,
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to get workout');
    //print(workoutToIcuJson(workout, date).toString());
  } else {
    //debugPrint('Response: ${response.contentLength}');
    //debugPrint('Body: ${response.body}');

    saveFile(event, 'all', response.body);
  }
}

Future<void> getWorkoutList() async {

  Uri uri = Uri.parse('https://intervals.icu/api/v1/athlete/${athleteID}/workouts');

  final response = await http.get(
    uri,
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
  );

  debugPrint('Response code: ${response.statusCode}');
  if (response.statusCode != 200) {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to get workout list');
    //print(workoutToIcuJson(workout, date).toString());
  } else {
    //debugPrint('Response: ${response.contentLength}');
    //debugPrint('Body: ${response.body}');

    List<dynamic> listJsons = jsonDecode(response.body);

    for (var item in listJsons) {

      IcuWorkout event = IcuWorkout.fromJson(item);
      getWorkoutZwo(event, item);
    }
  }
}


class IcuWorkout {
  final int workoutId;
  final String name;

  IcuWorkout({
    required this.workoutId,
    required this.name,
  });

  String toString() {
    String ret = 'WKO name: ${name} ID: ${workoutId}';
    return ret;
  }

  factory IcuWorkout.fromJson(Map<String, dynamic> json) {
    return IcuWorkout(
      workoutId: json['id'],
      name: json['name'],
    );
  }

}
