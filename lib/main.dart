import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Connector.dart';
import 'Planner.dart';
import 'Workout.dart';
import 'WorkoutDB.dart';
import 'WorkoutGraph.dart';
import 'ZonesGraph.dart';

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

  DistributionType distributionType = DistributionType.Phase1;

  PlannerSettings settings = PlannerSettings(DistributionType.Rest, workoutsNb: 5, targetScore: 400);

  PlannedWeek week = PlannedWeek.empty();

  StreamController<Workout> potentialWorkout = new StreamController<Workout>.broadcast();

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

  Widget buildWeek(BuildContext context, PlannedWeek week) {

    List<Widget> cards = week.workouts.map((item) {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: null,
              dense:false,
              isThreeLine: false,
              title: AutoSizeText(item.rawWorkout.name,
                  maxLines: 2,
                  style: TextStyle(fontSize: 15)
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dur.: ${(item.duration / 60).toInt()} min',
                      style: TextStyle(fontSize: 12)),
                  Text('IF:  ${item.IF}'),
                  Text('TSS:  ${item.TSS}'),
                ],
              ),
              onTap: () {
                potentialWorkout.add(item);
              },
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
    }).toList()
      ..add(Card(
        color: Colors.grey.shade200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: null,
              isThreeLine: false,
              //title: Text(item.rawWorkout.name, style: TextStyle(fontSize: 20)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dur.: ${(week.sumDuration / 3600).toStringAsFixed(1)} hrs',
                      style: TextStyle(fontSize: 12)),
                  Text('TSS :  ${week.sumTSS.toStringAsFixed(1)}'),
                  // Text('Z6 :  ${(week.distribution.bins[5]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                  // Text('Z5 :  ${(week.distribution.bins[4]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                  // Text('Z4 :  ${(week.distribution.bins[3]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                  // Text('Z3 :  ${(week.distribution.bins[2]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                  // Text('Z2 :  ${(week.distribution.bins[1]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                  // Text('Z1 :  ${(week.distribution.bins[0]*100).toInt()}%',
                  //     style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
            Expanded(
              child: getGraph(week.distribution),
            ),
          ],
        ),
      ));

    return Expanded(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(5.0),
        crossAxisSpacing: 1.0,
        crossAxisCount: 7,
        children: cards,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    List<Workout> workouts = Provider.of<WorkoutDB>(context, listen: false).showWeek(settings);

    // /widgets.add( buildWeek(context, workouts) );

    // widgets.add(Text('-- Summary --', style: TextStyle(fontSize: 20)));
    //
    // num sum = 0;
    // workouts.forEach((var w){sum += w.TSS;});
    // widgets.add(Text('Total TSS: ${sum}', style: TextStyle(fontSize: 20)));
    //
    // sum = 0;
    // workouts.forEach((var w){sum += w.duration;});
    // sum /= 3600;
    // widgets.add(Text('Total time: ${sum.toStringAsFixed(1)} hours', style: TextStyle(fontSize: 20)));

    // var plannedWeeks = StreamBuilder<List<Workout>>(
    //     stream: Provider.of<WorkoutDB>(context, listen: false).getComputation,
    //     initialData: workouts,
    //     builder: (c, snapshot) {
    //       if (snapshot.data != null) {
    //         var widgets = [buildWeek(context, workouts)];
    //         return Column(
    //           children: widgets,
    //         );
    //       }
    //       return Column(
    //         children: [
    //           Text('Sample text'),
    //         ],
    //       );
    // });

    // var plannedWeeks = Column(
    //   children: widgets,
    // );

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
              margin: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    child: getGraph(settings.distribution),
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Rest'),
                    value: DistributionType.Rest,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) { setState(() {
                      distributionType = DistributionType.Rest;
                      settings.setDistribution(value!); });
                    },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase1'),
                    value: DistributionType.Phase1,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase1;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase2'),
                    value: DistributionType.Phase2,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase2;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase3a'),
                    value: DistributionType.Phase3a,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase3a;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase3b'),
                    value: DistributionType.Phase3b,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase3b;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  Text(' '),
                  //Text('Target TSS:'),
                  TextFormField(
                    initialValue: settings.targetScore.toString(),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'TSS',
                    ),
                    onChanged: (text) {
                      setState(() {
                        settings.targetScore = int.parse(text);
                      });
                    },
                  ),
                  Text(' '),
                  //Text('# days:'),
                  TextFormField(
                    initialValue: settings.workoutsNb.toString(),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nb',
                    ),
                    onChanged: (text) {
                      setState(() {
                        settings.workoutsNb = int.parse(text);
                      });
                    },
                  ),
                  Text(' '),
                  Center(
                    child: OutlinedButton(
                      child: Text('Compute'),
                      onPressed: () {
                        Provider.of<WorkoutDB>(context, listen: false).computeWeek(settings);
                      },
                    ),
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
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: StreamBuilder<PlannedWeek>(
                      stream: Provider.of<WorkoutDB>(context, listen: false).getComputation,
                      //initialData: workouts,
                      builder: (c, snapshot) {
                        if (snapshot.hasData) {
                          week = snapshot.data!;
                          PlannedWeek week2 = snapshot.data!;
                          return Column(
                            children: [buildWeek(context, week2)],
                          );
                        }
                        return Column(
                          children: [
                            Text('Empty, please load DB and start a computation'),
                          ],
                        );
                      }
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: StreamBuilder<Workout>(
                      stream: potentialWorkout.stream,
                      //initialData: workouts,
                      builder: (c, snapshot) {
                        if (snapshot.hasData) {
                          Workout workout = snapshot.data!;
                          return getWorkoutGraph(workout);
                        }
                        return Placeholder();
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              postWeekCalendar(context, week);
            },
            tooltip: 'Increment',
            child: Icon(Icons.calendar_today),
          ),
          SizedBox(height: 8,),
          FloatingActionButton(
            onPressed: () {
              Provider.of<WorkoutDB>(context, listen: false).startDB(Directory('db'));
            },
            tooltip: 'Increment',
            child: Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
