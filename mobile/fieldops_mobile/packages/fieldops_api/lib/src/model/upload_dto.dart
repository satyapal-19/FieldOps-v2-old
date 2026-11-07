//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_dto.g.dart';

/// UploadDto
///
/// Properties:
/// * [id] - Pass as photoKey on a task update, or as a voice message key
/// * [kind] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [createdAt] 
/// * [replayed] - True when this clientUuid was already uploaded (a retry)
@BuiltValue()
abstract class UploadDto implements Built<UploadDto, UploadDtoBuilder> {
  /// Pass as photoKey on a task update, or as a voice message key
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  UploadDtoKindEnum get kind;
  // enum kindEnum {  TASK_PHOTO,  VOICE_NOTE,  };

  @BuiltValueField(wireName: r'contentType')
  String get contentType;

  @BuiltValueField(wireName: r'sizeBytes')
  num get sizeBytes;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// True when this clientUuid was already uploaded (a retry)
  @BuiltValueField(wireName: r'replayed')
  bool get replayed;

  UploadDto._();

  factory UploadDto([void updates(UploadDtoBuilder b)]) = _$UploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadDto> get serializer => _$UploadDtoSerializer();
}

class _$UploadDtoSerializer implements PrimitiveSerializer<UploadDto> {
  @override
  final Iterable<Type> types = const [UploadDto, _$UploadDto];

  @override
  final String wireName = r'UploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(UploadDtoKindEnum),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'replayed';
    yield serializers.serialize(
      object.replayed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UploadDtoKindEnum),
          ) as UploadDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.sizeBytes = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'replayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.replayed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadDtoBuilder();
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

class UploadDtoKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TASK_PHOTO')
  static const UploadDtoKindEnum TASK_PHOTO = _$uploadDtoKindEnum_TASK_PHOTO;
  @BuiltValueEnumConst(wireName: r'VOICE_NOTE')
  static const UploadDtoKindEnum VOICE_NOTE = _$uploadDtoKindEnum_VOICE_NOTE;

  static Serializer<UploadDtoKindEnum> get serializer => _$uploadDtoKindEnumSerializer;

  const UploadDtoKindEnum._(String name): super(name);

  static BuiltSet<UploadDtoKindEnum> get values => _$uploadDtoKindEnumValues;
  static UploadDtoKindEnum valueOf(String name) => _$uploadDtoKindEnumValueOf(name);
}

