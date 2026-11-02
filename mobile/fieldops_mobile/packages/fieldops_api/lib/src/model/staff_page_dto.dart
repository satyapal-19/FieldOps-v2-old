//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/staff_profile_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'staff_page_dto.g.dart';

/// StaffPageDto
///
/// Properties:
/// * [items] 
/// * [page] 
/// * [pageSize] 
/// * [total] 
@BuiltValue()
abstract class StaffPageDto implements Built<StaffPageDto, StaffPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<StaffProfileDto> get items;

  @BuiltValueField(wireName: r'page')
  num get page;

  @BuiltValueField(wireName: r'pageSize')
  num get pageSize;

  @BuiltValueField(wireName: r'total')
  num get total;

  StaffPageDto._();

  factory StaffPageDto([void updates(StaffPageDtoBuilder b)]) = _$StaffPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StaffPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StaffPageDto> get serializer => _$StaffPageDtoSerializer();
}

class _$StaffPageDtoSerializer implements PrimitiveSerializer<StaffPageDto> {
  @override
  final Iterable<Type> types = const [StaffPageDto, _$StaffPageDto];

  @override
  final String wireName = r'StaffPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StaffPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(StaffProfileDto)]),
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
    StaffPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StaffPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StaffProfileDto)]),
          ) as BuiltList<StaffProfileDto>;
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
  StaffPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StaffPageDtoBuilder();
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

