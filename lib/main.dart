import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Workout.dart';
import 'WorkoutDB.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutDB(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // do not display the debug banner
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Workout planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _score = 400;
  int _amount = 5;

  Widget getCard(Widget? icon, String text, String value) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: icon,
            title: Text(text, style: TextStyle(fontSize: 30)),
          ),
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(value, style: TextStyle(fontSize: 25))
                ),
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var widgets = <Widget>[];
    List<Workout> workouts = Provider.of<WorkoutDB>(context, listen: false).ComputeWeek(_score, _amount);

    List<Widget> cards = workouts.map((item) {

      // return Card(
      //   child: ListTile(
      //     key: ObjectKey(item.rawWorkout.name),
      //     leading: Text(item.rawWorkout.name),
      //     title: Text('Dur.: ${item.duration}'),
      //     subtitle: Text('IF:  ${item.IF}'),
      //   ),
      // );

      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: null,
              isThreeLine: false,
              title: Text(item.rawWorkout.name, style: TextStyle(fontSize: 20)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dur.: ${item.duration/60} min', style: TextStyle(fontSize: 12)),
                  Text('IF:  ${item.IF}'),
                  Text('TSS:  ${item.TSS}'),
                ],
              ),
            ),
            // Expanded(
            //     child: Container(
            //       padding: const EdgeInsets.all(20.0),
            //       child: FittedBox(
            //           fit: BoxFit.fitWidth,
            //           child: Text('Filler')
            //       ),
            //     )
            // ),
          ],
        ),
      );

    }).toList();

    widgets.add(
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(5.0),
            crossAxisSpacing: 1.0,
            crossAxisCount: 7,
            children: cards,
          ),
        )
    );

    widgets.add(Text('-- Summary --', style: TextStyle(fontSize: 20)));

    num sum = 0;
    workouts.forEach((var w){sum += w.TSS;});
    widgets.add(Text('Total TSS: ${sum}', style: TextStyle(fontSize: 20)));

    sum = 0;
    workouts.forEach((var w){sum += w.duration;});
    sum /= 3600;
    widgets.add(Text('Total time: ${sum.toStringAsFixed(1)} hours', style: TextStyle(fontSize: 20)));

    var plannedWeek = Column(
      children: widgets,
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
      Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              // width: 600.0,
              // height: 800.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' '),
                  //Text('Target TSS:'),
                  TextFormField(
                    initialValue: _score.toString(),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'TSS',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _score = int.parse(text);
                      });
                    },
                  ),
                  Text(' '),
                  //Text('# days:'),
                  TextFormField(
                    initialValue: _amount.toString(),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'TSS',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _amount = int.parse(text);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(),
          Flexible(
            flex: 5,
            child: Container(
              // width: 600.0,
              // height: 800.0,
              child: plannedWeek,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<WorkoutDB>(context, listen: false).startDB();
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
