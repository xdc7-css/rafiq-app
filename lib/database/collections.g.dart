// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsIsarCollection on Isar {
  IsarCollection<SettingsIsar> get settingsIsars => this.collection();
}

const SettingsIsarSchema = CollectionSchema(
  name: r'SettingsIsar',
  id: 5385768829924721998,
  properties: {
    r'data': PropertySchema(
      id: 0,
      name: r'data',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 1,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _settingsIsarEstimateSize,
  serialize: _settingsIsarSerialize,
  deserialize: _settingsIsarDeserialize,
  deserializeProp: _settingsIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsIsarGetId,
  getLinks: _settingsIsarGetLinks,
  attach: _settingsIsarAttach,
  version: '3.1.0+1',
);

int _settingsIsarEstimateSize(
  SettingsIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.data.length * 3;
  return bytesCount;
}

void _settingsIsarSerialize(
  SettingsIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.data);
  writer.writeDateTime(offsets[1], object.updatedAt);
}

SettingsIsar _settingsIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsIsar();
  object.data = reader.readString(offsets[0]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _settingsIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsIsarGetId(SettingsIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsIsarGetLinks(SettingsIsar object) {
  return [];
}

void _settingsIsarAttach(
    IsarCollection<dynamic> col, Id id, SettingsIsar object) {
  object.id = id;
}

extension SettingsIsarQueryWhereSort
    on QueryBuilder<SettingsIsar, SettingsIsar, QWhere> {
  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsIsarQueryWhere
    on QueryBuilder<SettingsIsar, SettingsIsar, QWhereClause> {
  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsIsarQueryFilter
    on QueryBuilder<SettingsIsar, SettingsIsar, QFilterCondition> {
  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> dataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsIsarQueryObject
    on QueryBuilder<SettingsIsar, SettingsIsar, QFilterCondition> {}

extension SettingsIsarQueryLinks
    on QueryBuilder<SettingsIsar, SettingsIsar, QFilterCondition> {}

extension SettingsIsarQuerySortBy
    on QueryBuilder<SettingsIsar, SettingsIsar, QSortBy> {
  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SettingsIsarQuerySortThenBy
    on QueryBuilder<SettingsIsar, SettingsIsar, QSortThenBy> {
  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SettingsIsarQueryWhereDistinct
    on QueryBuilder<SettingsIsar, SettingsIsar, QDistinct> {
  QueryBuilder<SettingsIsar, SettingsIsar, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsIsar, SettingsIsar, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SettingsIsarQueryProperty
    on QueryBuilder<SettingsIsar, SettingsIsar, QQueryProperty> {
  QueryBuilder<SettingsIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsIsar, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<SettingsIsar, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteIsarCollection on Isar {
  IsarCollection<FavoriteIsar> get favoriteIsars => this.collection();
}

const FavoriteIsarSchema = CollectionSchema(
  name: r'FavoriteIsar',
  id: 2798399325451602493,
  properties: {
    r'dateAdded': PropertySchema(
      id: 0,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'metadata': PropertySchema(
      id: 1,
      name: r'metadata',
      type: IsarType.string,
    ),
    r'reference': PropertySchema(
      id: 2,
      name: r'reference',
      type: IsarType.string,
    ),
    r'textArabic': PropertySchema(
      id: 3,
      name: r'textArabic',
      type: IsarType.string,
    ),
    r'typeIndex': PropertySchema(
      id: 4,
      name: r'typeIndex',
      type: IsarType.long,
    ),
    r'uniqueKey': PropertySchema(
      id: 5,
      name: r'uniqueKey',
      type: IsarType.string,
    )
  },
  estimateSize: _favoriteIsarEstimateSize,
  serialize: _favoriteIsarSerialize,
  deserialize: _favoriteIsarDeserialize,
  deserializeProp: _favoriteIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uniqueKey': IndexSchema(
      id: -866995956150369819,
      name: r'uniqueKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uniqueKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _favoriteIsarGetId,
  getLinks: _favoriteIsarGetLinks,
  attach: _favoriteIsarAttach,
  version: '3.1.0+1',
);

int _favoriteIsarEstimateSize(
  FavoriteIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.metadata.length * 3;
  bytesCount += 3 + object.reference.length * 3;
  bytesCount += 3 + object.textArabic.length * 3;
  bytesCount += 3 + object.uniqueKey.length * 3;
  return bytesCount;
}

void _favoriteIsarSerialize(
  FavoriteIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateAdded);
  writer.writeString(offsets[1], object.metadata);
  writer.writeString(offsets[2], object.reference);
  writer.writeString(offsets[3], object.textArabic);
  writer.writeLong(offsets[4], object.typeIndex);
  writer.writeString(offsets[5], object.uniqueKey);
}

FavoriteIsar _favoriteIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteIsar();
  object.dateAdded = reader.readDateTime(offsets[0]);
  object.id = id;
  object.metadata = reader.readString(offsets[1]);
  object.reference = reader.readString(offsets[2]);
  object.textArabic = reader.readString(offsets[3]);
  object.typeIndex = reader.readLong(offsets[4]);
  object.uniqueKey = reader.readString(offsets[5]);
  return object;
}

P _favoriteIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteIsarGetId(FavoriteIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteIsarGetLinks(FavoriteIsar object) {
  return [];
}

void _favoriteIsarAttach(
    IsarCollection<dynamic> col, Id id, FavoriteIsar object) {
  object.id = id;
}

extension FavoriteIsarByIndex on IsarCollection<FavoriteIsar> {
  Future<FavoriteIsar?> getByUniqueKey(String uniqueKey) {
    return getByIndex(r'uniqueKey', [uniqueKey]);
  }

  FavoriteIsar? getByUniqueKeySync(String uniqueKey) {
    return getByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<bool> deleteByUniqueKey(String uniqueKey) {
    return deleteByIndex(r'uniqueKey', [uniqueKey]);
  }

  bool deleteByUniqueKeySync(String uniqueKey) {
    return deleteByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<List<FavoriteIsar?>> getAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'uniqueKey', values);
  }

  List<FavoriteIsar?> getAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uniqueKey', values);
  }

  Future<int> deleteAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uniqueKey', values);
  }

  int deleteAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uniqueKey', values);
  }

  Future<Id> putByUniqueKey(FavoriteIsar object) {
    return putByIndex(r'uniqueKey', object);
  }

  Id putByUniqueKeySync(FavoriteIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uniqueKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUniqueKey(List<FavoriteIsar> objects) {
    return putAllByIndex(r'uniqueKey', objects);
  }

  List<Id> putAllByUniqueKeySync(List<FavoriteIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uniqueKey', objects, saveLinks: saveLinks);
  }
}

extension FavoriteIsarQueryWhereSort
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QWhere> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteIsarQueryWhere
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QWhereClause> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause> uniqueKeyEqualTo(
      String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uniqueKey',
        value: [uniqueKey],
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterWhereClause>
      uniqueKeyNotEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FavoriteIsarQueryFilter
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QFilterCondition> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      dateAddedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      dateAddedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      metadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textArabic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textArabic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      textArabicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      typeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      typeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      typeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterFilterCondition>
      uniqueKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }
}

extension FavoriteIsarQueryObject
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QFilterCondition> {}

extension FavoriteIsarQueryLinks
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QFilterCondition> {}

extension FavoriteIsarQuerySortBy
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QSortBy> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByTextArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textArabic', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy>
      sortByTextArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textArabic', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> sortByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension FavoriteIsarQuerySortThenBy
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QSortThenBy> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByTextArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textArabic', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy>
      thenByTextArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textArabic', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.desc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QAfterSortBy> thenByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension FavoriteIsarQueryWhereDistinct
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> {
  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByMetadata(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadata', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByReference(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByTextArabic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textArabic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeIndex');
    });
  }

  QueryBuilder<FavoriteIsar, FavoriteIsar, QDistinct> distinctByUniqueKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueKey', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteIsarQueryProperty
    on QueryBuilder<FavoriteIsar, FavoriteIsar, QQueryProperty> {
  QueryBuilder<FavoriteIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteIsar, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<FavoriteIsar, String, QQueryOperations> metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadata');
    });
  }

  QueryBuilder<FavoriteIsar, String, QQueryOperations> referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<FavoriteIsar, String, QQueryOperations> textArabicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textArabic');
    });
  }

  QueryBuilder<FavoriteIsar, int, QQueryOperations> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeIndex');
    });
  }

  QueryBuilder<FavoriteIsar, String, QQueryOperations> uniqueKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookmarkIsarCollection on Isar {
  IsarCollection<BookmarkIsar> get bookmarkIsars => this.collection();
}

const BookmarkIsarSchema = CollectionSchema(
  name: r'BookmarkIsar',
  id: -4701838424608019184,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'data': PropertySchema(
      id: 1,
      name: r'data',
      type: IsarType.string,
    ),
    r'subtitle': PropertySchema(
      id: 2,
      name: r'subtitle',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    ),
    r'typeIndex': PropertySchema(
      id: 4,
      name: r'typeIndex',
      type: IsarType.long,
    ),
    r'uniqueKey': PropertySchema(
      id: 5,
      name: r'uniqueKey',
      type: IsarType.string,
    )
  },
  estimateSize: _bookmarkIsarEstimateSize,
  serialize: _bookmarkIsarSerialize,
  deserialize: _bookmarkIsarDeserialize,
  deserializeProp: _bookmarkIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uniqueKey': IndexSchema(
      id: -866995956150369819,
      name: r'uniqueKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uniqueKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bookmarkIsarGetId,
  getLinks: _bookmarkIsarGetLinks,
  attach: _bookmarkIsarAttach,
  version: '3.1.0+1',
);

int _bookmarkIsarEstimateSize(
  BookmarkIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.data.length * 3;
  bytesCount += 3 + object.subtitle.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uniqueKey.length * 3;
  return bytesCount;
}

void _bookmarkIsarSerialize(
  BookmarkIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.data);
  writer.writeString(offsets[2], object.subtitle);
  writer.writeString(offsets[3], object.title);
  writer.writeLong(offsets[4], object.typeIndex);
  writer.writeString(offsets[5], object.uniqueKey);
}

