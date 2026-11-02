//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assignee_update_dto.g.dart';

/// AssigneeUpdateDto
///
/// Properties:
/// * [clientUuid] - Idempotency key from the phone; a retry changes nothing
/// * [action] 
/// * [note] - Required to SUBMIT unless a photo is attached
/// * [photoKey] - Storage key from the upload endpoint (after-photo on SUBMIT)
/// * [lat] 
/// * [lng] 
@BuiltValue()
abstract class AssigneeUpdateDto implements Built<AssigneeUpdateDto, AssigneeUpdateDtoBuilder> {
  /// Idempotency key from the phone; a retry changes nothing
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'action')
  AssigneeUpdateDtoActionEnum get action;
  // enum actionEnum {  START,  SUBMIT,  };

  /// Required to SUBMIT unless a photo is attached
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// Storage key from the upload endpoint (after-photo on SUBMIT)
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'lat')
  num? get lat;

  @BuiltValueField(wireName: r'lng')
  num? get lng;

  AssigneeUpdateDto._();

  factory AssigneeUpdateDto([void updates(AssigneeUpdateDtoBuilder b)]) = _$AssigneeUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssigneeUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssigneeUpdateDto> get serializer => _$AssigneeUpdateDtoSerializer();
}

class _$AssigneeUpdateDtoSerializer implements PrimitiveSerializer<AssigneeUpdateDto> {
  @override
  final Iterable<Type> types = const [AssigneeUpdateDto, _$AssigneeUpdateDto];

  @override
  final String wireName = r'AssigneeUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssigneeUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AssigneeUpdateDtoActionEnum),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.photoKey != null) {
      yield r'photoKey';
      yield serializers.serialize(
        object.photoKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.lat != null) {
      yield r'lat';
      yield serializers.serialize(
        object.lat,
        specifiedType: const FullType(num),
      );
    }
    if (object.lng != null) {
      yield r'lng';
      yield serializers.serialize(
        object.lng,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssigneeUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssigneeUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssigneeUpdateDtoActionEnum),
          ) as AssigneeUpdateDtoActionEnum;
          result.action = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        case r'photoKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.photoKey = valueDes;
          break;
        case r'lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lat = valueDes;
          break;
        case r'lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lng = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssigneeUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssigneeUpdateDtoBuilder();
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

class AssigneeUpdateDtoActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'START')
  static const AssigneeUpdateDtoActionEnum START = _$assigneeUpdateDtoActionEnum_START;
  @BuiltValueEnumConst(wireName: r'SUBMIT')
  static const AssigneeUpdateDtoActionEnum SUBMIT = _$assigneeUpdateDtoActionEnum_SUBMIT;

  static Serializer<AssigneeUpdateDtoActionEnum> get serializer => _$assigneeUpdateDtoActionEnumSerializer;

  const AssigneeUpdateDtoActionEnum._(String name): super(name);

  static BuiltSet<AssigneeUpdateDtoActionEnum> get values => _$assigneeUpdateDtoActionEnumValues;
  static AssigneeUpdateDtoActionEnum valueOf(String name) => _$assigneeUpdateDtoActionEnumValueOf(name);
}

