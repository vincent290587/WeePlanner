

import 'package:xml/xml.dart';

import 'nanopb/Workout.pb.dart';

Repetition convertZwo(XmlElement elmnt) {

  //debugPrint('Interval name ' + elmnt.name.toString());
  String name = elmnt.name.local;

  if (name == 'IntervalsT') {

    XmlAttribute? nbReps = elmnt.getAttributeNode('Repeat');
    XmlAttribute? onDuration = elmnt.getAttributeNode('OnDuration');
    XmlAttribute? offDuration = elmnt.getAttributeNode('OffDuration');
    XmlAttribute? onPower = elmnt.getAttributeNode('OnPower');
    XmlAttribute? offPower = elmnt.getAttributeNode('OffPower');
    XmlAttribute? cadence_ = elmnt.getAttributeNode('Cadence');
    XmlAttribute? cadenceResting = elmnt.getAttributeNode('CadenceResting');

    List<RawInterval> intervals = [];

    int reps = int.parse(nbReps!.value);

    int? durOn;
    int? durOff;
    double? powerOn;
    double? powerOff;
    int? cadenceOn;
    int? cadenceOff;

    if (onDuration != null) {
      durOn = double.parse(onDuration.value).round();
    }
    if (offDuration != null) {
      durOff = double.parse(offDuration.value).round();
    }
    if (onPower != null) {
      powerOn = double.parse(onPower.value);
    }
    if (offPower != null) {
      powerOff = double.parse(offPower.value);
    }
    if (cadence_ != null) {
      cadenceOn = int.parse(cadence_.value);
    }
    if (cadenceResting != null) {
      cadenceOff = int.parse(cadenceResting.value);
    }

    for (int i=0; i < reps; i++) {
      intervals.add(RawInterval(duration: durOn, powerStart: powerOn, powerEnd: powerOn, cadence: cadenceOn));
      intervals.add(RawInterval(duration: durOff, powerStart: powerOff, powerEnd: powerOff, cadence: cadenceOff));
    }

    Repetition rep = new Repetition(intervals: intervals);
    return rep;

  } else if (name == 'Warmup' ||
      name == 'Cooldown' ||
      name == 'Ramp'
  ) {

    XmlAttribute? duration = elmnt.getAttributeNode('Duration');
    XmlAttribute? powerLow = elmnt.getAttributeNode('PowerLow');
    XmlAttribute? powerHigh = elmnt.getAttributeNode('PowerHigh');

    int? durOn;
    double? powerStart;
    double? powerEnd;

    if (duration != null) {
      durOn = double.parse(duration.value).round();
    }
    if (powerLow != null) {
      powerStart = double.parse(powerLow.value);
    }
    if (powerHigh != null) {
      powerEnd = double.parse(powerHigh.value);
    }

    Repetition rep = new Repetition(intervals: [
      RawInterval(duration: durOn,
          powerStart: powerStart,
          powerEnd: powerEnd)
    ]);
    return rep;

  } else {

    XmlAttribute? duration = elmnt.getAttributeNode('Duration');
    XmlAttribute? powerLow = elmnt.getAttributeNode('Power');
    XmlAttribute? cadence_ = elmnt.getAttributeNode('Cadence');

    int? durOn;
    double? powerOn;
    int? cadenceOn;

    if (duration != null) {
      durOn = (double.parse(duration.value)).round();
    }
    if (powerLow != null) {
      powerOn = double.parse(powerLow.value);
    }
    if (cadence_ != null) {
      cadenceOn = (double.parse(cadence_.value)).round();
    }

    Repetition rep = new Repetition(intervals: [
      RawInterval(duration: durOn,
          powerStart: powerOn,
          powerEnd: powerOn,
          cadence: cadenceOn)
    ]);
    return rep;
  }

}