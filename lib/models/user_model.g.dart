// GENERATED CODE - DO NOT MODIFY BY HAND
// This file is a stub — run `dart run build_runner build` to regenerate.

part of 'user_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// ── UserProfile ────────────────────────────────────────────────────────────

extension GetUserProfileCollection on Isar {
  IsarCollection<UserProfile> get userProfiles => this.collection();
}

const UserProfileSchema = CollectionSchema(
  name: r'UserProfile',
  id: 1111111111111111111,
  properties: {
    r'actsOfKindness': PropertySchema(id: 0, name: r'actsOfKindness', type: IsarType.double),
    r'bismillahOption': PropertySchema(id: 1, name: r'bismillahOption', type: IsarType.bool),
    r'currentStreak': PropertySchema(id: 2, name: r'currentStreak', type: IsarType.long),
    r'dailyAyahGoal': PropertySchema(id: 3, name: r'dailyAyahGoal', type: IsarType.long),
    r'deepStudyGoal': PropertySchema(id: 4, name: r'deepStudyGoal', type: IsarType.bool),
    r'faithScore': PropertySchema(id: 5, name: r'faithScore', type: IsarType.long),
    r'guiltFreeReminders': PropertySchema(id: 6, name: r'guiltFreeReminders', type: IsarType.bool),
    r'heartReflection': PropertySchema(id: 7, name: r'heartReflection', type: IsarType.double),
    r'joinedAt': PropertySchema(id: 8, name: r'joinedAt', type: IsarType.dateTime),
    r'language': PropertySchema(id: 9, name: r'language', type: IsarType.string),
    r'lastName': PropertySchema(id: 10, name: r'lastName', type: IsarType.string),
    r'lastActiveDate': PropertySchema(id: 11, name: r'lastActiveDate', type: IsarType.dateTime),
    r'longestStreak': PropertySchema(id: 12, name: r'longestStreak', type: IsarType.long),
    r'name': PropertySchema(id: 13, name: r'name', type: IsarType.string),
    r'nightlyReflectionGoal': PropertySchema(id: 14, name: r'nightlyReflectionGoal', type: IsarType.bool),
    r'offlineMode': PropertySchema(id: 15, name: r'offlineMode', type: IsarType.bool),
    r'onboardingComplete': PropertySchema(id: 16, name: r'onboardingComplete', type: IsarType.bool),
    r'playbackSpeed': PropertySchema(id: 17, name: r'playbackSpeed', type: IsarType.double),
    r'quranEngagement': PropertySchema(id: 18, name: r'quranEngagement', type: IsarType.double),
    r'reciterName': PropertySchema(id: 19, name: r'reciterName', type: IsarType.string),
    r'salahAlignment': PropertySchema(id: 20, name: r'salahAlignment', type: IsarType.double),
    r'wordByWordEnabled': PropertySchema(id: 21, name: r'wordByWordEnabled', type: IsarType.bool),
  },
  estimateSize: _userProfileEstimateSize,
  serialize: _userProfileSerialize,
  deserialize: _userProfileDeserialize,
  deserializeProp: _userProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileGetId,
  getLinks: _userProfileGetLinks,
  attach: _userProfileAttach,
  version: '3.1.0+1',
);

int _userProfileEstimateSize(UserProfile o, List<int> offsets, Map<Type, List<int>> a) =>
    offsets.last + 3 + o.name.length * 3;

void _userProfileSerialize(UserProfile o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeDouble(offsets[0], o.actsOfKindness);
  w.writeBool(offsets[1], o.bismillahOption);
  w.writeLong(offsets[2], o.currentStreak);
  w.writeLong(offsets[3], o.dailyAyahGoal);
  w.writeBool(offsets[4], o.deepStudyGoal);
  w.writeLong(offsets[5], o.faithScore);
  w.writeBool(offsets[6], o.guiltFreeReminders);
  w.writeDouble(offsets[7], o.heartReflection);
  w.writeDateTime(offsets[8], o.joinedAt);
  w.writeString(offsets[9], o.language);
  w.writeString(offsets[10], o.lastName);
  w.writeDateTime(offsets[11], o.lastActiveDate);
  w.writeLong(offsets[12], o.longestStreak);
  w.writeString(offsets[13], o.name);
  w.writeBool(offsets[14], o.nightlyReflectionGoal);
  w.writeBool(offsets[15], o.offlineMode);
  w.writeBool(offsets[16], o.onboardingComplete);
  w.writeDouble(offsets[17], o.playbackSpeed);
  w.writeDouble(offsets[18], o.quranEngagement);
  w.writeString(offsets[19], o.reciterName);
  w.writeDouble(offsets[20], o.salahAlignment);
  w.writeBool(offsets[21], o.wordByWordEnabled);
}

