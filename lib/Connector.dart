import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const String auth_key = 'test_auth_key';

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


Future<http.Response> postAlbum(Album album) async {

  return http.post(
    Uri.parse('https://intervals.icu/api/v1/athlete/i30899/calendars'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: album.toJson(),
  );

  // if (response.statusCode == 201) {
  //   // If the server did return a 201 CREATED response,
  //   // then parse the JSON.
  //   return Album.fromJson(jsonDecode(response.body));
  // } else {
  //   // If the server did not return a 201 CREATED response,
  //   // then throw an exception.
  //   throw Exception('Failed to create album.');
  // }
}


Future<Album> fetchAlbum() async {

  final response = await http.post(
    Uri.parse('https://intervals.icu/api/v1/athlete/i30899/calendars'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic ${auth_key}',
    },
  );
  final responseJson = jsonDecode(response.body);

  return Album.fromJson(responseJson);
}

// {
//   "category": "WORKOUT",
//   "start_date_local": "2021-04-29T00:00:00",
//   "type": "Ride",
//   "filename": "4x8m.zwo",
//   "file_contents": "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<workout_file>..."
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

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
    };
  }
}