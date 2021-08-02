///
//  Generated code. Do not modify.
//  source: Workout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use workoutFocusDescriptor instead')
const WorkoutFocus$json = const {
  '1': 'WorkoutFocus',
  '2': const [
    const {'1': 'Zone1', '2': 0},
    const {'1': 'Zone2', '2': 1},
    const {'1': 'Zone3', '2': 2},
    const {'1': 'Zone4', '2': 3},
    const {'1': 'Zone5', '2': 4},
    const {'1': 'Zone6', '2': 5},
  ],
};

/// Descriptor for `WorkoutFocus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workoutFocusDescriptor = $convert.base64Decode('CgxXb3Jrb3V0Rm9jdXMSCQoFWm9uZTEQABIJCgVab25lMhABEgkKBVpvbmUzEAISCQoFWm9uZTQQAxIJCgVab25lNRAEEgkKBVpvbmU2EAU=');
@$core.Deprecated('Use intervalDescriptor instead')
const Interval$json = const {
  '1': 'Interval',
  '2': const [
    const {'1': 'powerStart', '3': 1, '4': 1, '5': 13, '10': 'powerStart'},
    const {'1': 'powerEnd', '3': 2, '4': 1, '5': 13, '10': 'powerEnd'},
    const {'1': 'cadence', '3': 3, '4': 1, '5': 13, '10': 'cadence'},
  ],
};

/// Descriptor for `Interval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intervalDescriptor = $convert.base64Decode('CghJbnRlcnZhbBIeCgpwb3dlclN0YXJ0GAEgASgNUgpwb3dlclN0YXJ0EhoKCHBvd2VyRW5kGAIgASgNUghwb3dlckVuZBIYCgdjYWRlbmNlGAMgASgNUgdjYWRlbmNl');
@$core.Deprecated('Use repetitionDescriptor instead')
const Repetition$json = const {
  '1': 'Repetition',
  '2': const [
    const {'1': 'intervals', '3': 1, '4': 3, '5': 11, '6': '.Interval', '10': 'intervals'},
  ],
};

/// Descriptor for `Repetition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repetitionDescriptor = $convert.base64Decode('CgpSZXBldGl0aW9uEicKCWludGVydmFscxgBIAMoCzIJLkludGVydmFsUglpbnRlcnZhbHM=');
@$core.Deprecated('Use rawWorkoutDescriptor instead')
const RawWorkout$json = const {
  '1': 'RawWorkout',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'TSS', '3': 4, '4': 1, '5': 13, '10': 'TSS'},
    const {'1': 'duration', '3': 5, '4': 1, '5': 13, '10': 'duration'},
    const {'1': 'focus', '3': 6, '4': 1, '5': 14, '6': '.WorkoutFocus', '10': 'focus'},
    const {'1': 'warmup', '3': 10, '4': 1, '5': 11, '6': '.Interval', '10': 'warmup'},
    const {'1': 'reps', '3': 11, '4': 3, '5': 11, '6': '.Repetition', '10': 'reps'},
    const {'1': 'cooldown', '3': 12, '4': 1, '5': 11, '6': '.Interval', '10': 'cooldown'},
  ],
};

/// Descriptor for `RawWorkout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rawWorkoutDescriptor = $convert.base64Decode('CgpSYXdXb3Jrb3V0EhIKBG5hbWUYASABKAlSBG5hbWUSFgoGYXV0aG9yGAIgASgJUgZhdXRob3ISIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEhAKA1RTUxgEIAEoDVIDVFNTEhoKCGR1cmF0aW9uGAUgASgNUghkdXJhdGlvbhIjCgVmb2N1cxgGIAEoDjINLldvcmtvdXRGb2N1c1IFZm9jdXMSIQoGd2FybXVwGAogASgLMgkuSW50ZXJ2YWxSBndhcm11cBIfCgRyZXBzGAsgAygLMgsuUmVwZXRpdGlvblIEcmVwcxIlCghjb29sZG93bhgMIAEoCzIJLkludGVydmFsUghjb29sZG93bg==');
