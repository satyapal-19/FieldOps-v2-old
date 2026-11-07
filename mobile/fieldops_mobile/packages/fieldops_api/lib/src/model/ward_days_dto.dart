//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/ward_day_report_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ward_days_dto.g.dart';

/// WardDaysDto
///
/// Properties:
/// * [items] - Newest first; from the nightly summaries
@BuiltValue()
abstract class WardDaysDto implements Built<WardDaysDto, WardDaysDtoBuilder> {
  /// Newest first; from the nightly summaries
  @BuiltValueField(wireName: r'items')
  BuiltList<WardDayReportDto> get items;

  WardDaysDto._();

  factory WardDaysDto([void updates(WardDaysDtoBuilder b)]) = _$WardDaysDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WardDaysDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WardDaysDto> get serializer => _$WardDaysDtoSerializer();
}

class _$WardDaysDtoSerializer implements PrimitiveSerializer<WardDaysDto> {
  @override
  final Iterable<Type> types = const [WardDaysDto, _$WardDaysDto];

  @override
  final String wireName = r'WardDaysDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WardDaysDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WardDayReportDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WardDaysDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WardDaysDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WardDayReportDto)]),
          ) as BuiltList<WardDayReportDto>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WardDaysDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WardDaysDtoBuilder();
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