BookmarkIsar _bookmarkIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookmarkIsar();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.data = reader.readString(offsets[1]);
  object.id = id;
  object.subtitle = reader.readString(offsets[2]);
  object.title = reader.readString(offsets[3]);
  object.typeIndex = reader.readLong(offsets[4]);
  object.uniqueKey = reader.readString(offsets[5]);
  return object;
}

P _bookmarkIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookmarkIsarGetId(BookmarkIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookmarkIsarGetLinks(BookmarkIsar object) {
  return [];
}

void _bookmarkIsarAttach(
    IsarCollection<dynamic> col, Id id, BookmarkIsar object) {
  object.id = id;
}

extension BookmarkIsarByIndex on IsarCollection<BookmarkIsar> {
  Future<BookmarkIsar?> getByUniqueKey(String uniqueKey) {
    return getByIndex(r'uniqueKey', [uniqueKey]);
  }

  BookmarkIsar? getByUniqueKeySync(String uniqueKey) {
    return getByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<bool> deleteByUniqueKey(String uniqueKey) {
    return deleteByIndex(r'uniqueKey', [uniqueKey]);
  }

  bool deleteByUniqueKeySync(String uniqueKey) {
    return deleteByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<List<BookmarkIsar?>> getAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'uniqueKey', values);
  }

  List<BookmarkIsar?> getAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uniqueKey', values);
  }

  Future<int> deleteAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uniqueKey', values);
  }

  int deleteAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uniqueKey', values);
  }

  Future<Id> putByUniqueKey(BookmarkIsar object) {
    return putByIndex(r'uniqueKey', object);
  }

  Id putByUniqueKeySync(BookmarkIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uniqueKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUniqueKey(List<BookmarkIsar> objects) {
    return putAllByIndex(r'uniqueKey', objects);
  }

  List<Id> putAllByUniqueKeySync(List<BookmarkIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uniqueKey', objects, saveLinks: saveLinks);
  }
}

extension BookmarkIsarQueryWhereSort
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QWhere> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookmarkIsarQueryWhere
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QWhereClause> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause> uniqueKeyEqualTo(
      String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uniqueKey',
        value: [uniqueKey],
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterWhereClause>
      uniqueKeyNotEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BookmarkIsarQueryFilter
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QFilterCondition> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> dataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subtitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      typeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      typeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      typeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      typeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterFilterCondition>
      uniqueKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }
}

extension BookmarkIsarQueryObject
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QFilterCondition> {}

extension BookmarkIsarQueryLinks
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QFilterCondition> {}

extension BookmarkIsarQuerySortBy
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QSortBy> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> sortByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension BookmarkIsarQuerySortThenBy
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QSortThenBy> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeIndex', Sort.desc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QAfterSortBy> thenByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension BookmarkIsarQueryWhereDistinct
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> {
  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctBySubtitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctByTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeIndex');
    });
  }

  QueryBuilder<BookmarkIsar, BookmarkIsar, QDistinct> distinctByUniqueKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueKey', caseSensitive: caseSensitive);
    });
  }
}

extension BookmarkIsarQueryProperty
    on QueryBuilder<BookmarkIsar, BookmarkIsar, QQueryProperty> {
  QueryBuilder<BookmarkIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookmarkIsar, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BookmarkIsar, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<BookmarkIsar, String, QQueryOperations> subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<BookmarkIsar, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<BookmarkIsar, int, QQueryOperations> typeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeIndex');
    });
  }

  QueryBuilder<BookmarkIsar, String, QQueryOperations> uniqueKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingProgressIsarCollection on Isar {
  IsarCollection<ReadingProgressIsar> get readingProgressIsars =>
      this.collection();
}

const ReadingProgressIsarSchema = CollectionSchema(
  name: r'ReadingProgressIsar',
  id: -5623823050405138804,
  properties: {
    r'ayahNumber': PropertySchema(
      id: 0,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'bookId': PropertySchema(
      id: 1,
      name: r'bookId',
      type: IsarType.string,
    ),
    r'juz': PropertySchema(
      id: 2,
      name: r'juz',
      type: IsarType.long,
    ),
    r'page': PropertySchema(
      id: 3,
      name: r'page',
      type: IsarType.long,
    ),
    r'surahNumber': PropertySchema(
      id: 4,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _readingProgressIsarEstimateSize,
  serialize: _readingProgressIsarSerialize,
  deserialize: _readingProgressIsarDeserialize,
  deserializeProp: _readingProgressIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookId': IndexSchema(
      id: 3567540928881766442,
      name: r'bookId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'bookId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _readingProgressIsarGetId,
  getLinks: _readingProgressIsarGetLinks,
  attach: _readingProgressIsarAttach,
  version: '3.1.0+1',
);

int _readingProgressIsarEstimateSize(
  ReadingProgressIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookId.length * 3;
  return bytesCount;
}

void _readingProgressIsarSerialize(
  ReadingProgressIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahNumber);
  writer.writeString(offsets[1], object.bookId);
  writer.writeLong(offsets[2], object.juz);
  writer.writeLong(offsets[3], object.page);
  writer.writeLong(offsets[4], object.surahNumber);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

ReadingProgressIsar _readingProgressIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingProgressIsar();
  object.ayahNumber = reader.readLong(offsets[0]);
  object.bookId = reader.readString(offsets[1]);
  object.id = id;
  object.juz = reader.readLong(offsets[2]);
  object.page = reader.readLong(offsets[3]);
  object.surahNumber = reader.readLong(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _readingProgressIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingProgressIsarGetId(ReadingProgressIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingProgressIsarGetLinks(
    ReadingProgressIsar object) {
  return [];
}

void _readingProgressIsarAttach(
    IsarCollection<dynamic> col, Id id, ReadingProgressIsar object) {
  object.id = id;
}

extension ReadingProgressIsarByIndex on IsarCollection<ReadingProgressIsar> {
  Future<ReadingProgressIsar?> getByBookId(String bookId) {
    return getByIndex(r'bookId', [bookId]);
  }

  ReadingProgressIsar? getByBookIdSync(String bookId) {
    return getByIndexSync(r'bookId', [bookId]);
  }

  Future<bool> deleteByBookId(String bookId) {
    return deleteByIndex(r'bookId', [bookId]);
  }

  bool deleteByBookIdSync(String bookId) {
    return deleteByIndexSync(r'bookId', [bookId]);
  }

  Future<List<ReadingProgressIsar?>> getAllByBookId(List<String> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookId', values);
  }

  List<ReadingProgressIsar?> getAllByBookIdSync(List<String> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookId', values);
  }

  Future<int> deleteAllByBookId(List<String> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookId', values);
  }

  int deleteAllByBookIdSync(List<String> bookIdValues) {
    final values = bookIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookId', values);
  }

  Future<Id> putByBookId(ReadingProgressIsar object) {
    return putByIndex(r'bookId', object);
  }

  Id putByBookIdSync(ReadingProgressIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookId(List<ReadingProgressIsar> objects) {
    return putAllByIndex(r'bookId', objects);
  }

  List<Id> putAllByBookIdSync(List<ReadingProgressIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bookId', objects, saveLinks: saveLinks);
  }
}

extension ReadingProgressIsarQueryWhereSort
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QWhere> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReadingProgressIsarQueryWhere
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QWhereClause> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      bookIdEqualTo(String bookId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookId',
        value: [bookId],
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterWhereClause>
      bookIdNotEqualTo(String bookId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [],
              upper: [bookId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [bookId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [bookId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookId',
              lower: [],
              upper: [bookId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ReadingProgressIsarQueryFilter on QueryBuilder<ReadingProgressIsar,
    ReadingProgressIsar, QFilterCondition> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      ayahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      ayahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      bookIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      juzEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'juz',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      juzGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'juz',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      juzLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'juz',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      juzBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'juz',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      pageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      pageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      pageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      pageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'page',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingProgressIsarQueryObject on QueryBuilder<ReadingProgressIsar,
    ReadingProgressIsar, QFilterCondition> {}

extension ReadingProgressIsarQueryLinks on QueryBuilder<ReadingProgressIsar,
    ReadingProgressIsar, QFilterCondition> {}

extension ReadingProgressIsarQuerySortBy
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QSortBy> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByJuz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juz', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByJuzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juz', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReadingProgressIsarQuerySortThenBy
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QSortThenBy> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByJuz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juz', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByJuzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juz', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReadingProgressIsarQueryWhereDistinct
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct> {
  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctByBookId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctByJuz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'juz');
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'page');
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ReadingProgressIsarQueryProperty
    on QueryBuilder<ReadingProgressIsar, ReadingProgressIsar, QQueryProperty> {
  QueryBuilder<ReadingProgressIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingProgressIsar, int, QQueryOperations>
      ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<ReadingProgressIsar, String, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<ReadingProgressIsar, int, QQueryOperations> juzProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'juz');
    });
  }

  QueryBuilder<ReadingProgressIsar, int, QQueryOperations> pageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'page');
    });
  }

  QueryBuilder<ReadingProgressIsar, int, QQueryOperations>
      surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<ReadingProgressIsar, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKhatmahIsarCollection on Isar {
  IsarCollection<KhatmahIsar> get khatmahIsars => this.collection();
}

const KhatmahIsarSchema = CollectionSchema(
  name: r'KhatmahIsar',
  id: 581441550634020421,
  properties: {
    r'currentAyah': PropertySchema(
      id: 0,
      name: r'currentAyah',
      type: IsarType.long,
    ),
    r'currentPage': PropertySchema(
      id: 1,
      name: r'currentPage',
      type: IsarType.long,
    ),
    r'currentSurah': PropertySchema(
      id: 2,
      name: r'currentSurah',
      type: IsarType.long,
    ),
    r'lastReadDate': PropertySchema(
      id: 3,
      name: r'lastReadDate',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'readingStreakJson': PropertySchema(
      id: 5,
      name: r'readingStreakJson',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 6,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'totalAyahsRead': PropertySchema(
      id: 7,
      name: r'totalAyahsRead',
      type: IsarType.long,
    )
  },
  estimateSize: _khatmahIsarEstimateSize,
  serialize: _khatmahIsarSerialize,
  deserialize: _khatmahIsarDeserialize,
  deserializeProp: _khatmahIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _khatmahIsarGetId,
  getLinks: _khatmahIsarGetLinks,
  attach: _khatmahIsarAttach,
  version: '3.1.0+1',
);

int _khatmahIsarEstimateSize(
  KhatmahIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.readingStreakJson.length * 3;
  return bytesCount;
}

void _khatmahIsarSerialize(
  KhatmahIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentAyah);
  writer.writeLong(offsets[1], object.currentPage);
  writer.writeLong(offsets[2], object.currentSurah);
  writer.writeDateTime(offsets[3], object.lastReadDate);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.readingStreakJson);
  writer.writeDateTime(offsets[6], object.startDate);
  writer.writeLong(offsets[7], object.totalAyahsRead);
}

KhatmahIsar _khatmahIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KhatmahIsar();
  object.currentAyah = reader.readLong(offsets[0]);
  object.currentPage = reader.readLong(offsets[1]);
  object.currentSurah = reader.readLong(offsets[2]);
  object.id = id;
  object.lastReadDate = reader.readDateTime(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.readingStreakJson = reader.readString(offsets[5]);
  object.startDate = reader.readDateTime(offsets[6]);
  object.totalAyahsRead = reader.readLong(offsets[7]);
  return object;
}

P _khatmahIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _khatmahIsarGetId(KhatmahIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _khatmahIsarGetLinks(KhatmahIsar object) {
  return [];
}

void _khatmahIsarAttach(
    IsarCollection<dynamic> col, Id id, KhatmahIsar object) {
  object.id = id;
}

extension KhatmahIsarQueryWhereSort
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QWhere> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KhatmahIsarQueryWhere
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QWhereClause> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension KhatmahIsarQueryFilter
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QFilterCondition> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentAyahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentAyahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentAyahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentAyahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentAyah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentSurahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentSurah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentSurahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentSurah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentSurahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentSurah',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      currentSurahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentSurah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      lastReadDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      lastReadDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      lastReadDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      lastReadDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingStreakJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'readingStreakJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'readingStreakJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingStreakJson',
        value: '',
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      readingStreakJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'readingStreakJson',
        value: '',
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      totalAyahsReadEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAyahsRead',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      totalAyahsReadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAyahsRead',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      totalAyahsReadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAyahsRead',
        value: value,
      ));
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterFilterCondition>
      totalAyahsReadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAyahsRead',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension KhatmahIsarQueryObject
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QFilterCondition> {}

extension KhatmahIsarQueryLinks
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QFilterCondition> {}

extension KhatmahIsarQuerySortBy
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QSortBy> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByCurrentAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAyah', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByCurrentAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAyah', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByCurrentSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurah', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      sortByCurrentSurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurah', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      sortByLastReadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      sortByReadingStreakJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingStreakJson', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      sortByReadingStreakJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingStreakJson', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> sortByTotalAyahsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahsRead', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      sortByTotalAyahsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahsRead', Sort.desc);
    });
  }
}

