///
//  Generated code. Do not modify.
//  source: Workout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'Workout.pbenum.dart';

export 'Workout.pbenum.dart';

class Interval extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Interval', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'powerStart', $pb.PbFieldType.OU3, protoName: 'powerStart')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'powerEnd', $pb.PbFieldType.OU3, protoName: 'powerEnd')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cadence', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  Interval._() : super();
  factory Interval({
    $core.int? duration,
    $core.int? powerStart,
    $core.int? powerEnd,
    $core.int? cadence,
  }) {
    final _result = create();
    if (duration != null) {
      _result.duration = duration;
    }
    if (powerStart != null) {
      _result.powerStart = powerStart;
    }
    if (powerEnd != null) {
      _result.powerEnd = powerEnd;
    }
    if (cadence != null) {
      _result.cadence = cadence;
    }
    return _result;
  }
  factory Interval.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Interval.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Interval clone() => Interval()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Interval copyWith(void Function(Interval) updates) => super.copyWith((message) => updates(message as Interval)) as Interval; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Interval create() => Interval._();
  Interval createEmptyInstance() => create();
  static $pb.PbList<Interval> createRepeated() => $pb.PbList<Interval>();
  @$core.pragma('dart2js:noInline')
  static Interval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Interval>(create);
  static Interval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get duration => $_getIZ(0);
  @$pb.TagNumber(1)
  set duration($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDuration() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuration() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get powerStart => $_getIZ(1);
  @$pb.TagNumber(2)
  set powerStart($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPowerStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPowerStart() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get powerEnd => $_getIZ(2);
  @$pb.TagNumber(3)
  set powerEnd($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPowerEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPowerEnd() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get cadence => $_getIZ(3);
  @$pb.TagNumber(4)
  set cadence($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCadence() => $_has(3);
  @$pb.TagNumber(4)
  void clearCadence() => clearField(4);
}

class Repetition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Repetition', createEmptyInstance: create)
    ..pc<Interval>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'intervals', $pb.PbFieldType.PM, subBuilder: Interval.create)
    ..hasRequiredFields = false
  ;

  Repetition._() : super();
  factory Repetition({
    $core.Iterable<Interval>? intervals,
  }) {
    final _result = create();
    if (intervals != null) {
      _result.intervals.addAll(intervals);
    }
    return _result;
  }
  factory Repetition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Repetition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Repetition clone() => Repetition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Repetition copyWith(void Function(Repetition) updates) => super.copyWith((message) => updates(message as Repetition)) as Repetition; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Repetition create() => Repetition._();
  Repetition createEmptyInstance() => create();
  static $pb.PbList<Repetition> createRepeated() => $pb.PbList<Repetition>();
  @$core.pragma('dart2js:noInline')
  static Repetition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Repetition>(create);
  static Repetition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Interval> get intervals => $_getList(0);
}

class RawWorkout extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RawWorkout', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'author')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'TSS', $pb.PbFieldType.OU3, protoName: 'TSS')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration', $pb.PbFieldType.OU3)
    ..e<WorkoutFocus>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'focus', $pb.PbFieldType.OE, defaultOrMaker: WorkoutFocus.Zone1, valueOf: WorkoutFocus.valueOf, enumValues: WorkoutFocus.values)
    ..aOM<Interval>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'warmup', subBuilder: Interval.create)
    ..pc<Repetition>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reps', $pb.PbFieldType.PM, subBuilder: Repetition.create)
    ..aOM<Interval>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cooldown', subBuilder: Interval.create)
    ..hasRequiredFields = false
  ;

  RawWorkout._() : super();
  factory RawWorkout({
    $core.String? name,
    $core.String? author,
    $core.String? description,
    $core.int? tSS,
    $core.int? duration,
    WorkoutFocus? focus,
    Interval? warmup,
    $core.Iterable<Repetition>? reps,
    Interval? cooldown,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (author != null) {
      _result.author = author;
    }
    if (description != null) {
      _result.description = description;
    }
    if (tSS != null) {
      _result.tSS = tSS;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    if (focus != null) {
      _result.focus = focus;
    }
    if (warmup != null) {
      _result.warmup = warmup;
    }
    if (reps != null) {
      _result.reps.addAll(reps);
    }
    if (cooldown != null) {
      _result.cooldown = cooldown;
    }
    return _result;
  }
  factory RawWorkout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RawWorkout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RawWorkout clone() => RawWorkout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RawWorkout copyWith(void Function(RawWorkout) updates) => super.copyWith((message) => updates(message as RawWorkout)) as RawWorkout; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RawWorkout create() => RawWorkout._();
  RawWorkout createEmptyInstance() => create();
  static $pb.PbList<RawWorkout> createRepeated() => $pb.PbList<RawWorkout>();
  @$core.pragma('dart2js:noInline')
  static RawWorkout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RawWorkout>(create);
  static RawWorkout? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get tSS => $_getIZ(3);
  @$pb.TagNumber(4)
  set tSS($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTSS() => $_has(3);
  @$pb.TagNumber(4)
  void clearTSS() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get duration => $_getIZ(4);
  @$pb.TagNumber(5)
  set duration($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => clearField(5);

  @$pb.TagNumber(6)
  WorkoutFocus get focus => $_getN(5);
  @$pb.TagNumber(6)
  set focus(WorkoutFocus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasFocus() => $_has(5);
  @$pb.TagNumber(6)
  void clearFocus() => clearField(6);

  @$pb.TagNumber(10)
  Interval get warmup => $_getN(6);
  @$pb.TagNumber(10)
  set warmup(Interval v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasWarmup() => $_has(6);
  @$pb.TagNumber(10)
  void clearWarmup() => clearField(10);
  @$pb.TagNumber(10)
  Interval ensureWarmup() => $_ensure(6);

  @$pb.TagNumber(11)
  $core.List<Repetition> get reps => $_getList(7);

  @$pb.TagNumber(12)
  Interval get cooldown => $_getN(8);
  @$pb.TagNumber(12)
  set cooldown(Interval v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCooldown() => $_has(8);
  @$pb.TagNumber(12)
  void clearCooldown() => clearField(12);
  @$pb.TagNumber(12)
  Interval ensureCooldown() => $_ensure(8);
}

class RawWorkoutDB extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RawWorkoutDB', createEmptyInstance: create)
    ..pc<RawWorkout>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawDB', $pb.PbFieldType.PM, protoName: 'rawDB', subBuilder: RawWorkout.create)
    ..hasRequiredFields = false
  ;

  RawWorkoutDB._() : super();
  factory RawWorkoutDB({
    $core.Iterable<RawWorkout>? rawDB,
  }) {
    final _result = create();
    if (rawDB != null) {
      _result.rawDB.addAll(rawDB);
    }
    return _result;
  }
  factory RawWorkoutDB.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RawWorkoutDB.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RawWorkoutDB clone() => RawWorkoutDB()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RawWorkoutDB copyWith(void Function(RawWorkoutDB) updates) => super.copyWith((message) => updates(message as RawWorkoutDB)) as RawWorkoutDB; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RawWorkoutDB create() => RawWorkoutDB._();
  RawWorkoutDB createEmptyInstance() => create();
  static $pb.PbList<RawWorkoutDB> createRepeated() => $pb.PbList<RawWorkoutDB>();
  @$core.pragma('dart2js:noInline')
  static RawWorkoutDB getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RawWorkoutDB>(create);
  static RawWorkoutDB? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<RawWorkout> get rawDB => $_getList(0);
}