UserProfile _userProfileDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = UserProfile();
  o.actsOfKindness = r.readDouble(offsets[0]);
  o.bismillahOption = r.readBool(offsets[1]);
  o.currentStreak = r.readLong(offsets[2]);
  o.dailyAyahGoal = r.readLong(offsets[3]);
  o.deepStudyGoal = r.readBool(offsets[4]);
  o.faithScore = r.readLong(offsets[5]);
  o.guiltFreeReminders = r.readBool(offsets[6]);
  o.heartReflection = r.readDouble(offsets[7]);
  o.joinedAt = r.readDateTimeOrNull(offsets[8]);
  o.language = r.readString(offsets[9]);
  o.lastName = r.readStringOrNull(offsets[10]);
  o.lastActiveDate = r.readDateTimeOrNull(offsets[11]);
  o.longestStreak = r.readLong(offsets[12]);
  o.name = r.readString(offsets[13]);
  o.nightlyReflectionGoal = r.readBool(offsets[14]);
  o.offlineMode = r.readBool(offsets[15]);
  o.onboardingComplete = r.readBool(offsets[16]);
  o.playbackSpeed = r.readDouble(offsets[17]);
  o.quranEngagement = r.readDouble(offsets[18]);
  o.reciterName = r.readString(offsets[19]);
  o.salahAlignment = r.readDouble(offsets[20]);
  o.wordByWordEnabled = r.readBool(offsets[21]);
  o.id = id;
  return o;
}

P _userProfileDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readDouble(offset)) as P;
    case 1: return (r.readBool(offset)) as P;
    case 2: return (r.readLong(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileGetId(UserProfile o) => o.id;
List<IsarLinkBase<dynamic>> _userProfileGetLinks(UserProfile o) => [];
void _userProfileAttach(IsarCollection<dynamic> col, Id id, UserProfile o) { o.id = id; }

// ── JournalEntry ─────────────────────────────────────────────────────────────

extension GetJournalEntryCollection on Isar {
  IsarCollection<JournalEntry> get journalEntrys => this.collection();
}

const JournalEntrySchema = CollectionSchema(
  name: r'JournalEntry',
  id: 2222222222222222222,
  properties: {
    r'arabicAyah': PropertySchema(id: 0, name: r'arabicAyah', type: IsarType.string),
    r'content': PropertySchema(id: 1, name: r'content', type: IsarType.string),
    r'createdAt': PropertySchema(id: 2, name: r'createdAt', type: IsarType.dateTime),
    r'isSaved': PropertySchema(id: 3, name: r'isSaved', type: IsarType.bool),
    r'linkedDeed': PropertySchema(id: 4, name: r'linkedDeed', type: IsarType.string),
    r'prompt': PropertySchema(id: 5, name: r'prompt', type: IsarType.string),
    r'surahRef': PropertySchema(id: 6, name: r'surahRef', type: IsarType.string),
    r'tags': PropertySchema(id: 7, name: r'tags', type: IsarType.stringList),
  },
  estimateSize: _journalEntryEstimateSize,
  serialize: _journalEntrySerialize,
  deserialize: _journalEntryDeserialize,
  deserializeProp: _journalEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: 3333333333333333333,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'createdAt', type: IndexType.value, caseSensitive: false),
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _journalEntryGetId,
  getLinks: _journalEntryGetLinks,
  attach: _journalEntryAttach,
  version: '3.1.0+1',
);

int _journalEntryEstimateSize(JournalEntry o, List<int> offsets, Map<Type, List<int>> a) =>
    offsets.last + 3 + o.content.length * 3;
void _journalEntrySerialize(JournalEntry o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeString(offsets[0], o.arabicAyah);
  w.writeString(offsets[1], o.content);
  w.writeDateTime(offsets[2], o.createdAt);
  w.writeBool(offsets[3], o.isSaved);
  w.writeString(offsets[4], o.linkedDeed);
  w.writeString(offsets[5], o.prompt);
  w.writeString(offsets[6], o.surahRef);
  w.writeStringList(offsets[7], o.tags);
}
JournalEntry _journalEntryDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = JournalEntry();
  o.arabicAyah = r.readStringOrNull(offsets[0]);
  o.content = r.readString(offsets[1]);
  o.createdAt = r.readDateTime(offsets[2]);
  o.id = id;
  o.isSaved = r.readBool(offsets[3]);
  o.linkedDeed = r.readStringOrNull(offsets[4]);
  o.prompt = r.readString(offsets[5]);
  o.surahRef = r.readStringOrNull(offsets[6]);
  o.tags = r.readStringList(offsets[7]) ?? [];
  return o;
}
P _journalEntryDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readStringOrNull(offset)) as P;
    case 1: return (r.readString(offset)) as P;
    case 2: return (r.readDateTime(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}
Id _journalEntryGetId(JournalEntry o) => o.id;
List<IsarLinkBase<dynamic>> _journalEntryGetLinks(JournalEntry o) => [];
void _journalEntryAttach(IsarCollection<dynamic> col, Id id, JournalEntry o) { o.id = id; }

extension JournalEntryQueryWhere on QueryBuilder<JournalEntry, JournalEntry, QWhereClause> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }
}

