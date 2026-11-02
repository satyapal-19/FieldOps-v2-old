//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_standing_roster_dto.g.dart';

/// UpdateStandingRosterDto
///
/// Properties:
/// * [expectedVersion] - The version you last read; stale versions get 409
/// * [inspectorId] - Move the worker to another inspector
/// * [isActive] 
@BuiltValue()
abstract class UpdateStandingRosterDto implements Built<UpdateStandingRosterDto, UpdateStandingRosterDtoBuilder> {
  /// The version you last read; stale versions get 409
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  /// Move the worker to another inspector
  @BuiltValueField(wireName: r'inspectorId')
  String? get inspectorId;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  UpdateStandingRosterDto._();

  factory UpdateStandingRosterDto([void updates(UpdateStandingRosterDtoBuilder b)]) = _$UpdateStandingRosterDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateStandingRosterDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateStandingRosterDto> get serializer => _$UpdateStandingRosterDtoSerializer();
}

class _$UpdateStandingRosterDtoSerializer implements PrimitiveSerializer<UpdateStandingRosterDto> {
  @override
  final Iterable<Type> types = const [UpdateStandingRosterDto, _$UpdateStandingRosterDto];

  @override
  final String wireName = r'UpdateStandingRosterDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateStandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    if (object.inspectorId != null) {
      yield r'inspectorId';
      yield serializers.serialize(
        object.inspectorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateStandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateStandingRosterDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateStandingRosterDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateStandingRosterDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

