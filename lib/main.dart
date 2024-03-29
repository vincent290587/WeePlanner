import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'Connector.dart';
import 'ConnectorGetter.dart';
import 'Planner.dart';
import 'PolarizedGraph.dart';
import 'Workout.dart';
import 'WorkoutDB.dart';
import 'WorkoutGraph.dart';
import 'ZonesGraph.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
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
      title: 'WeePlanner',
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

  PlannerSettings settings = PlannerSettings(DistributionType.Phase1, workoutsNb: 5, targetScore: 400);

  PlannedWeek week = PlannedWeek.empty();

  int nbWorkout = 0;
  bool isComputing = false;

  StreamController<Workout> potentialWorkout = new StreamController<Workout>.broadcast();

  StreamController<PlannedWeek> potentialWeek = new StreamController<PlannedWeek>.broadcast();
  Stream<PlannedWeek> get getpotentialWeek => (potentialWeek.stream);

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

    ThreeZonesDistribution threeZones = ThreeZonesDistribution(week.distribution);

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
    }).toList();

    // return GridView.count(
    //     childAspectRatio: 1.1,
    //     primary: false,
    //     padding: const EdgeInsets.all(5.0),
    //     crossAxisSpacing: 1.0,
    //     crossAxisCount: 7,
    //     children: cards,
    // );

    return GridView.builder(
      // physics: NeverScrollableScrollPhysics(),
      physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        // return Container(
        //   color: Colors.blue,
        //   child: Text("index: $index"),
        // );
        return cards[index];
      },
    );

  }

  Widget buildComputationSummary(BuildContext context, List<PlannedWeek> weeks) {

    List<Widget> cards = weeks.map((item) {
      return OutlinedButton(
        child: AutoSizeText('Sol. ${weeks.indexOf(item)}',
            maxLines: 2,
            style: TextStyle(fontSize: 10)
        ),
        onPressed: () {
          potentialWeek.add(item);
        },
      );
    }).toList();

    return Wrap(
      spacing: 16.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: cards,
    );
  }

  Widget buildWeekSummary(BuildContext context, PlannedWeek week) {

    ThreeZonesDistribution threeZones = ThreeZonesDistribution(week.distribution);

    List<Widget> cards = []
      ..add(
          Card(
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
                      Text('TSS :  ${week.sumTSS}'),
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
          )
      )..add(
          Card(
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
                      Text('Z1+2: ${threeZones.bins[0].toInt()} %',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('Z3+4 : ${threeZones.bins[1].toInt()} %',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('Z5+  : ${threeZones.bins[2].toInt()} %',
                        style: TextStyle(fontSize: 12),
                      ),
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
                  child: getThreeZoneGraph(week.distribution),
                ),
              ],
            ),
          )
      );

    return GridView.count(
      childAspectRatio: 1.1,
      primary: false,
      padding: const EdgeInsets.all(5.0),
      crossAxisSpacing: 1.0,
      crossAxisCount: 1,
      children: cards,
    );

  }

  @override
  Widget build(BuildContext context) {

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
                  // RadioListTile<DistributionType>(
                  //   title: const Text('Rest'),
                  //   dense: true,
                  //   value: DistributionType.Rest,
                  //   groupValue: distributionType,
                  //   onChanged: (DistributionType? value) { setState(() {
                  //     distributionType = DistributionType.Rest;
                  //     settings.setDistribution(value!); });
                  //   },
                  // ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase1'),
                    dense: true,
                    value: DistributionType.Phase1,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase1;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase2'),
                    dense: true,
                    value: DistributionType.Phase2,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase2;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase3a'),
                    dense: true,
                    value: DistributionType.Phase3a,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase3a;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Phase3b'),
                    dense: true,
                    value: DistributionType.Phase3b,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Phase3b;
                      setState(() { settings.setDistribution(value!); });
                      },
                  ),
                  RadioListTile<DistributionType>(
                    title: const Text('Polarized'),
                    dense: true,
                    value: DistributionType.Polarized,
                    groupValue: distributionType,
                    onChanged: (DistributionType? value) {
                      distributionType = DistributionType.Polarized;
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
                      onPressed: () async {
                        setState(() {
                          isComputing = true;
                        });
                        Provider.of<WorkoutDB>(context, listen: false).computeWeek(settings).then((value) {
                          setState(() {
                            isComputing = false;
                          });
                        });
                      },
                    ),
                  ),
                  if (isComputing) ...[
                    Text(' '),
                    Center(
                      child: const CircularProgressIndicator(),
                    ),
                  ]
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
                  Expanded(
                    flex: 2,
                    child: StreamBuilder<PlannedWeek>(
                      stream: getpotentialWeek,
                      //initialData: workouts,
                      builder: (c, snapshot) {
                        if (snapshot.hasData) {
                          week = snapshot.data!;
                          PlannedWeek week2 = snapshot.data!;
                          return buildWeek(context, week2);
                        }
                        String text = 'Empty, please load DB and start a computation';
                        nbWorkout = Provider.of<WorkoutDB>(context, listen: true).workoutDB.length;
                        if (nbWorkout > 0) {
                          text = 'DB loaded: ${nbWorkout} workouts';
                        }
                        return Text(text);
                      }
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // width: 600.0,
                    height: 100.0,
                    child: StreamBuilder<List<PlannedWeek>>(
                        stream: Provider.of<WorkoutDB>(context, listen: false).getComputation,
                        //initialData: workouts,
                        builder: (c, snapshot) {
                          if (snapshot.hasData) {
                            potentialWeek.add(snapshot.data!.first);
                            return buildComputationSummary(context, snapshot.data!);
                          }
                          return Text('');
                        }
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<PlannedWeek>(
                    stream: potentialWeek.stream,
                    //initialData: workouts,
                    builder: (c, snapshot) {
                      if (snapshot.hasData) {
                        week = snapshot.data!;
                        potentialWorkout.add(week.workouts.first);
                        return buildWeekSummary(context, snapshot.data!);
                      }
                      return Text('');
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              getDailyEvent();
              getWorkoutList().then((value) async {
                await Provider.of<WorkoutDB>(context, listen: false).startDB('WeeGetter');
                Provider.of<WorkoutDB>(context, listen: false).prepareSummary();
                int tmpNb = Provider.of<WorkoutDB>(context, listen: false).workoutDB.length;
                setState(() { nbWorkout = tmpNb; });
              });
            },
            tooltip: 'Download all ICU workouts',
            child: Icon(Icons.arrow_circle_down),
          ),
          SizedBox(height: 8,),
          if (isDesktopPlatform()) ...[
            FloatingActionButton(
              onPressed: () {
                postWeekCalendar(context, week);
              },
              tooltip: 'Schedule in intervals.icu',
              child: Icon(Icons.calendar_today),
            ),
            SizedBox(height: 8,),
            FloatingActionButton(
              onPressed: () {
                Provider.of<WorkoutDB>(context, listen: false).startDB('WeePlanner');
              },
              tooltip: 'Load workout DB',
              child: Icon(Icons.refresh),
            ),
          ],
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
