//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_regularization_dto.g.dart';

/// CreateRegularizationDto
///
/// Properties:
/// * [clientUuid] 
/// * [attendanceDate] - One of the last 7 days (IST)
/// * [reasonType] 
/// * [explanation] 
@BuiltValue()
abstract class CreateRegularizationDto implements Built<CreateRegularizationDto, CreateRegularizationDtoBuilder> {
  @BuiltValueField(wireName: r'clientUuid')
  String? get clientUuid;

  /// One of the last 7 days (IST)
  @BuiltValueField(wireName: r'attendanceDate')
  String get attendanceDate;

  @BuiltValueField(wireName: r'reasonType')
  CreateRegularizationDtoReasonTypeEnum get reasonType;
  // enum reasonTypeEnum {  BATTERY_DEAD,  APP_CRASH,  FIELD_RESCUE_DUTY,  OUT_OF_NETWORK,  OTHER,  };

  @BuiltValueField(wireName: r'explanation')
  String get explanation;

  CreateRegularizationDto._();

  factory CreateRegularizationDto([void updates(CreateRegularizationDtoBuilder b)]) = _$CreateRegularizationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateRegularizationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateRegularizationDto> get serializer => _$CreateRegularizationDtoSerializer();
}

class _$CreateRegularizationDtoSerializer implements PrimitiveSerializer<CreateRegularizationDto> {
  @override
  final Iterable<Type> types = const [CreateRegularizationDto, _$CreateRegularizationDto];

  @override
  final String wireName = r'CreateRegularizationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateRegularizationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clientUuid != null) {
      yield r'clientUuid';
      yield serializers.serialize(
        object.clientUuid,
        specifiedType: const FullType(String),
      );
    }
    yield r'attendanceDate';
    yield serializers.serialize(
      object.attendanceDate,
      specifiedType: const FullType(String),
    );
    yield r'reasonType';
    yield serializers.serialize(
      object.reasonType,
      specifiedType: const FullType(CreateRegularizationDtoReasonTypeEnum),
    );
    yield r'explanation';
    yield serializers.serialize(
      object.explanation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateRegularizationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateRegularizationDtoBuilder result,
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
        case r'attendanceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.attendanceDate = valueDes;
          break;
        case r'reasonType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateRegularizationDtoReasonTypeEnum),
          ) as CreateRegularizationDtoReasonTypeEnum;
          result.reasonType = valueDes;
          break;
        case r'explanation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explanation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateRegularizationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateRegularizationDtoBuilder();
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

class CreateRegularizationDtoReasonTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BATTERY_DEAD')
  static const CreateRegularizationDtoReasonTypeEnum BATTERY_DEAD = _$createRegularizationDtoReasonTypeEnum_BATTERY_DEAD;
  @BuiltValueEnumConst(wireName: r'APP_CRASH')
  static const CreateRegularizationDtoReasonTypeEnum APP_CRASH = _$createRegularizationDtoReasonTypeEnum_APP_CRASH;
  @BuiltValueEnumConst(wireName: r'FIELD_RESCUE_DUTY')
  static const CreateRegularizationDtoReasonTypeEnum FIELD_RESCUE_DUTY = _$createRegularizationDtoReasonTypeEnum_FIELD_RESCUE_DUTY;
  @BuiltValueEnumConst(wireName: r'OUT_OF_NETWORK')
  static const CreateRegularizationDtoReasonTypeEnum OUT_OF_NETWORK = _$createRegularizationDtoReasonTypeEnum_OUT_OF_NETWORK;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const CreateRegularizationDtoReasonTypeEnum OTHER = _$createRegularizationDtoReasonTypeEnum_OTHER;

  static Serializer<CreateRegularizationDtoReasonTypeEnum> get serializer => _$createRegularizationDtoReasonTypeEnumSerializer;

  const CreateRegularizationDtoReasonTypeEnum._(String name): super(name);

  static BuiltSet<CreateRegularizationDtoReasonTypeEnum> get values => _$createRegularizationDtoReasonTypeEnumValues;
  static CreateRegularizationDtoReasonTypeEnum valueOf(String name) => _$createRegularizationDtoReasonTypeEnumValueOf(name);
}