extension JournalEntryQuerySortBy on QueryBuilder<JournalEntry, JournalEntry, QSortBy> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }
}

// ── SRSCard ───────────────────────────────────────────────────────────────────

extension GetSRSCardCollection on Isar {
  IsarCollection<SRSCard> get sRSCards => this.collection();
}

const SRSCardSchema = CollectionSchema(
  name: r'SRSCard',
  id: 4444444444444444444,
  properties: {
    r'arabicText': PropertySchema(id: 0, name: r'arabicText', type: IsarType.string),
    r'ayahNumber': PropertySchema(id: 1, name: r'ayahNumber', type: IsarType.long),
    r'easeFactor': PropertySchema(id: 2, name: r'easeFactor', type: IsarType.double),
    r'interval': PropertySchema(id: 3, name: r'interval', type: IsarType.long),
    r'isMastered': PropertySchema(id: 4, name: r'isMastered', type: IsarType.bool),
    r'lastReviewDate': PropertySchema(id: 5, name: r'lastReviewDate', type: IsarType.dateTime),
    r'nextReviewDate': PropertySchema(id: 6, name: r'nextReviewDate', type: IsarType.dateTime),
    r'repetitions': PropertySchema(id: 7, name: r'repetitions', type: IsarType.long),
    r'retentionStrength': PropertySchema(id: 8, name: r'retentionStrength', type: IsarType.double),
    r'surahNumber': PropertySchema(id: 9, name: r'surahNumber', type: IsarType.long),
    r'translation': PropertySchema(id: 10, name: r'translation', type: IsarType.string),
  },
  estimateSize: _srsCardEstimateSize,
  serialize: _srsCardSerialize,
  deserialize: _srsCardDeserialize,
  deserializeProp: _srsCardDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahNumber_ayahNumber': IndexSchema(
      id: 5555555555555555555,
      name: r'surahNumber_ayahNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'surahNumber', type: IndexType.value, caseSensitive: false),
        IndexPropertySchema(name: r'ayahNumber', type: IndexType.value, caseSensitive: false),
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _srsCardGetId,
  getLinks: _srsCardGetLinks,
  attach: _srsCardAttach,
  version: '3.1.0+1',
);

int _srsCardEstimateSize(SRSCard o, List<int> offsets, Map<Type, List<int>> a) =>
    offsets.last + 3 + o.arabicText.length * 3;
void _srsCardSerialize(SRSCard o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeString(offsets[0], o.arabicText);
  w.writeLong(offsets[1], o.ayahNumber);
  w.writeDouble(offsets[2], o.easeFactor);
  w.writeLong(offsets[3], o.interval);
  w.writeBool(offsets[4], o.isMastered);
  w.writeDateTime(offsets[5], o.lastReviewDate);
  w.writeDateTime(offsets[6], o.nextReviewDate);
  w.writeLong(offsets[7], o.repetitions);
  w.writeDouble(offsets[8], o.retentionStrength);
  w.writeLong(offsets[9], o.surahNumber);
  w.writeString(offsets[10], o.translation);
}
SRSCard _srsCardDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = SRSCard();
  o.arabicText = r.readString(offsets[0]);
  o.ayahNumber = r.readLong(offsets[1]);
  o.easeFactor = r.readDouble(offsets[2]);
  o.id = id;
  o.interval = r.readLong(offsets[3]);
  o.isMastered = r.readBool(offsets[4]);
  o.lastReviewDate = r.readDateTimeOrNull(offsets[5]);
  o.nextReviewDate = r.readDateTimeOrNull(offsets[6]);
  o.repetitions = r.readLong(offsets[7]);
  o.retentionStrength = r.readDouble(offsets[8]);
  o.surahNumber = r.readLong(offsets[9]);
  o.translation = r.readString(offsets[10]);
  return o;
}
P _srsCardDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readString(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}
Id _srsCardGetId(SRSCard o) => o.id;
List<IsarLinkBase<dynamic>> _srsCardGetLinks(SRSCard o) => [];
void _srsCardAttach(IsarCollection<dynamic> col, Id id, SRSCard o) { o.id = id; }

