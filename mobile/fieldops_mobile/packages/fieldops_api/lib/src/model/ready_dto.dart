//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready_dto.g.dart';

/// ReadyDto
///
/// Properties:
/// * [status] 
/// * [database] 
/// * [pendingMigrations] 
@BuiltValue()
abstract class ReadyDto implements Built<ReadyDto, ReadyDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'database')
  String get database;

  @BuiltValueField(wireName: r'pendingMigrations')
  bool get pendingMigrations;

  ReadyDto._();

  factory ReadyDto([void updates(ReadyDtoBuilder b)]) = _$ReadyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadyDto> get serializer => _$ReadyDtoSerializer();
}

class _$ReadyDtoSerializer implements PrimitiveSerializer<ReadyDto> {
  @override
  final Iterable<Type> types = const [ReadyDto, _$ReadyDto];

  @override
  final String wireName = r'ReadyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'database';
    yield serializers.serialize(
      object.database,
      specifiedType: const FullType(String),
    );
    yield r'pendingMigrations';
    yield serializers.serialize(
      object.pendingMigrations,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'database':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.database = valueDes;
          break;
        case r'pendingMigrations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pendingMigrations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyDtoBuilder();
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

