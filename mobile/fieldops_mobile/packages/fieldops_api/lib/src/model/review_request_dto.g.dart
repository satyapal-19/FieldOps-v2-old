// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewRequestDtoDecisionEnum _$reviewRequestDtoDecisionEnum_APPROVED =
    const ReviewRequestDtoDecisionEnum._('APPROVED');
const ReviewRequestDtoDecisionEnum _$reviewRequestDtoDecisionEnum_REJECTED =
    const ReviewRequestDtoDecisionEnum._('REJECTED');

ReviewRequestDtoDecisionEnum _$reviewRequestDtoDecisionEnumValueOf(
    String name) {
  switch (name) {
    case 'APPROVED':
      return _$reviewRequestDtoDecisionEnum_APPROVED;
    case 'REJECTED':
      return _$reviewRequestDtoDecisionEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewRequestDtoDecisionEnum>
    _$reviewRequestDtoDecisionEnumValues =
    BuiltSet<ReviewRequestDtoDecisionEnum>(const <ReviewRequestDtoDecisionEnum>[
  _$reviewRequestDtoDecisionEnum_APPROVED,
  _$reviewRequestDtoDecisionEnum_REJECTED,
]);

Serializer<ReviewRequestDtoDecisionEnum>
    _$reviewRequestDtoDecisionEnumSerializer =
    _$ReviewRequestDtoDecisionEnumSerializer();

class _$ReviewRequestDtoDecisionEnumSerializer
    implements PrimitiveSerializer<ReviewRequestDtoDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewRequestDtoDecisionEnum];
  @override
  final String wireName = 'ReviewRequestDtoDecisionEnum';

  @override
  Object serialize(Serializers serializers, ReviewRequestDtoDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewRequestDtoDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewRequestDtoDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewRequestDto extends ReviewRequestDto {
  @override
  final num expectedVersion;
  @override
  final ReviewRequestDtoDecisionEnum decision;
  @override
  final String? note;

  factory _$ReviewRequestDto(
          [void Function(ReviewRequestDtoBuilder)? updates]) =>
      (ReviewRequestDtoBuilder()..update(updates))._build();

  _$ReviewRequestDto._(
      {required this.expectedVersion, required this.decision, this.note})
      : super._();
  @override
  ReviewRequestDto rebuild(void Function(ReviewRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewRequestDtoBuilder toBuilder() =>
      ReviewRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewRequestDto &&
        expectedVersion == other.expectedVersion &&
        decision == other.decision &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewRequestDto')
          ..add('expectedVersion', expectedVersion)
          ..add('decision', decision)
          ..add('note', note))
        .toString();
  }
}

class ReviewRequestDtoBuilder
    implements Builder<ReviewRequestDto, ReviewRequestDtoBuilder> {
  _$ReviewRequestDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  ReviewRequestDtoDecisionEnum? _decision;
  ReviewRequestDtoDecisionEnum? get decision => _$this._decision;
  set decision(ReviewRequestDtoDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ReviewRequestDtoBuilder() {
    ReviewRequestDto._defaults(this);
  }

  ReviewRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _decision = $v.decision;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewRequestDto other) {
    _$v = other as _$ReviewRequestDto;
  }

  @override
  void update(void Function(ReviewRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewRequestDto build() => _build();

  _$ReviewRequestDto _build() {
    final _$result = _$v ??
        _$ReviewRequestDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'ReviewRequestDto', 'expectedVersion'),
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'ReviewRequestDto', 'decision'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