extension SRSCardQueryFilter on QueryBuilder<SRSCard, SRSCard, QFilterCondition> {
  QueryBuilder<SRSCard, SRSCard, QAfterFilterCondition> nextReviewDateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'nextReviewDate',
        value: value,
      ));
    });
  }
  QueryBuilder<SRSCard, SRSCard, QAfterFilterCondition> nextReviewDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextReviewDate',
      ));
    });
  }
}

// ── ThematicJourney ──────────────────────────────────────────────────────────

extension GetThematicJourneyCollection on Isar {
  IsarCollection<ThematicJourney> get thematicJourneys => this.collection();
}

const ThematicJourneySchema = CollectionSchema(
  name: r'ThematicJourney',
  id: 6666666666666666666,
  properties: {
    r'completedDays': PropertySchema(id: 0, name: r'completedDays', type: IsarType.long),
    r'imageAsset': PropertySchema(id: 1, name: r'imageAsset', type: IsarType.string),
    r'isActive': PropertySchema(id: 2, name: r'isActive', type: IsarType.bool),
    r'startedAt': PropertySchema(id: 3, name: r'startedAt', type: IsarType.dateTime),
    r'subtitle': PropertySchema(id: 4, name: r'subtitle', type: IsarType.string),
    r'surahReference': PropertySchema(id: 5, name: r'surahReference', type: IsarType.string),
    r'title': PropertySchema(id: 6, name: r'title', type: IsarType.string),
    r'totalDays': PropertySchema(id: 7, name: r'totalDays', type: IsarType.long),
  },
  estimateSize: _thematicJourneyEstimateSize,
  serialize: _thematicJourneySerialize,
  deserialize: _thematicJourneyDeserialize,
  deserializeProp: _thematicJourneyDeserializeProp,
  idName: r'id',
  indexes: {
    r'isActive': IndexSchema(
      id: 7777777777777777777,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'isActive', type: IndexType.value, caseSensitive: false),
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _thematicJourneyGetId,
  getLinks: _thematicJourneyGetLinks,
  attach: _thematicJourneyAttach,
  version: '3.1.0+1',
);

int _thematicJourneyEstimateSize(ThematicJourney o, List<int> offsets, Map<Type, List<int>> a) =>
    offsets.last + 3 + o.title.length * 3;
void _thematicJourneySerialize(ThematicJourney o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeLong(offsets[0], o.completedDays);
  w.writeString(offsets[1], o.imageAsset);
  w.writeBool(offsets[2], o.isActive);
  w.writeDateTime(offsets[3], o.startedAt);
  w.writeString(offsets[4], o.subtitle);
  w.writeString(offsets[5], o.surahReference);
  w.writeString(offsets[6], o.title);
  w.writeLong(offsets[7], o.totalDays);
}
ThematicJourney _thematicJourneyDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = ThematicJourney();
  o.completedDays = r.readLong(offsets[0]);
  o.id = id;
  o.imageAsset = r.readStringOrNull(offsets[1]);
  o.isActive = r.readBool(offsets[2]);
  o.startedAt = r.readDateTimeOrNull(offsets[3]);
  o.subtitle = r.readString(offsets[4]);
  o.surahReference = r.readString(offsets[5]);
  o.title = r.readString(offsets[6]);
  o.totalDays = r.readLong(offsets[7]);
  return o;
}
P _thematicJourneyDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readLong(offset)) as P;
    case 2: return (r.readBool(offset)) as P;
    case 6: return (r.readString(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}
Id _thematicJourneyGetId(ThematicJourney o) => o.id;
List<IsarLinkBase<dynamic>> _thematicJourneyGetLinks(ThematicJourney o) => [];
void _thematicJourneyAttach(IsarCollection<dynamic> col, Id id, ThematicJourney o) { o.id = id; }

extension ThematicJourneyQueryFilter on QueryBuilder<ThematicJourney, ThematicJourney, QFilterCondition> {
  QueryBuilder<ThematicJourney, ThematicJourney, QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }
}

