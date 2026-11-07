//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'staff_report_row_dto.g.dart';

/// StaffReportRowDto
///
/// Properties:
/// * [staffId] 
/// * [days] - Days with an attendance row
/// * [present] - Days with a check-in
/// * [late_] 
/// * [lateMinutes] 
/// * [halfDay] 
/// * [absent] 
/// * [onLeave] 
/// * [regularized] 
/// * [autoCheckout] 
/// * [suspicious] 
@BuiltValue()
abstract class StaffReportRowDto implements Built<StaffReportRowDto, StaffReportRowDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  /// Days with an attendance row
  @BuiltValueField(wireName: r'days')
  num get days;

  /// Days with a check-in
  @BuiltValueField(wireName: r'present')
  num get present;

  @BuiltValueField(wireName: r'late')
  num get late_;

  @BuiltValueField(wireName: r'lateMinutes')
  num get lateMinutes;

  @BuiltValueField(wireName: r'halfDay')
  num get halfDay;

  @BuiltValueField(wireName: r'absent')
  num get absent;

  @BuiltValueField(wireName: r'onLeave')
  num get onLeave;

  @BuiltValueField(wireName: r'regularized')
  num get regularized;

  @BuiltValueField(wireName: r'autoCheckout')
  num get autoCheckout;

  @BuiltValueField(wireName: r'suspicious')
  num get suspicious;

  StaffReportRowDto._();

  factory StaffReportRowDto([void updates(StaffReportRowDtoBuilder b)]) = _$StaffReportRowDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StaffReportRowDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StaffReportRowDto> get serializer => _$StaffReportRowDtoSerializer();
}

class _$StaffReportRowDtoSerializer implements PrimitiveSerializer<StaffReportRowDto> {
  @override
  final Iterable<Type> types = const [StaffReportRowDto, _$StaffReportRowDto];

  @override
  final String wireName = r'StaffReportRowDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StaffReportRowDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(num),
    );
    yield r'present';
    yield serializers.serialize(
      object.present,
      specifiedType: const FullType(num),
    );
    yield r'late';
    yield serializers.serialize(
      object.late_,
      specifiedType: const FullType(num),
    );
    yield r'lateMinutes';
    yield serializers.serialize(
      object.lateMinutes,
      specifiedType: const FullType(num),
    );
    yield r'halfDay';
    yield serializers.serialize(
      object.halfDay,
      specifiedType: const FullType(num),
    );
    yield r'absent';
    yield serializers.serialize(
      object.absent,
      specifiedType: const FullType(num),
    );
    yield r'onLeave';
    yield serializers.serialize(
      object.onLeave,
      specifiedType: const FullType(num),
    );
    yield r'regularized';
    yield serializers.serialize(
      object.regularized,
      specifiedType: const FullType(num),
    );
    yield r'autoCheckout';
    yield serializers.serialize(
      object.autoCheckout,
      specifiedType: const FullType(num),
    );
    yield r'suspicious';
    yield serializers.serialize(
      object.suspicious,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StaffReportRowDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StaffReportRowDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.days = valueDes;
          break;
        case r'present':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.present = valueDes;
          break;
        case r'late':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.late_ = valueDes;
          break;
        case r'lateMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lateMinutes = valueDes;
          break;
        case r'halfDay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.halfDay = valueDes;
          break;
        case r'absent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.absent = valueDes;
          break;
        case r'onLeave':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.onLeave = valueDes;
          break;
        case r'regularized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.regularized = valueDes;
          break;
        case r'autoCheckout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.autoCheckout = valueDes;
          break;
        case r'suspicious':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.suspicious = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StaffReportRowDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StaffReportRowDtoBuilder();
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

