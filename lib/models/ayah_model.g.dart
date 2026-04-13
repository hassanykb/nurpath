// GENERATED CODE - DO NOT MODIFY BY HAND
// This file is a stub — run `dart run build_runner build` to regenerate.

part of 'ayah_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAyahModelCollection on Isar {
  IsarCollection<AyahModel> get ayahModels => this.collection();
}

const AyahModelSchema = CollectionSchema(
  name: r'AyahModel',
  id: 2765982780359760246,
  properties: {
    r'arabicText': PropertySchema(
      id: 0,
      name: r'arabicText',
      type: IsarType.string,
    ),
    r'audioUrl': PropertySchema(
      id: 1,
      name: r'audioUrl',
      type: IsarType.string,
    ),
    r'ayahNumber': PropertySchema(
      id: 2,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'isBookmarked': PropertySchema(
      id: 3,
      name: r'isBookmarked',
      type: IsarType.bool,
    ),
    r'isRead': PropertySchema(
      id: 4,
      name: r'isRead',
      type: IsarType.bool,
    ),
    r'lastReadAt': PropertySchema(
      id: 5,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'surahNumber': PropertySchema(
      id: 6,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'translation': PropertySchema(
      id: 7,
      name: r'translation',
      type: IsarType.string,
    ),
    r'transliteration': PropertySchema(
      id: 8,
      name: r'transliteration',
      type: IsarType.string,
    )
  },
  estimateSize: _ayahModelEstimateSize,
  serialize: _ayahModelSerialize,
  deserialize: _ayahModelDeserialize,
  deserializeProp: _ayahModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahNumber_ayahNumber': IndexSchema(
      id: -3459268580706378786,
      name: r'surahNumber_ayahNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahNumber',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'ayahNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isBookmarked': IndexSchema(
      id: -7167672440897361940,
      name: r'isBookmarked',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isBookmarked',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ayahModelGetId,
  getLinks: _ayahModelGetLinks,
  attach: _ayahModelAttach,
  version: '3.1.0+1',
);

int _ayahModelEstimateSize(
  AyahModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.arabicText.length * 3;
  {
    final value = object.audioUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.translation.length * 3;
  bytesCount += 3 + object.transliteration.length * 3;
  return bytesCount;
}

void _ayahModelSerialize(
  AyahModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.arabicText);
  writer.writeString(offsets[1], object.audioUrl);
  writer.writeLong(offsets[2], object.ayahNumber);
  writer.writeBool(offsets[3], object.isBookmarked);
  writer.writeBool(offsets[4], object.isRead);
  writer.writeDateTime(offsets[5], object.lastReadAt);
  writer.writeLong(offsets[6], object.surahNumber);
  writer.writeString(offsets[7], object.translation);
  writer.writeString(offsets[8], object.transliteration);
}

AyahModel _ayahModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AyahModel();
  object.arabicText = reader.readString(offsets[0]);
  object.audioUrl = reader.readStringOrNull(offsets[1]);
  object.ayahNumber = reader.readLong(offsets[2]);
  object.id = id;
  object.isBookmarked = reader.readBool(offsets[3]);
  object.isRead = reader.readBool(offsets[4]);
  object.lastReadAt = reader.readDateTimeOrNull(offsets[5]);
  object.surahNumber = reader.readLong(offsets[6]);
  object.translation = reader.readString(offsets[7]);
  object.transliteration = reader.readString(offsets[8]);
  return object;
}

P _ayahModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ayahModelGetId(AyahModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ayahModelGetLinks(AyahModel object) {
  return [];
}

void _ayahModelAttach(IsarCollection<dynamic> col, Id id, AyahModel object) {
  object.id = id;
}

extension AyahModelQueryWhere on QueryBuilder<AyahModel, AyahModel, QWhereClause> {
  QueryBuilder<AyahModel, AyahModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }
}

extension AyahModelQueryFilter on QueryBuilder<AyahModel, AyahModel, QFilterCondition> {
  QueryBuilder<AyahModel, AyahModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahModel, AyahModel, QAfterFilterCondition> isBookmarkedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBookmarked',
        value: value,
      ));
    });
  }
}