// ── DailyProgress ─────────────────────────────────────────────────────────────

extension GetDailyProgressCollection on Isar {
  IsarCollection<DailyProgress> get dailyProgresss => this.collection();
}

const DailyProgressSchema = CollectionSchema(
  name: r'DailyProgress',
  id: 8888888888888888888,
  properties: {
    r'ayahsRead': PropertySchema(id: 0, name: r'ayahsRead', type: IsarType.long),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'deedsCount': PropertySchema(id: 2, name: r'deedsCount', type: IsarType.long),
    r'faithScore': PropertySchema(id: 3, name: r'faithScore', type: IsarType.long),
    r'reflectionDone': PropertySchema(id: 4, name: r'reflectionDone', type: IsarType.bool),
    r'salahDone': PropertySchema(id: 5, name: r'salahDone', type: IsarType.bool),
    r'tasbihCount': PropertySchema(id: 6, name: r'tasbihCount', type: IsarType.long),
  },
  estimateSize: _dailyProgressEstimateSize,
  serialize: _dailyProgressSerialize,
  deserialize: _dailyProgressDeserialize,
  deserializeProp: _dailyProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: 9999999999999999999,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'date', type: IndexType.value, caseSensitive: false),
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyProgressGetId,
  getLinks: _dailyProgressGetLinks,
  attach: _dailyProgressAttach,
  version: '3.1.0+1',
);

int _dailyProgressEstimateSize(DailyProgress o, List<int> offsets, Map<Type, List<int>> a) => offsets.last;
void _dailyProgressSerialize(DailyProgress o, IsarWriter w, List<int> offsets, Map<Type, List<int>> a) {
  w.writeLong(offsets[0], o.ayahsRead);
  w.writeDateTime(offsets[1], o.date);
  w.writeLong(offsets[2], o.deedsCount);
  w.writeLong(offsets[3], o.faithScore);
  w.writeBool(offsets[4], o.reflectionDone);
  w.writeBool(offsets[5], o.salahDone);
  w.writeLong(offsets[6], o.tasbihCount);
}
DailyProgress _dailyProgressDeserialize(Id id, IsarReader r, List<int> offsets, Map<Type, List<int>> a) {
  final o = DailyProgress();
  o.ayahsRead = r.readLong(offsets[0]);
  o.date = r.readDateTime(offsets[1]);
  o.deedsCount = r.readLong(offsets[2]);
  o.faithScore = r.readLong(offsets[3]);
  o.id = id;
  o.reflectionDone = r.readBool(offsets[4]);
  o.salahDone = r.readBool(offsets[5]);
  o.tasbihCount = r.readLong(offsets[6]);
  return o;
}
P _dailyProgressDeserializeProp<P>(IsarReader r, int propertyId, int offset, Map<Type, List<int>> a) {
  switch (propertyId) {
    case 0: return (r.readLong(offset)) as P;
    case 1: return (r.readDateTime(offset)) as P;
    default: throw IsarError('Unknown property with id $propertyId');
  }
}
Id _dailyProgressGetId(DailyProgress o) => o.id;
List<IsarLinkBase<dynamic>> _dailyProgressGetLinks(DailyProgress o) => [];
void _dailyProgressAttach(IsarCollection<dynamic> col, Id id, DailyProgress o) { o.id = id; }

extension DailyProgressQueryWhere on QueryBuilder<DailyProgress, DailyProgress, QWhereClause> {
  QueryBuilder<DailyProgress, DailyProgress, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }
}

extension DailyProgressQueryFilter on QueryBuilder<DailyProgress, DailyProgress, QFilterCondition> {
  QueryBuilder<DailyProgress, DailyProgress, QAfterFilterCondition> dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }
  QueryBuilder<DailyProgress, DailyProgress, QAfterFilterCondition> dateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: value,
      ));
    });
  }
}

extension DailyProgressQuerySortBy on QueryBuilder<DailyProgress, DailyProgress, QSortBy> {
  QueryBuilder<DailyProgress, DailyProgress, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }
}
