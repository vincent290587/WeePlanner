
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:darwin/darwin.dart';
import 'package:flutter/cupertino.dart';

import 'Workout.dart';

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
    }
  }

}

Future<List<Workout>> plan(List<Workout> wDB, PlannerSettings settings) async {

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
  );

  algo.thresholdResult = SingleObjectiveResult()
    ..value = 0.05;

  // Start the algorithm.
  await algo.runUntilDone();

  // Print all members of the last generation when done.
  algo.generations.last.members
      .forEach((Phenotype ph) {

    debugPrint('Score: ${ph.result!.evaluate()}');
    debugPrint('${ph.genesAsString}');
  });

  var phenotypes = algo.generations.last.members;
  phenotypes.sort((Phenotype p1, Phenotype p2) => p1.result!.evaluate()!.compareTo(p2.result!.evaluate()!));

  debugPrint('Best score: ${phenotypes.first.result!.evaluate()}');

  return phenotypes.first.genes;
}

Random random = Random();

class MyEvaluator
    extends PhenotypeEvaluator<MyPhenotype, Workout, SingleObjectiveResult> {

  @override
  Future<SingleObjectiveResult> evaluate(MyPhenotype phenotype) {

    final result = SingleObjectiveResult();

    double sum = 0;
    phenotype.genes.forEach((Workout v){sum += v.TSS;});
    double tssDistance = pow(1 - sum / phenotype.settings.targetScore.toDouble(), 2) as double;
    //tssDistance = 0.0;

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
