
import 'dart:async';
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:flutter/cupertino.dart';

import 'package:wee_planner/utils.dart';
import 'package:wee_planner/Workout.dart';
import 'package:wee_planner/WorkoutDB.dart';

class PlannerSettings {

  int targetScore;
  int workoutsNb;
  late Distribution distribution;

  PlannerSettings(DistributionType type, {required this.targetScore, required this.workoutsNb}) {

    setDistribution(type);
  }

  void setDistribution(DistributionType type) {

    switch (type) {
      case DistributionType.Rest:
        distribution = Distribution.rest();
        break;
      case DistributionType.Phase1:
        distribution = Distribution.phase1();
        break;
      case DistributionType.Phase2:
        distribution = Distribution.phase2();
        break;
      case DistributionType.Phase3a:
        distribution = Distribution.phase3a();
        break;
      case DistributionType.Phase3b:
        distribution = Distribution.phase3b();
        break;
      case DistributionType.Polarized:
        distribution = Distribution.polarized();
        break;
    }
  }

}

class PlannerInput {
  final List<Workout> wDB;
  final PlannerSettings settings;

  PlannerInput(this.wDB, this.settings);
}

Future<List<PlannedWeek>> plan(PlannerInput input) async {

  List<Workout> wDB = input.wDB;
  PlannerSettings settings = input.settings;

  // Create first generation, either by random or by continuing with existing
  // progress.
  var firstGeneration = Generation<MyPhenotype, Workout, SingleObjectiveResult>()
    ..members.addAll(List.generate(500, (_) => MyPhenotype.Random(wDB: wDB, settings: settings)));

  // Evaluators take each phenotype and assign a fitness value to it according
  // to some fitness function.
  var evaluator = MyEvaluator();

  // Breeders are in charge of creating new generations from previous ones (that
  // have been graded by the evaluator). Their only required argument is
  // a function that returns a blank phenotype.
  var breeder = GenerationBreeder<MyPhenotype, Workout, SingleObjectiveResult>(
          () => MyPhenotype(wDB: wDB, settings: settings))
    ..crossoverProbability = 0.8;

  var algo = GeneticAlgorithm<MyPhenotype, Workout, SingleObjectiveResult>(
    firstGeneration,
    evaluator,
    breeder,
    printf: emptyPrint,
  );

  algo.thresholdResult = SingleObjectiveResult()
    ..value = 0.05;

  // Start the algorithm.
  await algo.runUntilDone();

  // Print all members of the last generation when done.
  algo.generations.last.members.forEach((Phenotype ph) {
    debugPrint('Score: ${ph.result!.evaluate()}');
    //debugPrint('${ph.genesAsString}');
  });

  var phenotypes = algo.generations.last.members;
  phenotypes.sort((Phenotype p1, Phenotype p2) => p1.result!.evaluate()!.compareTo(p2.result!.evaluate()!));

  debugPrint('Best score: ${phenotypes.first.result!.evaluate()}');

  List<PlannedWeek> output = [];

  int lastTSS = 0;
  while (phenotypes.isNotEmpty && output.length <= 5) {
    var week = PlannedWeek.full(phenotypes.first.genes, phenotypes.first.result!.evaluate()!);
    if (week.sumTSS != lastTSS) { // avoid clones
      output.add(week);
    }
    phenotypes.removeAt(0);
    lastTSS = week.sumTSS;
  }

  return output;
}

Random random = Random();

class MyEvaluator
    extends PhenotypeEvaluator<MyPhenotype, Workout, SingleObjectiveResult> {

  @override
  Future<SingleObjectiveResult> evaluate(MyPhenotype phenotype) {

    final result = SingleObjectiveResult();

    double sum = 0;
    phenotype.genes.forEach((Workout v){
      sum += v.TSS;
    });
    double tssDistance = pow(1 - sum / phenotype.settings.targetScore.toDouble(), 2) as double;
    //tssDistance = 0.0;

    // give penalty to workouts present several times in a week
    int max_count = 0;
    var map = Map();
    phenotype.genes.forEach((element) {
      String name = element.rawWorkout.name;
      if(!map.containsKey(name)) {
        map[name] = 1;
      } else {
        map[name] +=1;
        max_count += 1;
      }
    });
    tssDistance += 100 * max_count; // penalty for non-unique lists

    double totDuration = 0.0;
    Distribution distribution = Distribution.empty();
    for (var workout in phenotype.genes) {
      distribution.cumulate(workout.distribution);
      totDuration += workout.duration;
    }
    double affinity = phenotype.settings.distribution.affinity(distribution) * 100.0 / totDuration;
    double maxAffinity = phenotype.settings.distribution.maxAffinity();
    tssDistance += 40000 * pow(1 - affinity / maxAffinity, 2) as double;

    result.value = pow(tssDistance, 0.5) as double;

    return Future.value(result);
  }
}

class MyPhenotype extends Phenotype<Workout, SingleObjectiveResult> {

  final PlannerSettings settings;
  final List<Workout> wDB;

  MyPhenotype({required this.wDB, required this.settings});

  MyPhenotype.Random({required this.wDB, required this.settings}) {
    genes = [];
    for (int i=0; i< settings.workoutsNb; i++) {
      genes.add(wDB[random.nextInt(wDB.length-1)]);
    }
  }

  @override
  Workout mutateGene(Workout gene, num strength) {
    // TODO strength
    return wDB[random.nextInt(wDB.length-1)];
  }
}
