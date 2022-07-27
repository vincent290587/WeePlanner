
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'ConnectorGetter.dart';

List<IcuWorkout> pseudoDB = [];

class AppDirectory {
  final String path;
  AppDirectory(this.path);
}

bool isDesktopPlatform() {
  return !kIsWeb;
}

Future<AppDirectory> getDocumentsDirectory() async {

  if (!isDesktopPlatform()){

    return AppDirectory('');

  } else {

    final directory = await getApplicationDocumentsDirectory();
    String endDir = '${directory.path}';

    return AppDirectory(endDir);
  }

}

void savePseudoFile(IcuWorkout wko, String body) {

  int index = body.indexOf('<workout_file>');
  String wkoBody = body.substring(index);

  wko.setBody(wkoBody);

  pseudoDB.add(wko);
}

void emptyPrint(Object o) {

}