extension KhatmahIsarQuerySortThenBy
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QSortThenBy> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByCurrentAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAyah', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByCurrentAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAyah', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByCurrentSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurah', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      thenByCurrentSurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurah', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      thenByLastReadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      thenByReadingStreakJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingStreakJson', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      thenByReadingStreakJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingStreakJson', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy> thenByTotalAyahsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahsRead', Sort.asc);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QAfterSortBy>
      thenByTotalAyahsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahsRead', Sort.desc);
    });
  }
}

extension KhatmahIsarQueryWhereDistinct
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> {
  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByCurrentAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentAyah');
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPage');
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByCurrentSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentSurah');
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadDate');
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByReadingStreakJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingStreakJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<KhatmahIsar, KhatmahIsar, QDistinct> distinctByTotalAyahsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAyahsRead');
    });
  }
}

extension KhatmahIsarQueryProperty
    on QueryBuilder<KhatmahIsar, KhatmahIsar, QQueryProperty> {
  QueryBuilder<KhatmahIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KhatmahIsar, int, QQueryOperations> currentAyahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentAyah');
    });
  }

  QueryBuilder<KhatmahIsar, int, QQueryOperations> currentPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPage');
    });
  }

  QueryBuilder<KhatmahIsar, int, QQueryOperations> currentSurahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentSurah');
    });
  }

  QueryBuilder<KhatmahIsar, DateTime, QQueryOperations> lastReadDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadDate');
    });
  }

  QueryBuilder<KhatmahIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<KhatmahIsar, String, QQueryOperations>
      readingStreakJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingStreakJson');
    });
  }

  QueryBuilder<KhatmahIsar, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<KhatmahIsar, int, QQueryOperations> totalAyahsReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAyahsRead');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTasbeehIsarCollection on Isar {
  IsarCollection<TasbeehIsar> get tasbeehIsars => this.collection();
}

const TasbeehIsarSchema = CollectionSchema(
  name: r'TasbeehIsar',
  id: -1655797404575099364,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'lastUsed': PropertySchema(
      id: 1,
      name: r'lastUsed',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'nameArabic': PropertySchema(
      id: 3,
      name: r'nameArabic',
      type: IsarType.string,
    ),
    r'target': PropertySchema(
      id: 4,
      name: r'target',
      type: IsarType.long,
    ),
    r'uniqueKey': PropertySchema(
      id: 5,
      name: r'uniqueKey',
      type: IsarType.string,
    )
  },
  estimateSize: _tasbeehIsarEstimateSize,
  serialize: _tasbeehIsarSerialize,
  deserialize: _tasbeehIsarDeserialize,
  deserializeProp: _tasbeehIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uniqueKey': IndexSchema(
      id: -866995956150369819,
      name: r'uniqueKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uniqueKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tasbeehIsarGetId,
  getLinks: _tasbeehIsarGetLinks,
  attach: _tasbeehIsarAttach,
  version: '3.1.0+1',
);

int _tasbeehIsarEstimateSize(
  TasbeehIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.nameArabic.length * 3;
  bytesCount += 3 + object.uniqueKey.length * 3;
  return bytesCount;
}

void _tasbeehIsarSerialize(
  TasbeehIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeDateTime(offsets[1], object.lastUsed);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.nameArabic);
  writer.writeLong(offsets[4], object.target);
  writer.writeString(offsets[5], object.uniqueKey);
}

TasbeehIsar _tasbeehIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TasbeehIsar();
  object.count = reader.readLong(offsets[0]);
  object.id = id;
  object.lastUsed = reader.readDateTime(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.nameArabic = reader.readString(offsets[3]);
  object.target = reader.readLong(offsets[4]);
  object.uniqueKey = reader.readString(offsets[5]);
  return object;
}

P _tasbeehIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tasbeehIsarGetId(TasbeehIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tasbeehIsarGetLinks(TasbeehIsar object) {
  return [];
}

void _tasbeehIsarAttach(
    IsarCollection<dynamic> col, Id id, TasbeehIsar object) {
  object.id = id;
}

extension TasbeehIsarByIndex on IsarCollection<TasbeehIsar> {
  Future<TasbeehIsar?> getByUniqueKey(String uniqueKey) {
    return getByIndex(r'uniqueKey', [uniqueKey]);
  }

  TasbeehIsar? getByUniqueKeySync(String uniqueKey) {
    return getByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<bool> deleteByUniqueKey(String uniqueKey) {
    return deleteByIndex(r'uniqueKey', [uniqueKey]);
  }

  bool deleteByUniqueKeySync(String uniqueKey) {
    return deleteByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<List<TasbeehIsar?>> getAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'uniqueKey', values);
  }

  List<TasbeehIsar?> getAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uniqueKey', values);
  }

  Future<int> deleteAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uniqueKey', values);
  }

  int deleteAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uniqueKey', values);
  }

  Future<Id> putByUniqueKey(TasbeehIsar object) {
    return putByIndex(r'uniqueKey', object);
  }

  Id putByUniqueKeySync(TasbeehIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uniqueKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUniqueKey(List<TasbeehIsar> objects) {
    return putAllByIndex(r'uniqueKey', objects);
  }

  List<Id> putAllByUniqueKeySync(List<TasbeehIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uniqueKey', objects, saveLinks: saveLinks);
  }
}

extension TasbeehIsarQueryWhereSort
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QWhere> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TasbeehIsarQueryWhere
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QWhereClause> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> uniqueKeyEqualTo(
      String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uniqueKey',
        value: [uniqueKey],
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterWhereClause> uniqueKeyNotEqualTo(
      String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TasbeehIsarQueryFilter
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QFilterCondition> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> countEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> lastUsedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      lastUsedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      lastUsedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> lastUsedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameArabic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameArabic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      nameArabicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> targetEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      targetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> targetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition> targetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'target',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterFilterCondition>
      uniqueKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }
}

extension TasbeehIsarQueryObject
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QFilterCondition> {}

extension TasbeehIsarQueryLinks
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QFilterCondition> {}

extension TasbeehIsarQuerySortBy
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QSortBy> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> sortByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension TasbeehIsarQuerySortThenBy
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QSortThenBy> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QAfterSortBy> thenByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension TasbeehIsarQueryWhereDistinct
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> {
  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByNameArabic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameArabic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'target');
    });
  }

  QueryBuilder<TasbeehIsar, TasbeehIsar, QDistinct> distinctByUniqueKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueKey', caseSensitive: caseSensitive);
    });
  }
}

extension TasbeehIsarQueryProperty
    on QueryBuilder<TasbeehIsar, TasbeehIsar, QQueryProperty> {
  QueryBuilder<TasbeehIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TasbeehIsar, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<TasbeehIsar, DateTime, QQueryOperations> lastUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsed');
    });
  }

  QueryBuilder<TasbeehIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TasbeehIsar, String, QQueryOperations> nameArabicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameArabic');
    });
  }

  QueryBuilder<TasbeehIsar, int, QQueryOperations> targetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'target');
    });
  }

  QueryBuilder<TasbeehIsar, String, QQueryOperations> uniqueKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAdhkarStateIsarCollection on Isar {
  IsarCollection<AdhkarStateIsar> get adhkarStateIsars => this.collection();
}

