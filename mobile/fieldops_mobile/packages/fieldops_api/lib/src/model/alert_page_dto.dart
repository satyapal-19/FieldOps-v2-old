//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/alert_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'alert_page_dto.g.dart';

/// AlertPageDto
///
/// Properties:
/// * [items] 
/// * [page] 
/// * [pageSize] 
/// * [total] 
@BuiltValue()
abstract class AlertPageDto implements Built<AlertPageDto, AlertPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AlertDto> get items;

  @BuiltValueField(wireName: r'page')
  num get page;

  @BuiltValueField(wireName: r'pageSize')
  num get pageSize;

  @BuiltValueField(wireName: r'total')
  num get total;

  AlertPageDto._();

  factory AlertPageDto([void updates(AlertPageDtoBuilder b)]) = _$AlertPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlertPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlertPageDto> get serializer => _$AlertPageDtoSerializer();
}

class _$AlertPageDtoSerializer implements PrimitiveSerializer<AlertPageDto> {
  @override
  final Iterable<Type> types = const [AlertPageDto, _$AlertPageDto];

  @override
  final String wireName = r'AlertPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlertPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AlertDto)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(num),
    );
    yield r'pageSize';
    yield serializers.serialize(
      object.pageSize,
      specifiedType: const FullType(num),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlertPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlertPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AlertDto)]),
          ) as BuiltList<AlertDto>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.page = valueDes;
          break;
        case r'pageSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.pageSize = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlertPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlertPageDtoBuilder();
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

