//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/ward_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ward_page_dto.g.dart';

/// WardPageDto
///
/// Properties:
/// * [items] 
/// * [page] 
/// * [pageSize] 
/// * [total] 
@BuiltValue()
abstract class WardPageDto implements Built<WardPageDto, WardPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<WardDto> get items;

  @BuiltValueField(wireName: r'page')
  num get page;

  @BuiltValueField(wireName: r'pageSize')
  num get pageSize;

  @BuiltValueField(wireName: r'total')
  num get total;

  WardPageDto._();

  factory WardPageDto([void updates(WardPageDtoBuilder b)]) = _$WardPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WardPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WardPageDto> get serializer => _$WardPageDtoSerializer();
}

class _$WardPageDtoSerializer implements PrimitiveSerializer<WardPageDto> {
  @override
  final Iterable<Type> types = const [WardPageDto, _$WardPageDto];

  @override
  final String wireName = r'WardPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WardPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WardDto)]),
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
    WardPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WardPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WardDto)]),
          ) as BuiltList<WardDto>;
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
  WardPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WardPageDtoBuilder();
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