const AdhkarStateIsarSchema = CollectionSchema(
  name: r'AdhkarStateIsar',
  id: -928763783656652260,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'currentCount': PropertySchema(
      id: 1,
      name: r'currentCount',
      type: IsarType.long,
    ),
    r'dhikrId': PropertySchema(
      id: 2,
      name: r'dhikrId',
      type: IsarType.string,
    ),
    r'isFavorite': PropertySchema(
      id: 3,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'uniqueKey': PropertySchema(
      id: 4,
      name: r'uniqueKey',
      type: IsarType.string,
    )
  },
  estimateSize: _adhkarStateIsarEstimateSize,
  serialize: _adhkarStateIsarSerialize,
  deserialize: _adhkarStateIsarDeserialize,
  deserializeProp: _adhkarStateIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uniqueKey': IndexSchema(
      id: -866995956150369819,
      name: r'uniqueKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uniqueKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _adhkarStateIsarGetId,
  getLinks: _adhkarStateIsarGetLinks,
  attach: _adhkarStateIsarAttach,
  version: '3.1.0+1',
);

int _adhkarStateIsarEstimateSize(
  AdhkarStateIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryId.length * 3;
  bytesCount += 3 + object.dhikrId.length * 3;
  bytesCount += 3 + object.uniqueKey.length * 3;
  return bytesCount;
}

void _adhkarStateIsarSerialize(
  AdhkarStateIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryId);
  writer.writeLong(offsets[1], object.currentCount);
  writer.writeString(offsets[2], object.dhikrId);
  writer.writeBool(offsets[3], object.isFavorite);
  writer.writeString(offsets[4], object.uniqueKey);
}

AdhkarStateIsar _adhkarStateIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AdhkarStateIsar();
  object.categoryId = reader.readString(offsets[0]);
  object.currentCount = reader.readLong(offsets[1]);
  object.dhikrId = reader.readString(offsets[2]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[3]);
  object.uniqueKey = reader.readString(offsets[4]);
  return object;
}

P _adhkarStateIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _adhkarStateIsarGetId(AdhkarStateIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _adhkarStateIsarGetLinks(AdhkarStateIsar object) {
  return [];
}

void _adhkarStateIsarAttach(
    IsarCollection<dynamic> col, Id id, AdhkarStateIsar object) {
  object.id = id;
}

extension AdhkarStateIsarByIndex on IsarCollection<AdhkarStateIsar> {
  Future<AdhkarStateIsar?> getByUniqueKey(String uniqueKey) {
    return getByIndex(r'uniqueKey', [uniqueKey]);
  }

  AdhkarStateIsar? getByUniqueKeySync(String uniqueKey) {
    return getByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<bool> deleteByUniqueKey(String uniqueKey) {
    return deleteByIndex(r'uniqueKey', [uniqueKey]);
  }

  bool deleteByUniqueKeySync(String uniqueKey) {
    return deleteByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<List<AdhkarStateIsar?>> getAllByUniqueKey(
      List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'uniqueKey', values);
  }

  List<AdhkarStateIsar?> getAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uniqueKey', values);
  }

  Future<int> deleteAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uniqueKey', values);
  }

  int deleteAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uniqueKey', values);
  }

  Future<Id> putByUniqueKey(AdhkarStateIsar object) {
    return putByIndex(r'uniqueKey', object);
  }

  Id putByUniqueKeySync(AdhkarStateIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uniqueKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUniqueKey(List<AdhkarStateIsar> objects) {
    return putAllByIndex(r'uniqueKey', objects);
  }

  List<Id> putAllByUniqueKeySync(List<AdhkarStateIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uniqueKey', objects, saveLinks: saveLinks);
  }
}

extension AdhkarStateIsarQueryWhereSort
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QWhere> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AdhkarStateIsarQueryWhere
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QWhereClause> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause>
      uniqueKeyEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uniqueKey',
        value: [uniqueKey],
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterWhereClause>
      uniqueKeyNotEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AdhkarStateIsarQueryFilter
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QFilterCondition> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      currentCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      currentCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      currentCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      currentCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dhikrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dhikrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dhikrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dhikrId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      dhikrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dhikrId',
        value: '',
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterFilterCondition>
      uniqueKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }
}

extension AdhkarStateIsarQueryObject
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QFilterCondition> {}

extension AdhkarStateIsarQueryLinks
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QFilterCondition> {}

extension AdhkarStateIsarQuerySortBy
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QSortBy> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByCurrentCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCount', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByCurrentCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCount', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy> sortByDhikrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByDhikrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      sortByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension AdhkarStateIsarQuerySortThenBy
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QSortThenBy> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByCurrentCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCount', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByCurrentCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCount', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy> thenByDhikrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByDhikrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QAfterSortBy>
      thenByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension AdhkarStateIsarQueryWhereDistinct
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct> {
  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct>
      distinctByCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct>
      distinctByCurrentCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentCount');
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct> distinctByDhikrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhikrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct>
      distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QDistinct> distinctByUniqueKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueKey', caseSensitive: caseSensitive);
    });
  }
}

extension AdhkarStateIsarQueryProperty
    on QueryBuilder<AdhkarStateIsar, AdhkarStateIsar, QQueryProperty> {
  QueryBuilder<AdhkarStateIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AdhkarStateIsar, String, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<AdhkarStateIsar, int, QQueryOperations> currentCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentCount');
    });
  }

  QueryBuilder<AdhkarStateIsar, String, QQueryOperations> dhikrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhikrId');
    });
  }

  QueryBuilder<AdhkarStateIsar, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<AdhkarStateIsar, String, QQueryOperations> uniqueKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerTimesCacheIsarCollection on Isar {
  IsarCollection<PrayerTimesCacheIsar> get prayerTimesCacheIsars =>
      this.collection();
}

const PrayerTimesCacheIsarSchema = CollectionSchema(
  name: r'PrayerTimesCacheIsar',
  id: 8331582666904038163,
  properties: {
    r'dateLocationKey': PropertySchema(
      id: 0,
      name: r'dateLocationKey',
      type: IsarType.string,
    ),
    r'fetchedAt': PropertySchema(
      id: 1,
      name: r'fetchedAt',
      type: IsarType.dateTime,
    ),
    r'fullJson': PropertySchema(
      id: 2,
      name: r'fullJson',
      type: IsarType.string,
    )
  },
  estimateSize: _prayerTimesCacheIsarEstimateSize,
  serialize: _prayerTimesCacheIsarSerialize,
  deserialize: _prayerTimesCacheIsarDeserialize,
  deserializeProp: _prayerTimesCacheIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateLocationKey': IndexSchema(
      id: 4390339905043235941,
      name: r'dateLocationKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dateLocationKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _prayerTimesCacheIsarGetId,
  getLinks: _prayerTimesCacheIsarGetLinks,
  attach: _prayerTimesCacheIsarAttach,
  version: '3.1.0+1',
);

int _prayerTimesCacheIsarEstimateSize(
  PrayerTimesCacheIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateLocationKey.length * 3;
  bytesCount += 3 + object.fullJson.length * 3;
  return bytesCount;
}

void _prayerTimesCacheIsarSerialize(
  PrayerTimesCacheIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dateLocationKey);
  writer.writeDateTime(offsets[1], object.fetchedAt);
  writer.writeString(offsets[2], object.fullJson);
}

PrayerTimesCacheIsar _prayerTimesCacheIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerTimesCacheIsar();
  object.dateLocationKey = reader.readString(offsets[0]);
  object.fetchedAt = reader.readDateTime(offsets[1]);
  object.fullJson = reader.readString(offsets[2]);
  object.id = id;
  return object;
}

P _prayerTimesCacheIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _prayerTimesCacheIsarGetId(PrayerTimesCacheIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerTimesCacheIsarGetLinks(
    PrayerTimesCacheIsar object) {
  return [];
}

void _prayerTimesCacheIsarAttach(
    IsarCollection<dynamic> col, Id id, PrayerTimesCacheIsar object) {
  object.id = id;
}

extension PrayerTimesCacheIsarByIndex on IsarCollection<PrayerTimesCacheIsar> {
  Future<PrayerTimesCacheIsar?> getByDateLocationKey(String dateLocationKey) {
    return getByIndex(r'dateLocationKey', [dateLocationKey]);
  }

  PrayerTimesCacheIsar? getByDateLocationKeySync(String dateLocationKey) {
    return getByIndexSync(r'dateLocationKey', [dateLocationKey]);
  }

  Future<bool> deleteByDateLocationKey(String dateLocationKey) {
    return deleteByIndex(r'dateLocationKey', [dateLocationKey]);
  }

  bool deleteByDateLocationKeySync(String dateLocationKey) {
    return deleteByIndexSync(r'dateLocationKey', [dateLocationKey]);
  }

  Future<List<PrayerTimesCacheIsar?>> getAllByDateLocationKey(
      List<String> dateLocationKeyValues) {
    final values = dateLocationKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateLocationKey', values);
  }

  List<PrayerTimesCacheIsar?> getAllByDateLocationKeySync(
      List<String> dateLocationKeyValues) {
    final values = dateLocationKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dateLocationKey', values);
  }

  Future<int> deleteAllByDateLocationKey(List<String> dateLocationKeyValues) {
    final values = dateLocationKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dateLocationKey', values);
  }

  int deleteAllByDateLocationKeySync(List<String> dateLocationKeyValues) {
    final values = dateLocationKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dateLocationKey', values);
  }

  Future<Id> putByDateLocationKey(PrayerTimesCacheIsar object) {
    return putByIndex(r'dateLocationKey', object);
  }

  Id putByDateLocationKeySync(PrayerTimesCacheIsar object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'dateLocationKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateLocationKey(List<PrayerTimesCacheIsar> objects) {
    return putAllByIndex(r'dateLocationKey', objects);
  }

  List<Id> putAllByDateLocationKeySync(List<PrayerTimesCacheIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'dateLocationKey', objects, saveLinks: saveLinks);
  }
}

