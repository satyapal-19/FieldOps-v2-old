//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resolve_alert_dto.g.dart';

/// ResolveAlertDto
///
/// Properties:
/// * [note] 
@BuiltValue()
abstract class ResolveAlertDto implements Built<ResolveAlertDto, ResolveAlertDtoBuilder> {
  @BuiltValueField(wireName: r'note')
  String? get note;

  ResolveAlertDto._();

  factory ResolveAlertDto([void updates(ResolveAlertDtoBuilder b)]) = _$ResolveAlertDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResolveAlertDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResolveAlertDto> get serializer => _$ResolveAlertDtoSerializer();
}

class _$ResolveAlertDtoSerializer implements PrimitiveSerializer<ResolveAlertDto> {
  @override
  final Iterable<Type> types = const [ResolveAlertDto, _$ResolveAlertDto];

  @override
  final String wireName = r'ResolveAlertDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResolveAlertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ResolveAlertDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResolveAlertDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResolveAlertDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResolveAlertDtoBuilder();
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

