

import 'package:xml/xml.dart';

import 'nanopb/Workout.pb.dart';

Repetition convertZwo(XmlElement elmnt) {

  //debugPrint('Interval name ' + elmnt.name.toString());

  if (elmnt.name == 'IntervalsT') {

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
    int? powerOn;
    int? powerOff;
    int? cadenceOn;
    int? cadenceOff;

    if (onDuration != null) {
      durOn = int.parse(onDuration.value);
    }
    if (offDuration != null) {
      durOff = int.parse(offDuration.value);
    }
    if (onPower != null) {
      powerOn = (double.parse(onPower.value) * 100).round();
    }
    if (offPower != null) {
      powerOff = (double.parse(offPower.value) * 100).round();
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

  } else if (elmnt.name == 'Warmup' ||
      elmnt.name == 'Cooldown' ||
      elmnt.name == 'Ramp'
  ) {

    XmlAttribute? duration = elmnt.getAttributeNode('Duration');
    XmlAttribute? powerLow = elmnt.getAttributeNode('PowerLow');
    XmlAttribute? powerHigh = elmnt.getAttributeNode('PowerHigh');

    int? durOn;
    int? powerStart;
    int? powerEnd;

    if (duration != null) {
      durOn = int.parse(duration.value);
    }
    if (powerLow != null) {
      powerStart = (double.parse(powerLow.value) * 100).round();
    }
    if (powerHigh != null) {
      powerEnd = (double.parse(powerHigh.value) * 100).round();
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
    int? powerOn;
    int? cadenceOn;

    if (duration != null) {
      durOn = (double.parse(duration.value)).round();
    }
    if (powerLow != null) {
      powerOn = (double.parse(powerLow.value) * 100).round();
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