extension PrayerTimesCacheIsarQueryWhereSort
    on QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QWhere> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PrayerTimesCacheIsarQueryWhere
    on QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QWhereClause> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      dateLocationKeyEqualTo(String dateLocationKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateLocationKey',
        value: [dateLocationKey],
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterWhereClause>
      dateLocationKeyNotEqualTo(String dateLocationKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateLocationKey',
              lower: [],
              upper: [dateLocationKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateLocationKey',
              lower: [dateLocationKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateLocationKey',
              lower: [dateLocationKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateLocationKey',
              lower: [],
              upper: [dateLocationKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PrayerTimesCacheIsarQueryFilter on QueryBuilder<PrayerTimesCacheIsar,
    PrayerTimesCacheIsar, QFilterCondition> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateLocationKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
          QAfterFilterCondition>
      dateLocationKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateLocationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
          QAfterFilterCondition>
      dateLocationKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateLocationKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateLocationKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> dateLocationKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateLocationKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fetchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fetchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
          QAfterFilterCondition>
      fullJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
          QAfterFilterCondition>
      fullJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> fullJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PrayerTimesCacheIsarQueryObject on QueryBuilder<PrayerTimesCacheIsar,
    PrayerTimesCacheIsar, QFilterCondition> {}

extension PrayerTimesCacheIsarQueryLinks on QueryBuilder<PrayerTimesCacheIsar,
    PrayerTimesCacheIsar, QFilterCondition> {}

extension PrayerTimesCacheIsarQuerySortBy
    on QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QSortBy> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByDateLocationKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLocationKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByDateLocationKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLocationKey', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByFullJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      sortByFullJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullJson', Sort.desc);
    });
  }
}

extension PrayerTimesCacheIsarQuerySortThenBy
    on QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QSortThenBy> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByDateLocationKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLocationKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByDateLocationKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLocationKey', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByFullJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByFullJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullJson', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PrayerTimesCacheIsarQueryWhereDistinct
    on QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QDistinct> {
  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QDistinct>
      distinctByDateLocationKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateLocationKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QDistinct>
      distinctByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt');
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, PrayerTimesCacheIsar, QDistinct>
      distinctByFullJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullJson', caseSensitive: caseSensitive);
    });
  }
}

extension PrayerTimesCacheIsarQueryProperty on QueryBuilder<
    PrayerTimesCacheIsar, PrayerTimesCacheIsar, QQueryProperty> {
  QueryBuilder<PrayerTimesCacheIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, String, QQueryOperations>
      dateLocationKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateLocationKey');
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, DateTime, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<PrayerTimesCacheIsar, String, QQueryOperations>
      fullJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullJson');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCacheEntryIsarCollection on Isar {
  IsarCollection<CacheEntryIsar> get cacheEntryIsars => this.collection();
}

const CacheEntryIsarSchema = CollectionSchema(
  name: r'CacheEntryIsar',
  id: -9131699943223083888,
  properties: {
    r'cacheKey': PropertySchema(
      id: 0,
      name: r'cacheKey',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'data': PropertySchema(
      id: 2,
      name: r'data',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 3,
      name: r'expiresAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _cacheEntryIsarEstimateSize,
  serialize: _cacheEntryIsarSerialize,
  deserialize: _cacheEntryIsarDeserialize,
  deserializeProp: _cacheEntryIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheKey': IndexSchema(
      id: 5885332021012296610,
      name: r'cacheKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'cacheKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cacheEntryIsarGetId,
  getLinks: _cacheEntryIsarGetLinks,
  attach: _cacheEntryIsarAttach,
  version: '3.1.0+1',
);

int _cacheEntryIsarEstimateSize(
  CacheEntryIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheKey.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.data.length * 3;
  return bytesCount;
}

void _cacheEntryIsarSerialize(
  CacheEntryIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheKey);
  writer.writeString(offsets[1], object.category);
  writer.writeString(offsets[2], object.data);
  writer.writeDateTime(offsets[3], object.expiresAt);
}

CacheEntryIsar _cacheEntryIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CacheEntryIsar();
  object.cacheKey = reader.readString(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.data = reader.readString(offsets[2]);
  object.expiresAt = reader.readDateTime(offsets[3]);
  object.id = id;
  return object;
}

P _cacheEntryIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cacheEntryIsarGetId(CacheEntryIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cacheEntryIsarGetLinks(CacheEntryIsar object) {
  return [];
}

void _cacheEntryIsarAttach(
    IsarCollection<dynamic> col, Id id, CacheEntryIsar object) {
  object.id = id;
}

extension CacheEntryIsarByIndex on IsarCollection<CacheEntryIsar> {
  Future<CacheEntryIsar?> getByCacheKey(String cacheKey) {
    return getByIndex(r'cacheKey', [cacheKey]);
  }

  CacheEntryIsar? getByCacheKeySync(String cacheKey) {
    return getByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<bool> deleteByCacheKey(String cacheKey) {
    return deleteByIndex(r'cacheKey', [cacheKey]);
  }

  bool deleteByCacheKeySync(String cacheKey) {
    return deleteByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<List<CacheEntryIsar?>> getAllByCacheKey(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheKey', values);
  }

  List<CacheEntryIsar?> getAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheKey', values);
  }

  Future<int> deleteAllByCacheKey(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheKey', values);
  }

  int deleteAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheKey', values);
  }

  Future<Id> putByCacheKey(CacheEntryIsar object) {
    return putByIndex(r'cacheKey', object);
  }

  Id putByCacheKeySync(CacheEntryIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'cacheKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheKey(List<CacheEntryIsar> objects) {
    return putAllByIndex(r'cacheKey', objects);
  }

  List<Id> putAllByCacheKeySync(List<CacheEntryIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheKey', objects, saveLinks: saveLinks);
  }
}

extension CacheEntryIsarQueryWhereSort
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QWhere> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CacheEntryIsarQueryWhere
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QWhereClause> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause>
      cacheKeyEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheKey',
        value: [cacheKey],
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterWhereClause>
      cacheKeyNotEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CacheEntryIsarQueryFilter
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QFilterCondition> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      cacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      expiresAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      expiresAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CacheEntryIsarQueryObject
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QFilterCondition> {}

extension CacheEntryIsarQueryLinks
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QFilterCondition> {}

extension CacheEntryIsarQuerySortBy
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QSortBy> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> sortByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      sortByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }
}

extension CacheEntryIsarQuerySortThenBy
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QSortThenBy> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      thenByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CacheEntryIsarQueryWhereDistinct
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QDistinct> {
  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QDistinct> distinctByCacheKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheEntryIsar, CacheEntryIsar, QDistinct>
      distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }
}

extension CacheEntryIsarQueryProperty
    on QueryBuilder<CacheEntryIsar, CacheEntryIsar, QQueryProperty> {
  QueryBuilder<CacheEntryIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CacheEntryIsar, String, QQueryOperations> cacheKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheKey');
    });
  }

  QueryBuilder<CacheEntryIsar, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<CacheEntryIsar, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<CacheEntryIsar, DateTime, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAudioStateIsarCollection on Isar {
  IsarCollection<AudioStateIsar> get audioStateIsars => this.collection();
}

const AudioStateIsarSchema = CollectionSchema(
  name: r'AudioStateIsar',
  id: -1737566501300132077,
  properties: {
    r'currentSurahNumber': PropertySchema(
      id: 0,
      name: r'currentSurahNumber',
      type: IsarType.long,
    ),
    r'moshafId': PropertySchema(
      id: 1,
      name: r'moshafId',
      type: IsarType.string,
    ),
    r'positionMs': PropertySchema(
      id: 2,
      name: r'positionMs',
      type: IsarType.long,
    ),
    r'queueJson': PropertySchema(
      id: 3,
      name: r'queueJson',
      type: IsarType.string,
    ),
    r'reciterId': PropertySchema(
      id: 4,
      name: r'reciterId',
      type: IsarType.string,
    ),
    r'reciterName': PropertySchema(
      id: 5,
      name: r'reciterName',
      type: IsarType.string,
    ),
    r'server': PropertySchema(
      id: 6,
      name: r'server',
      type: IsarType.string,
    ),
    r'speed': PropertySchema(
      id: 7,
      name: r'speed',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _audioStateIsarEstimateSize,
  serialize: _audioStateIsarSerialize,
  deserialize: _audioStateIsarDeserialize,
  deserializeProp: _audioStateIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _audioStateIsarGetId,
  getLinks: _audioStateIsarGetLinks,
  attach: _audioStateIsarAttach,
  version: '3.1.0+1',
);

int _audioStateIsarEstimateSize(
  AudioStateIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.moshafId.length * 3;
  bytesCount += 3 + object.queueJson.length * 3;
  bytesCount += 3 + object.reciterId.length * 3;
  bytesCount += 3 + object.reciterName.length * 3;
  bytesCount += 3 + object.server.length * 3;
  return bytesCount;
}

void _audioStateIsarSerialize(
  AudioStateIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentSurahNumber);
  writer.writeString(offsets[1], object.moshafId);
  writer.writeLong(offsets[2], object.positionMs);
  writer.writeString(offsets[3], object.queueJson);
  writer.writeString(offsets[4], object.reciterId);
  writer.writeString(offsets[5], object.reciterName);
  writer.writeString(offsets[6], object.server);
  writer.writeDouble(offsets[7], object.speed);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

AudioStateIsar _audioStateIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AudioStateIsar();
  object.currentSurahNumber = reader.readLong(offsets[0]);
  object.id = id;
  object.moshafId = reader.readString(offsets[1]);
  object.positionMs = reader.readLong(offsets[2]);
  object.queueJson = reader.readString(offsets[3]);
  object.reciterId = reader.readString(offsets[4]);
  object.reciterName = reader.readString(offsets[5]);
  object.server = reader.readString(offsets[6]);
  object.speed = reader.readDouble(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _audioStateIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _audioStateIsarGetId(AudioStateIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _audioStateIsarGetLinks(AudioStateIsar object) {
  return [];
}

void _audioStateIsarAttach(
    IsarCollection<dynamic> col, Id id, AudioStateIsar object) {
  object.id = id;
}

extension AudioStateIsarQueryWhereSort
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QWhere> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AudioStateIsarQueryWhere
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QWhereClause> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AudioStateIsarQueryFilter
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QFilterCondition> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      currentSurahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentSurahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      currentSurahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentSurahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      currentSurahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentSurahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      currentSurahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentSurahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moshafId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moshafId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moshafId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moshafId',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      moshafIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moshafId',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      positionMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      positionMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      positionMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      positionMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'queueJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'queueJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'queueJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queueJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      queueJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'queueJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reciterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reciterId',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reciterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reciterName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterName',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      reciterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reciterName',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'server',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'server',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'server',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      serverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'server',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      speedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      speedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      speedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      speedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AudioStateIsarQueryObject
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QFilterCondition> {}

extension AudioStateIsarQueryLinks
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QFilterCondition> {}

extension AudioStateIsarQuerySortBy
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QSortBy> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByCurrentSurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurahNumber', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByCurrentSurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurahNumber', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortByMoshafId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moshafId', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByMoshafIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moshafId', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortByQueueJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueJson', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByQueueJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueJson', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByReciterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterName', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByReciterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterName', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AudioStateIsarQuerySortThenBy
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QSortThenBy> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByCurrentSurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurahNumber', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByCurrentSurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSurahNumber', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByMoshafId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moshafId', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByMoshafIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moshafId', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByQueueJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueJson', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByQueueJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueJson', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByReciterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterName', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByReciterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterName', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AudioStateIsarQueryWhereDistinct
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> {
  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct>
      distinctByCurrentSurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentSurahNumber');
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctByMoshafId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moshafId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct>
      distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctByQueueJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queueJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctByReciterId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctByReciterName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctByServer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'server', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct> distinctBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speed');
    });
  }

  QueryBuilder<AudioStateIsar, AudioStateIsar, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AudioStateIsarQueryProperty
    on QueryBuilder<AudioStateIsar, AudioStateIsar, QQueryProperty> {
  QueryBuilder<AudioStateIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AudioStateIsar, int, QQueryOperations>
      currentSurahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentSurahNumber');
    });
  }

  QueryBuilder<AudioStateIsar, String, QQueryOperations> moshafIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moshafId');
    });
  }

  QueryBuilder<AudioStateIsar, int, QQueryOperations> positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }

  QueryBuilder<AudioStateIsar, String, QQueryOperations> queueJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queueJson');
    });
  }

  QueryBuilder<AudioStateIsar, String, QQueryOperations> reciterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterId');
    });
  }

  QueryBuilder<AudioStateIsar, String, QQueryOperations> reciterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterName');
    });
  }

  QueryBuilder<AudioStateIsar, String, QQueryOperations> serverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'server');
    });
  }

  QueryBuilder<AudioStateIsar, double, QQueryOperations> speedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speed');
    });
  }

  QueryBuilder<AudioStateIsar, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentlyPlayedIsarCollection on Isar {
  IsarCollection<RecentlyPlayedIsar> get recentlyPlayedIsars =>
      this.collection();
}

