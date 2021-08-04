
import 'dart:async';
import 'dart:math';

import 'package:darwin/darwin.dart';

import 'Workout.dart';

class PlannerSettings {

  int targetScore;
  int workoutsNb;

  PlannerSettings({required this.targetScore, required this.workoutsNb});

}

Future<List<Workout>> plan(List<Workout> wDB, PlannerSettings settings) async {

  // Create first generation, either by random or by continuing with existing
  // progress.
  var firstGeneration = Generation<MyPhenotype, Workout, SingleObjectiveResult>()
    ..members.addAll(List.generate(50, (_) => MyPhenotype.Random(wDB: wDB, settings: settings)));

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
    ..value = 0.025;

  // Start the algorithm.
  await algo.runUntilDone();

  // Print all members of the last generation when done.
  algo.generations.last.members
      .forEach((Phenotype ph) {

    print('Score: ${ph.result!.evaluate()}');
    print('${ph.genesAsString}');
  });

  var phenotypes = algo.generations.last.members;
  phenotypes.sort((Phenotype p1, Phenotype p2) => p1.result!.evaluate()!.compareTo(p2.result!.evaluate()!));

  print('Best score: ${phenotypes.first.result!.evaluate()}');

  return phenotypes.first.genes;
}

Random random = Random();

class MyEvaluator
    extends PhenotypeEvaluator<MyPhenotype, Workout, SingleObjectiveResult> {

  @override
  Future<SingleObjectiveResult> evaluate(MyPhenotype phenotype) {

    final result = SingleObjectiveResult();

    // TODO workout content
    double sum = 0;
    phenotype.genes.forEach((Workout v){sum += v.TSS;});
    double tssDistance = pow((phenotype.settings.targetScore.toDouble() - sum) / phenotype.settings.targetScore.toDouble(), 2) as double;

    result.value = tssDistance;

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
