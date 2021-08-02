///
//  Generated code. Do not modify.
//  source: Workout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class WorkoutFocus extends $pb.ProtobufEnum {
  static const WorkoutFocus Zone1 = WorkoutFocus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone1');
  static const WorkoutFocus Zone2 = WorkoutFocus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone2');
  static const WorkoutFocus Zone3 = WorkoutFocus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone3');
  static const WorkoutFocus Zone4 = WorkoutFocus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone4');
  static const WorkoutFocus Zone5 = WorkoutFocus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone5');
  static const WorkoutFocus Zone6 = WorkoutFocus._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'Zone6');

  static const $core.List<WorkoutFocus> values = <WorkoutFocus> [
    Zone1,
    Zone2,
    Zone3,
    Zone4,
    Zone5,
    Zone6,
  ];

  static final $core.Map<$core.int, WorkoutFocus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WorkoutFocus? valueOf($core.int value) => _byValue[value];

  const WorkoutFocus._($core.int v, $core.String n) : super(v, n);
}