const RecentlyPlayedIsarSchema = CollectionSchema(
  name: r'RecentlyPlayedIsar',
  id: 3208163948492662704,
  properties: {
    r'data': PropertySchema(
      id: 0,
      name: r'data',
      type: IsarType.string,
    ),
    r'lastPlayed': PropertySchema(
      id: 1,
      name: r'lastPlayed',
      type: IsarType.dateTime,
    ),
    r'reciterId': PropertySchema(
      id: 2,
      name: r'reciterId',
      type: IsarType.string,
    )
  },
  estimateSize: _recentlyPlayedIsarEstimateSize,
  serialize: _recentlyPlayedIsarSerialize,
  deserialize: _recentlyPlayedIsarDeserialize,
  deserializeProp: _recentlyPlayedIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'reciterId': IndexSchema(
      id: -5029838260836744949,
      name: r'reciterId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'reciterId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recentlyPlayedIsarGetId,
  getLinks: _recentlyPlayedIsarGetLinks,
  attach: _recentlyPlayedIsarAttach,
  version: '3.1.0+1',
);

int _recentlyPlayedIsarEstimateSize(
  RecentlyPlayedIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.data.length * 3;
  bytesCount += 3 + object.reciterId.length * 3;
  return bytesCount;
}

void _recentlyPlayedIsarSerialize(
  RecentlyPlayedIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.data);
  writer.writeDateTime(offsets[1], object.lastPlayed);
  writer.writeString(offsets[2], object.reciterId);
}

RecentlyPlayedIsar _recentlyPlayedIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentlyPlayedIsar();
  object.data = reader.readString(offsets[0]);
  object.id = id;
  object.lastPlayed = reader.readDateTime(offsets[1]);
  object.reciterId = reader.readString(offsets[2]);
  return object;
}

P _recentlyPlayedIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentlyPlayedIsarGetId(RecentlyPlayedIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentlyPlayedIsarGetLinks(
    RecentlyPlayedIsar object) {
  return [];
}

void _recentlyPlayedIsarAttach(
    IsarCollection<dynamic> col, Id id, RecentlyPlayedIsar object) {
  object.id = id;
}

extension RecentlyPlayedIsarByIndex on IsarCollection<RecentlyPlayedIsar> {
  Future<RecentlyPlayedIsar?> getByReciterId(String reciterId) {
    return getByIndex(r'reciterId', [reciterId]);
  }

  RecentlyPlayedIsar? getByReciterIdSync(String reciterId) {
    return getByIndexSync(r'reciterId', [reciterId]);
  }

  Future<bool> deleteByReciterId(String reciterId) {
    return deleteByIndex(r'reciterId', [reciterId]);
  }

  bool deleteByReciterIdSync(String reciterId) {
    return deleteByIndexSync(r'reciterId', [reciterId]);
  }

  Future<List<RecentlyPlayedIsar?>> getAllByReciterId(
      List<String> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'reciterId', values);
  }

  List<RecentlyPlayedIsar?> getAllByReciterIdSync(
      List<String> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reciterId', values);
  }

  Future<int> deleteAllByReciterId(List<String> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reciterId', values);
  }

  int deleteAllByReciterIdSync(List<String> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reciterId', values);
  }

  Future<Id> putByReciterId(RecentlyPlayedIsar object) {
    return putByIndex(r'reciterId', object);
  }

  Id putByReciterIdSync(RecentlyPlayedIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'reciterId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReciterId(List<RecentlyPlayedIsar> objects) {
    return putAllByIndex(r'reciterId', objects);
  }

  List<Id> putAllByReciterIdSync(List<RecentlyPlayedIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reciterId', objects, saveLinks: saveLinks);
  }
}

extension RecentlyPlayedIsarQueryWhereSort
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QWhere> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentlyPlayedIsarQueryWhere
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QWhereClause> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      reciterIdEqualTo(String reciterId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reciterId',
        value: [reciterId],
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterWhereClause>
      reciterIdNotEqualTo(String reciterId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [],
              upper: [reciterId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [reciterId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [reciterId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [],
              upper: [reciterId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RecentlyPlayedIsarQueryFilter
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QFilterCondition> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      lastPlayedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      lastPlayedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      lastPlayedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      lastPlayedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reciterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterFilterCondition>
      reciterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reciterId',
        value: '',
      ));
    });
  }
}

extension RecentlyPlayedIsarQueryObject
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QFilterCondition> {}

extension RecentlyPlayedIsarQueryLinks
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QFilterCondition> {}

extension RecentlyPlayedIsarQuerySortBy
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QSortBy> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByLastPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      sortByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }
}

extension RecentlyPlayedIsarQuerySortThenBy
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QSortThenBy> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByLastPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QAfterSortBy>
      thenByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }
}

extension RecentlyPlayedIsarQueryWhereDistinct
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QDistinct> {
  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QDistinct>
      distinctByData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QDistinct>
      distinctByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlayed');
    });
  }

  QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QDistinct>
      distinctByReciterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterId', caseSensitive: caseSensitive);
    });
  }
}

extension RecentlyPlayedIsarQueryProperty
    on QueryBuilder<RecentlyPlayedIsar, RecentlyPlayedIsar, QQueryProperty> {
  QueryBuilder<RecentlyPlayedIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentlyPlayedIsar, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<RecentlyPlayedIsar, DateTime, QQueryOperations>
      lastPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlayed');
    });
  }

  QueryBuilder<RecentlyPlayedIsar, String, QQueryOperations>
      reciterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTasbihStatsIsarCollection on Isar {
  IsarCollection<TasbihStatsIsar> get tasbihStatsIsars => this.collection();
}

const TasbihStatsIsarSchema = CollectionSchema(
  name: r'TasbihStatsIsar',
  id: 2420033592482983445,
  properties: {
    r'dailyGoal': PropertySchema(
      id: 0,
      name: r'dailyGoal',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.string,
    ),
    r'monthlyCountsJson': PropertySchema(
      id: 2,
      name: r'monthlyCountsJson',
      type: IsarType.string,
    ),
    r'todayCount': PropertySchema(
      id: 3,
      name: r'todayCount',
      type: IsarType.long,
    ),
    r'totalCount': PropertySchema(
      id: 4,
      name: r'totalCount',
      type: IsarType.long,
    ),
    r'weeklyCountsJson': PropertySchema(
      id: 5,
      name: r'weeklyCountsJson',
      type: IsarType.string,
    )
  },
  estimateSize: _tasbihStatsIsarEstimateSize,
  serialize: _tasbihStatsIsarSerialize,
  deserialize: _tasbihStatsIsarDeserialize,
  deserializeProp: _tasbihStatsIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tasbihStatsIsarGetId,
  getLinks: _tasbihStatsIsarGetLinks,
  attach: _tasbihStatsIsarAttach,
  version: '3.1.0+1',
);

int _tasbihStatsIsarEstimateSize(
  TasbihStatsIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.monthlyCountsJson.length * 3;
  bytesCount += 3 + object.weeklyCountsJson.length * 3;
  return bytesCount;
}

void _tasbihStatsIsarSerialize(
  TasbihStatsIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dailyGoal);
  writer.writeString(offsets[1], object.date);
  writer.writeString(offsets[2], object.monthlyCountsJson);
  writer.writeLong(offsets[3], object.todayCount);
  writer.writeLong(offsets[4], object.totalCount);
  writer.writeString(offsets[5], object.weeklyCountsJson);
}