extension AyahModelQuerySortBy on QueryBuilder<AyahModel, AyahModel, QSortBy> {}

extension AyahModelQuerySortThenBy on QueryBuilder<AyahModel, AyahModel, QSortThenBy> {}

extension AyahModelQueryWhereDistinct on QueryBuilder<AyahModel, AyahModel, QDistinct> {}

extension AyahModelQueryProperty on QueryBuilder<AyahModel, AyahModel, QQueryProperty> {
  QueryBuilder<int, AyahModel, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}

// SurahModel schema stub
extension GetSurahModelCollection on Isar {
  IsarCollection<SurahModel> get surahModels => this.collection();
}

const SurahModelSchema = CollectionSchema(
  name: r'SurahModel',
  id: 1234567890123456789,
  properties: {
    r'ayahCount': PropertySchema(id: 0, name: r'ayahCount', type: IsarType.long),
    r'description': PropertySchema(id: 1, name: r'description', type: IsarType.string),
    r'nameArabic': PropertySchema(id: 2, name: r'nameArabic', type: IsarType.string),
    r'nameEnglish': PropertySchema(id: 3, name: r'nameEnglish', type: IsarType.string),
    r'nameTransliteration': PropertySchema(id: 4, name: r'nameTransliteration', type: IsarType.string),
    r'number': PropertySchema(id: 5, name: r'number', type: IsarType.long),
    r'readProgress': PropertySchema(id: 6, name: r'readProgress', type: IsarType.double),
    r'revelationType': PropertySchema(id: 7, name: r'revelationType', type: IsarType.string),
  },
  estimateSize: _surahModelEstimateSize,
  serialize: _surahModelSerialize,
  deserialize: _surahModelDeserialize,
  deserializeProp: _surahModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'number': IndexSchema(
      id: 9876543210987654321,
      name: r'number',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'number', type: IndexType.value, caseSensitive: false),
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _surahModelGetId,
  getLinks: _surahModelGetLinks,
  attach: _surahModelAttach,
  version: '3.1.0+1',
);

int _surahModelEstimateSize(SurahModel o, List<int> offsets, Map<Type, List<int>> a) =>
    offsets.last + 3 + o.nameEnglish.length * 3;
void _surahModelSerialize(SurahModel o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeLong(offsets[0], o.ayahCount);
  w.writeString(offsets[1], o.description);
  w.writeString(offsets[2], o.nameArabic);
  w.writeString(offsets[3], o.nameEnglish);
  w.writeString(offsets[4], o.nameTransliteration);
  w.writeLong(offsets[5], o.number);
  w.writeDouble(offsets[6], o.readProgress);
  w.writeString(offsets[7], o.revelationType);
}
SurahModel _surahModelDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = SurahModel();
  o.ayahCount = r.readLong(offsets[0]);
  o.description = r.readStringOrNull(offsets[1]);
  o.nameArabic = r.readString(offsets[2]);
  o.nameEnglish = r.readString(offsets[3]);
  o.nameTransliteration = r.readString(offsets[4]);
  o.number = r.readLong(offsets[5]);
  o.readProgress = r.readDouble(offsets[6]);
  o.revelationType = r.readString(offsets[7]);
  o.id = id;
  return o;
}
P _surahModelDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readLong(offset)) as P;
    case 1: return (r.readStringOrNull(offset)) as P;
    case 2: return (r.readString(offset)) as P;
    case 3: return (r.readString(offset)) as P;
    case 4: return (r.readString(offset)) as P;
    case 5: return (r.readLong(offset)) as P;
    case 6: return (r.readDouble(offset)) as P;
    case 7: return (r.readString(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}
Id _surahModelGetId(SurahModel o) => o.id;
List<IsarLinkBase<dynamic>> _surahModelGetLinks(SurahModel o) => [];
void _surahModelAttach(IsarCollection<dynamic> col, Id id, SurahModel o) { o.id = id; }