TasbihStatsIsar _tasbihStatsIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TasbihStatsIsar();
  object.dailyGoal = reader.readLong(offsets[0]);
  object.date = reader.readString(offsets[1]);
  object.id = id;
  object.monthlyCountsJson = reader.readString(offsets[2]);
  object.todayCount = reader.readLong(offsets[3]);
  object.totalCount = reader.readLong(offsets[4]);
  object.weeklyCountsJson = reader.readString(offsets[5]);
  return object;
}

P _tasbihStatsIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tasbihStatsIsarGetId(TasbihStatsIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tasbihStatsIsarGetLinks(TasbihStatsIsar object) {
  return [];
}

void _tasbihStatsIsarAttach(
    IsarCollection<dynamic> col, Id id, TasbihStatsIsar object) {
  object.id = id;
}

extension TasbihStatsIsarQueryWhereSort
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QWhere> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TasbihStatsIsarQueryWhere
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QWhereClause> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TasbihStatsIsarQueryFilter
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QFilterCondition> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dailyGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dailyGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dailyGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dailyGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyCountsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'monthlyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'monthlyCountsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyCountsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      monthlyCountsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'monthlyCountsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      todayCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      todayCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      todayCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      todayCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'todayCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      totalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      totalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      totalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      totalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyCountsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weeklyCountsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weeklyCountsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyCountsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterFilterCondition>
      weeklyCountsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weeklyCountsJson',
        value: '',
      ));
    });
  }
}

extension TasbihStatsIsarQueryObject
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QFilterCondition> {}

extension TasbihStatsIsarQueryLinks
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QFilterCondition> {}

extension TasbihStatsIsarQuerySortBy
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QSortBy> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByDailyGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByMonthlyCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyCountsJson', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByMonthlyCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyCountsJson', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByTodayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByWeeklyCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCountsJson', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      sortByWeeklyCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCountsJson', Sort.desc);
    });
  }
}

extension TasbihStatsIsarQuerySortThenBy
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QSortThenBy> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByDailyGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByMonthlyCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyCountsJson', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByMonthlyCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyCountsJson', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByTodayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByWeeklyCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCountsJson', Sort.asc);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QAfterSortBy>
      thenByWeeklyCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCountsJson', Sort.desc);
    });
  }
}

extension TasbihStatsIsarQueryWhereDistinct
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct> {
  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct>
      distinctByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoal');
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct>
      distinctByMonthlyCountsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyCountsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct>
      distinctByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todayCount');
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct>
      distinctByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCount');
    });
  }

  QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QDistinct>
      distinctByWeeklyCountsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyCountsJson',
          caseSensitive: caseSensitive);
    });
  }
}

extension TasbihStatsIsarQueryProperty
    on QueryBuilder<TasbihStatsIsar, TasbihStatsIsar, QQueryProperty> {
  QueryBuilder<TasbihStatsIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TasbihStatsIsar, int, QQueryOperations> dailyGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoal');
    });
  }

  QueryBuilder<TasbihStatsIsar, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TasbihStatsIsar, String, QQueryOperations>
      monthlyCountsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyCountsJson');
    });
  }

  QueryBuilder<TasbihStatsIsar, int, QQueryOperations> todayCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todayCount');
    });
  }

  QueryBuilder<TasbihStatsIsar, int, QQueryOperations> totalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCount');
    });
  }

  QueryBuilder<TasbihStatsIsar, String, QQueryOperations>
      weeklyCountsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyCountsJson');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTasbihHistoryIsarCollection on Isar {
  IsarCollection<TasbihHistoryIsar> get tasbihHistoryIsars => this.collection();
}

const TasbihHistoryIsarSchema = CollectionSchema(
  name: r'TasbihHistoryIsar',
  id: -1824137192858976831,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'durationSeconds': PropertySchema(
      id: 1,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'label': PropertySchema(
      id: 2,
      name: r'label',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 3,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 4,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _tasbihHistoryIsarEstimateSize,
  serialize: _tasbihHistoryIsarSerialize,
  deserialize: _tasbihHistoryIsarDeserialize,
  deserializeProp: _tasbihHistoryIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tasbihHistoryIsarGetId,
  getLinks: _tasbihHistoryIsarGetLinks,
  attach: _tasbihHistoryIsarAttach,
  version: '3.1.0+1',
);

int _tasbihHistoryIsarEstimateSize(
  TasbihHistoryIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.sessionId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _tasbihHistoryIsarSerialize(
  TasbihHistoryIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeLong(offsets[1], object.durationSeconds);
  writer.writeString(offsets[2], object.label);
  writer.writeString(offsets[3], object.sessionId);
  writer.writeDateTime(offsets[4], object.startedAt);
  writer.writeString(offsets[5], object.type);
}

TasbihHistoryIsar _tasbihHistoryIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TasbihHistoryIsar();
  object.count = reader.readLong(offsets[0]);
  object.durationSeconds = reader.readLong(offsets[1]);
  object.id = id;
  object.label = reader.readString(offsets[2]);
  object.sessionId = reader.readString(offsets[3]);
  object.startedAt = reader.readDateTime(offsets[4]);
  object.type = reader.readString(offsets[5]);
  return object;
}

P _tasbihHistoryIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tasbihHistoryIsarGetId(TasbihHistoryIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tasbihHistoryIsarGetLinks(
    TasbihHistoryIsar object) {
  return [];
}

void _tasbihHistoryIsarAttach(
    IsarCollection<dynamic> col, Id id, TasbihHistoryIsar object) {
  object.id = id;
}

extension TasbihHistoryIsarQueryWhereSort
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QWhere> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TasbihHistoryIsarQueryWhere
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QWhereClause> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TasbihHistoryIsarQueryFilter
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QFilterCondition> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension TasbihHistoryIsarQueryObject
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QFilterCondition> {}

extension TasbihHistoryIsarQueryLinks
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QFilterCondition> {}

extension TasbihHistoryIsarQuerySortBy
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QSortBy> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TasbihHistoryIsarQuerySortThenBy
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QSortThenBy> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TasbihHistoryIsarQueryWhereDistinct
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct> {
  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct>
      distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension TasbihHistoryIsarQueryProperty
    on QueryBuilder<TasbihHistoryIsar, TasbihHistoryIsar, QQueryProperty> {
  QueryBuilder<TasbihHistoryIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TasbihHistoryIsar, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<TasbihHistoryIsar, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<TasbihHistoryIsar, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<TasbihHistoryIsar, String, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<TasbihHistoryIsar, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<TasbihHistoryIsar, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomTasbihIsarCollection on Isar {
  IsarCollection<CustomTasbihIsar> get customTasbihIsars => this.collection();
}

const CustomTasbihIsarSchema = CollectionSchema(
  name: r'CustomTasbihIsar',
  id: -3224387796491227460,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isFavorite': PropertySchema(
      id: 1,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'nameArabic': PropertySchema(
      id: 3,
      name: r'nameArabic',
      type: IsarType.string,
    ),
    r'target': PropertySchema(
      id: 4,
      name: r'target',
      type: IsarType.long,
    ),
    r'uniqueKey': PropertySchema(
      id: 5,
      name: r'uniqueKey',
      type: IsarType.string,
    )
  },
  estimateSize: _customTasbihIsarEstimateSize,
  serialize: _customTasbihIsarSerialize,
  deserialize: _customTasbihIsarDeserialize,
  deserializeProp: _customTasbihIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uniqueKey': IndexSchema(
      id: -866995956150369819,
      name: r'uniqueKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uniqueKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _customTasbihIsarGetId,
  getLinks: _customTasbihIsarGetLinks,
  attach: _customTasbihIsarAttach,
  version: '3.1.0+1',
);

int _customTasbihIsarEstimateSize(
  CustomTasbihIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.nameArabic.length * 3;
  bytesCount += 3 + object.uniqueKey.length * 3;
  return bytesCount;
}

void _customTasbihIsarSerialize(
  CustomTasbihIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isFavorite);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.nameArabic);
  writer.writeLong(offsets[4], object.target);
  writer.writeString(offsets[5], object.uniqueKey);
}

CustomTasbihIsar _customTasbihIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomTasbihIsar();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.nameArabic = reader.readString(offsets[3]);
  object.target = reader.readLong(offsets[4]);
  object.uniqueKey = reader.readString(offsets[5]);
  return object;
}

P _customTasbihIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customTasbihIsarGetId(CustomTasbihIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customTasbihIsarGetLinks(CustomTasbihIsar object) {
  return [];
}

void _customTasbihIsarAttach(
    IsarCollection<dynamic> col, Id id, CustomTasbihIsar object) {
  object.id = id;
}

extension CustomTasbihIsarByIndex on IsarCollection<CustomTasbihIsar> {
  Future<CustomTasbihIsar?> getByUniqueKey(String uniqueKey) {
    return getByIndex(r'uniqueKey', [uniqueKey]);
  }

  CustomTasbihIsar? getByUniqueKeySync(String uniqueKey) {
    return getByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<bool> deleteByUniqueKey(String uniqueKey) {
    return deleteByIndex(r'uniqueKey', [uniqueKey]);
  }

  bool deleteByUniqueKeySync(String uniqueKey) {
    return deleteByIndexSync(r'uniqueKey', [uniqueKey]);
  }

  Future<List<CustomTasbihIsar?>> getAllByUniqueKey(
      List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'uniqueKey', values);
  }

  List<CustomTasbihIsar?> getAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uniqueKey', values);
  }

  Future<int> deleteAllByUniqueKey(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uniqueKey', values);
  }

  int deleteAllByUniqueKeySync(List<String> uniqueKeyValues) {
    final values = uniqueKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uniqueKey', values);
  }

  Future<Id> putByUniqueKey(CustomTasbihIsar object) {
    return putByIndex(r'uniqueKey', object);
  }

  Id putByUniqueKeySync(CustomTasbihIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uniqueKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUniqueKey(List<CustomTasbihIsar> objects) {
    return putAllByIndex(r'uniqueKey', objects);
  }

  List<Id> putAllByUniqueKeySync(List<CustomTasbihIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uniqueKey', objects, saveLinks: saveLinks);
  }
}

extension CustomTasbihIsarQueryWhereSort
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QWhere> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomTasbihIsarQueryWhere
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QWhereClause> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause>
      uniqueKeyEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uniqueKey',
        value: [uniqueKey],
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterWhereClause>
      uniqueKeyNotEqualTo(String uniqueKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [uniqueKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uniqueKey',
              lower: [],
              upper: [uniqueKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CustomTasbihIsarQueryFilter
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QFilterCondition> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameArabic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameArabic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      nameArabicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      targetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      targetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      targetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'target',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      targetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'target',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterFilterCondition>
      uniqueKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueKey',
        value: '',
      ));
    });
  }
}

extension CustomTasbihIsarQueryObject
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QFilterCondition> {}

extension CustomTasbihIsarQueryLinks
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QFilterCondition> {}

extension CustomTasbihIsarQuerySortBy
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QSortBy> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      sortByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension CustomTasbihIsarQuerySortThenBy
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QSortThenBy> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByUniqueKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.asc);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QAfterSortBy>
      thenByUniqueKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueKey', Sort.desc);
    });
  }
}

extension CustomTasbihIsarQueryWhereDistinct
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct> {
  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct>
      distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct>
      distinctByNameArabic({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameArabic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct>
      distinctByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'target');
    });
  }

  QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QDistinct>
      distinctByUniqueKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueKey', caseSensitive: caseSensitive);
    });
  }
}

extension CustomTasbihIsarQueryProperty
    on QueryBuilder<CustomTasbihIsar, CustomTasbihIsar, QQueryProperty> {
  QueryBuilder<CustomTasbihIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomTasbihIsar, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CustomTasbihIsar, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<CustomTasbihIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CustomTasbihIsar, String, QQueryOperations>
      nameArabicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameArabic');
    });
  }

  QueryBuilder<CustomTasbihIsar, int, QQueryOperations> targetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'target');
    });
  }

  QueryBuilder<CustomTasbihIsar, String, QQueryOperations> uniqueKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyContentIsarCollection on Isar {
  IsarCollection<DailyContentIsar> get dailyContentIsars => this.collection();
}

const DailyContentIsarSchema = CollectionSchema(
  name: r'DailyContentIsar',
  id: -1437092456498804990,
  properties: {
    r'lastHadithDate': PropertySchema(
      id: 0,
      name: r'lastHadithDate',
      type: IsarType.string,
    ),
    r'lastHadithIndex': PropertySchema(
      id: 1,
      name: r'lastHadithIndex',
      type: IsarType.long,
    ),
    r'lastVerseDate': PropertySchema(
      id: 2,
      name: r'lastVerseDate',
      type: IsarType.string,
    ),
    r'lastVerseIndex': PropertySchema(
      id: 3,
      name: r'lastVerseIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyContentIsarEstimateSize,
  serialize: _dailyContentIsarSerialize,
  deserialize: _dailyContentIsarDeserialize,
  deserializeProp: _dailyContentIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyContentIsarGetId,
  getLinks: _dailyContentIsarGetLinks,
  attach: _dailyContentIsarAttach,
  version: '3.1.0+1',
);

int _dailyContentIsarEstimateSize(
  DailyContentIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lastHadithDate.length * 3;
  bytesCount += 3 + object.lastVerseDate.length * 3;
  return bytesCount;
}

void _dailyContentIsarSerialize(
  DailyContentIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.lastHadithDate);
  writer.writeLong(offsets[1], object.lastHadithIndex);
  writer.writeString(offsets[2], object.lastVerseDate);
  writer.writeLong(offsets[3], object.lastVerseIndex);
}

DailyContentIsar _dailyContentIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyContentIsar();
  object.id = id;
  object.lastHadithDate = reader.readString(offsets[0]);
  object.lastHadithIndex = reader.readLong(offsets[1]);
  object.lastVerseDate = reader.readString(offsets[2]);
  object.lastVerseIndex = reader.readLong(offsets[3]);
  return object;
}

P _dailyContentIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyContentIsarGetId(DailyContentIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyContentIsarGetLinks(DailyContentIsar object) {
  return [];
}

void _dailyContentIsarAttach(
    IsarCollection<dynamic> col, Id id, DailyContentIsar object) {
  object.id = id;
}

extension DailyContentIsarQueryWhereSort
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QWhere> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyContentIsarQueryWhere
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QWhereClause> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyContentIsarQueryFilter
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QFilterCondition> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastHadithDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastHadithDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastHadithDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastHadithDate',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastHadithDate',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastHadithIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastHadithIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastHadithIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastHadithIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastHadithIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastVerseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastVerseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastVerseDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVerseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastVerseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVerseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastVerseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastVerseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterFilterCondition>
      lastVerseIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastVerseIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyContentIsarQueryObject
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QFilterCondition> {}

extension DailyContentIsarQueryLinks
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QFilterCondition> {}

extension DailyContentIsarQuerySortBy
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QSortBy> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastHadithDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithDate', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastHadithDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithDate', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastHadithIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithIndex', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastHadithIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithIndex', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastVerseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseDate', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastVerseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseDate', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseIndex', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      sortByLastVerseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseIndex', Sort.desc);
    });
  }
}

extension DailyContentIsarQuerySortThenBy
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QSortThenBy> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastHadithDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithDate', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastHadithDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithDate', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastHadithIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithIndex', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastHadithIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastHadithIndex', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastVerseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseDate', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastVerseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseDate', Sort.desc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseIndex', Sort.asc);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QAfterSortBy>
      thenByLastVerseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVerseIndex', Sort.desc);
    });
  }
}

extension DailyContentIsarQueryWhereDistinct
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QDistinct> {
  QueryBuilder<DailyContentIsar, DailyContentIsar, QDistinct>
      distinctByLastHadithDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastHadithDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QDistinct>
      distinctByLastHadithIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastHadithIndex');
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QDistinct>
      distinctByLastVerseDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVerseDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyContentIsar, DailyContentIsar, QDistinct>
      distinctByLastVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVerseIndex');
    });
  }
}

extension DailyContentIsarQueryProperty
    on QueryBuilder<DailyContentIsar, DailyContentIsar, QQueryProperty> {
  QueryBuilder<DailyContentIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyContentIsar, String, QQueryOperations>
      lastHadithDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastHadithDate');
    });
  }

  QueryBuilder<DailyContentIsar, int, QQueryOperations>
      lastHadithIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastHadithIndex');
    });
  }

  QueryBuilder<DailyContentIsar, String, QQueryOperations>
      lastVerseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVerseDate');
    });
  }

  QueryBuilder<DailyContentIsar, int, QQueryOperations>
      lastVerseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVerseIndex');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSearchHistoryIsarCollection on Isar {
  IsarCollection<SearchHistoryIsar> get searchHistoryIsars => this.collection();
}

const SearchHistoryIsarSchema = CollectionSchema(
  name: r'SearchHistoryIsar',
  id: 4390508965107134847,
  properties: {
    r'query': PropertySchema(
      id: 0,
      name: r'query',
      type: IsarType.string,
    ),
    r'resultCount': PropertySchema(
      id: 1,
      name: r'resultCount',
      type: IsarType.long,
    ),
    r'searchedAt': PropertySchema(
      id: 2,
      name: r'searchedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _searchHistoryIsarEstimateSize,
  serialize: _searchHistoryIsarSerialize,
  deserialize: _searchHistoryIsarDeserialize,
  deserializeProp: _searchHistoryIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _searchHistoryIsarGetId,
  getLinks: _searchHistoryIsarGetLinks,
  attach: _searchHistoryIsarAttach,
  version: '3.1.0+1',
);

int _searchHistoryIsarEstimateSize(
  SearchHistoryIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.query.length * 3;
  return bytesCount;
}

void _searchHistoryIsarSerialize(
  SearchHistoryIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.query);
  writer.writeLong(offsets[1], object.resultCount);
  writer.writeDateTime(offsets[2], object.searchedAt);
}

SearchHistoryIsar _searchHistoryIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SearchHistoryIsar();
  object.id = id;
  object.query = reader.readString(offsets[0]);
  object.resultCount = reader.readLong(offsets[1]);
  object.searchedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _searchHistoryIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _searchHistoryIsarGetId(SearchHistoryIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _searchHistoryIsarGetLinks(
    SearchHistoryIsar object) {
  return [];
}

void _searchHistoryIsarAttach(
    IsarCollection<dynamic> col, Id id, SearchHistoryIsar object) {
  object.id = id;
}

extension SearchHistoryIsarQueryWhereSort
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QWhere> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SearchHistoryIsarQueryWhere
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QWhereClause> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SearchHistoryIsarQueryFilter
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QFilterCondition> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'query',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'query',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      queryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      resultCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      resultCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      resultCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      resultCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      searchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      searchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      searchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterFilterCondition>
      searchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SearchHistoryIsarQueryObject
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QFilterCondition> {}

extension SearchHistoryIsarQueryLinks
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QFilterCondition> {}

extension SearchHistoryIsarQuerySortBy
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QSortBy> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortByResultCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      sortBySearchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.desc);
    });
  }
}

extension SearchHistoryIsarQuerySortThenBy
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QSortThenBy> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenByResultCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QAfterSortBy>
      thenBySearchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.desc);
    });
  }
}

extension SearchHistoryIsarQueryWhereDistinct
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QDistinct> {
  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QDistinct> distinctByQuery(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'query', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QDistinct>
      distinctByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultCount');
    });
  }

  QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QDistinct>
      distinctBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchedAt');
    });
  }
}

extension SearchHistoryIsarQueryProperty
    on QueryBuilder<SearchHistoryIsar, SearchHistoryIsar, QQueryProperty> {
  QueryBuilder<SearchHistoryIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SearchHistoryIsar, String, QQueryOperations> queryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'query');
    });
  }

  QueryBuilder<SearchHistoryIsar, int, QQueryOperations> resultCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultCount');
    });
  }

  QueryBuilder<SearchHistoryIsar, DateTime, QQueryOperations>
      searchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchedAt');
    });
  }
}
