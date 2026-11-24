// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<String> regionId = GeneratedColumn<String>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarLocalPathMeta = const VerificationMeta(
    'avatarLocalPath',
  );
  @override
  late final GeneratedColumn<String> avatarLocalPath = GeneratedColumn<String>(
    'avatar_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isContributorMeta = const VerificationMeta(
    'isContributor',
  );
  @override
  late final GeneratedColumn<bool> isContributor = GeneratedColumn<bool>(
    'is_contributor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_contributor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAdminMeta = const VerificationMeta(
    'isAdmin',
  );
  @override
  late final GeneratedColumn<bool> isAdmin = GeneratedColumn<bool>(
    'is_admin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_admin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    name,
    username,
    email,
    phone,
    regionId,
    avatarUrl,
    avatarLocalPath,
    isContributor,
    isAdmin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('avatar_local_path')) {
      context.handle(
        _avatarLocalPathMeta,
        avatarLocalPath.isAcceptableOrUnknown(
          data['avatar_local_path']!,
          _avatarLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('is_contributor')) {
      context.handle(
        _isContributorMeta,
        isContributor.isAcceptableOrUnknown(
          data['is_contributor']!,
          _isContributorMeta,
        ),
      );
    }
    if (data.containsKey('is_admin')) {
      context.handle(
        _isAdminMeta,
        isAdmin.isAcceptableOrUnknown(data['is_admin']!, _isAdminMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_id'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      avatarLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_local_path'],
      ),
      isContributor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_contributor'],
      )!,
      isAdmin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_admin'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String userId;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String regionId;
  final String? avatarUrl;
  final String? avatarLocalPath;
  final bool isContributor;
  final bool isAdmin;
  const UserProfile({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.regionId,
    this.avatarUrl,
    this.avatarLocalPath,
    required this.isContributor,
    required this.isAdmin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['region_id'] = Variable<String>(regionId);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || avatarLocalPath != null) {
      map['avatar_local_path'] = Variable<String>(avatarLocalPath);
    }
    map['is_contributor'] = Variable<bool>(isContributor);
    map['is_admin'] = Variable<bool>(isAdmin);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      userId: Value(userId),
      name: Value(name),
      username: Value(username),
      email: Value(email),
      phone: Value(phone),
      regionId: Value(regionId),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      avatarLocalPath: avatarLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarLocalPath),
      isContributor: Value(isContributor),
      isAdmin: Value(isAdmin),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      regionId: serializer.fromJson<String>(json['regionId']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      avatarLocalPath: serializer.fromJson<String?>(json['avatarLocalPath']),
      isContributor: serializer.fromJson<bool>(json['isContributor']),
      isAdmin: serializer.fromJson<bool>(json['isAdmin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'regionId': serializer.toJson<String>(regionId),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'avatarLocalPath': serializer.toJson<String?>(avatarLocalPath),
      'isContributor': serializer.toJson<bool>(isContributor),
      'isAdmin': serializer.toJson<bool>(isAdmin),
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? regionId,
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> avatarLocalPath = const Value.absent(),
    bool? isContributor,
    bool? isAdmin,
  }) => UserProfile(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    username: username ?? this.username,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    regionId: regionId ?? this.regionId,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    avatarLocalPath: avatarLocalPath.present
        ? avatarLocalPath.value
        : this.avatarLocalPath,
    isContributor: isContributor ?? this.isContributor,
    isAdmin: isAdmin ?? this.isAdmin,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      avatarLocalPath: data.avatarLocalPath.present
          ? data.avatarLocalPath.value
          : this.avatarLocalPath,
      isContributor: data.isContributor.present
          ? data.isContributor.value
          : this.isContributor,
      isAdmin: data.isAdmin.present ? data.isAdmin.value : this.isAdmin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('regionId: $regionId, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('avatarLocalPath: $avatarLocalPath, ')
          ..write('isContributor: $isContributor, ')
          ..write('isAdmin: $isAdmin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    name,
    username,
    email,
    phone,
    regionId,
    avatarUrl,
    avatarLocalPath,
    isContributor,
    isAdmin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.username == this.username &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.regionId == this.regionId &&
          other.avatarUrl == this.avatarUrl &&
          other.avatarLocalPath == this.avatarLocalPath &&
          other.isContributor == this.isContributor &&
          other.isAdmin == this.isAdmin);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> userId;
  final Value<String> name;
  final Value<String> username;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> regionId;
  final Value<String?> avatarUrl;
  final Value<String?> avatarLocalPath;
  final Value<bool> isContributor;
  final Value<bool> isAdmin;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.regionId = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.avatarLocalPath = const Value.absent(),
    this.isContributor = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String userId,
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.regionId = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.avatarLocalPath = const Value.absent(),
    this.isContributor = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserProfile> custom({
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? regionId,
    Expression<String>? avatarUrl,
    Expression<String>? avatarLocalPath,
    Expression<bool>? isContributor,
    Expression<bool>? isAdmin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (regionId != null) 'region_id': regionId,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (avatarLocalPath != null) 'avatar_local_path': avatarLocalPath,
      if (isContributor != null) 'is_contributor': isContributor,
      if (isAdmin != null) 'is_admin': isAdmin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? userId,
    Value<String>? name,
    Value<String>? username,
    Value<String>? email,
    Value<String>? phone,
    Value<String>? regionId,
    Value<String?>? avatarUrl,
    Value<String?>? avatarLocalPath,
    Value<bool>? isContributor,
    Value<bool>? isAdmin,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      regionId: regionId ?? this.regionId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarLocalPath: avatarLocalPath ?? this.avatarLocalPath,
      isContributor: isContributor ?? this.isContributor,
      isAdmin: isAdmin ?? this.isAdmin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<String>(regionId.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (avatarLocalPath.present) {
      map['avatar_local_path'] = Variable<String>(avatarLocalPath.value);
    }
    if (isContributor.present) {
      map['is_contributor'] = Variable<bool>(isContributor.value);
    }
    if (isAdmin.present) {
      map['is_admin'] = Variable<bool>(isAdmin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('regionId: $regionId, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('avatarLocalPath: $avatarLocalPath, ')
          ..write('isContributor: $isContributor, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegionsTable extends Regions with TableInfo<$RegionsTable, Region> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<String> regionId = GeneratedColumn<String>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provinceMeta = const VerificationMeta(
    'province',
  );
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
    'province',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _villageMeta = const VerificationMeta(
    'village',
  );
  @override
  late final GeneratedColumn<String> village = GeneratedColumn<String>(
    'village',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    regionId,
    province,
    city,
    district,
    village,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Region> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    if (data.containsKey('province')) {
      context.handle(
        _provinceMeta,
        province.isAcceptableOrUnknown(data['province']!, _provinceMeta),
      );
    } else if (isInserting) {
      context.missing(_provinceMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('village')) {
      context.handle(
        _villageMeta,
        village.isAcceptableOrUnknown(data['village']!, _villageMeta),
      );
    } else if (isInserting) {
      context.missing(_villageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {regionId};
  @override
  Region map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Region(
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_id'],
      )!,
      province: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      )!,
      village: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}village'],
      )!,
    );
  }

  @override
  $RegionsTable createAlias(String alias) {
    return $RegionsTable(attachedDatabase, alias);
  }
}

class Region extends DataClass implements Insertable<Region> {
  final String regionId;
  final String province;
  final String city;
  final String district;
  final String village;
  const Region({
    required this.regionId,
    required this.province,
    required this.city,
    required this.district,
    required this.village,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['region_id'] = Variable<String>(regionId);
    map['province'] = Variable<String>(province);
    map['city'] = Variable<String>(city);
    map['district'] = Variable<String>(district);
    map['village'] = Variable<String>(village);
    return map;
  }

  RegionsCompanion toCompanion(bool nullToAbsent) {
    return RegionsCompanion(
      regionId: Value(regionId),
      province: Value(province),
      city: Value(city),
      district: Value(district),
      village: Value(village),
    );
  }

  factory Region.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Region(
      regionId: serializer.fromJson<String>(json['regionId']),
      province: serializer.fromJson<String>(json['province']),
      city: serializer.fromJson<String>(json['city']),
      district: serializer.fromJson<String>(json['district']),
      village: serializer.fromJson<String>(json['village']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'regionId': serializer.toJson<String>(regionId),
      'province': serializer.toJson<String>(province),
      'city': serializer.toJson<String>(city),
      'district': serializer.toJson<String>(district),
      'village': serializer.toJson<String>(village),
    };
  }

  Region copyWith({
    String? regionId,
    String? province,
    String? city,
    String? district,
    String? village,
  }) => Region(
    regionId: regionId ?? this.regionId,
    province: province ?? this.province,
    city: city ?? this.city,
    district: district ?? this.district,
    village: village ?? this.village,
  );
  Region copyWithCompanion(RegionsCompanion data) {
    return Region(
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      province: data.province.present ? data.province.value : this.province,
      city: data.city.present ? data.city.value : this.city,
      district: data.district.present ? data.district.value : this.district,
      village: data.village.present ? data.village.value : this.village,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Region(')
          ..write('regionId: $regionId, ')
          ..write('province: $province, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('village: $village')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(regionId, province, city, district, village);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Region &&
          other.regionId == this.regionId &&
          other.province == this.province &&
          other.city == this.city &&
          other.district == this.district &&
          other.village == this.village);
}

class RegionsCompanion extends UpdateCompanion<Region> {
  final Value<String> regionId;
  final Value<String> province;
  final Value<String> city;
  final Value<String> district;
  final Value<String> village;
  final Value<int> rowid;
  const RegionsCompanion({
    this.regionId = const Value.absent(),
    this.province = const Value.absent(),
    this.city = const Value.absent(),
    this.district = const Value.absent(),
    this.village = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegionsCompanion.insert({
    required String regionId,
    required String province,
    required String city,
    required String district,
    required String village,
    this.rowid = const Value.absent(),
  }) : regionId = Value(regionId),
       province = Value(province),
       city = Value(city),
       district = Value(district),
       village = Value(village);
  static Insertable<Region> custom({
    Expression<String>? regionId,
    Expression<String>? province,
    Expression<String>? city,
    Expression<String>? district,
    Expression<String>? village,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (regionId != null) 'region_id': regionId,
      if (province != null) 'province': province,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (village != null) 'village': village,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegionsCompanion copyWith({
    Value<String>? regionId,
    Value<String>? province,
    Value<String>? city,
    Value<String>? district,
    Value<String>? village,
    Value<int>? rowid,
  }) {
    return RegionsCompanion(
      regionId: regionId ?? this.regionId,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      village: village ?? this.village,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (regionId.present) {
      map['region_id'] = Variable<String>(regionId.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (village.present) {
      map['village'] = Variable<String>(village.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegionsCompanion(')
          ..write('regionId: $regionId, ')
          ..write('province: $province, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('village: $village, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedOpportunitiesTable extends SavedOpportunities
    with TableInfo<$SavedOpportunitiesTable, SavedOpportunity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedOpportunitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opportunityIdMeta = const VerificationMeta(
    'opportunityId',
  );
  @override
  late final GeneratedColumn<String> opportunityId = GeneratedColumn<String>(
    'opportunity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opportunityOwnerIdMeta =
      const VerificationMeta('opportunityOwnerId');
  @override
  late final GeneratedColumn<String> opportunityOwnerId =
      GeneratedColumn<String>(
        'opportunity_owner_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<String> regionId = GeneratedColumn<String>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionNameMeta = const VerificationMeta(
    'regionName',
  );
  @override
  late final GeneratedColumn<String> regionName = GeneratedColumn<String>(
    'region_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionCityMeta = const VerificationMeta(
    'regionCity',
  );
  @override
  late final GeneratedColumn<String> regionCity = GeneratedColumn<String>(
    'region_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionProvinceMeta = const VerificationMeta(
    'regionProvince',
  );
  @override
  late final GeneratedColumn<String> regionProvince = GeneratedColumn<String>(
    'region_province',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localImageBytesMeta = const VerificationMeta(
    'localImageBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> localImageBytes =
      GeneratedColumn<Uint8List>(
        'local_image_bytes',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opportunityId,
    userId,
    opportunityOwnerId,
    title,
    description,
    category,
    regionId,
    regionName,
    regionCity,
    regionProvince,
    endDate,
    source,
    contact,
    imageUrl,
    localImageBytes,
    status,
    createdAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_opportunities';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedOpportunity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('opportunity_id')) {
      context.handle(
        _opportunityIdMeta,
        opportunityId.isAcceptableOrUnknown(
          data['opportunity_id']!,
          _opportunityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_opportunityIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('opportunity_owner_id')) {
      context.handle(
        _opportunityOwnerIdMeta,
        opportunityOwnerId.isAcceptableOrUnknown(
          data['opportunity_owner_id']!,
          _opportunityOwnerIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    if (data.containsKey('region_name')) {
      context.handle(
        _regionNameMeta,
        regionName.isAcceptableOrUnknown(data['region_name']!, _regionNameMeta),
      );
    }
    if (data.containsKey('region_city')) {
      context.handle(
        _regionCityMeta,
        regionCity.isAcceptableOrUnknown(data['region_city']!, _regionCityMeta),
      );
    }
    if (data.containsKey('region_province')) {
      context.handle(
        _regionProvinceMeta,
        regionProvince.isAcceptableOrUnknown(
          data['region_province']!,
          _regionProvinceMeta,
        ),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('local_image_bytes')) {
      context.handle(
        _localImageBytesMeta,
        localImageBytes.isAcceptableOrUnknown(
          data['local_image_bytes']!,
          _localImageBytesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, opportunityId};
  @override
  SavedOpportunity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedOpportunity(
      opportunityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opportunity_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      opportunityOwnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opportunity_owner_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_id'],
      )!,
      regionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_name'],
      ),
      regionCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_city'],
      ),
      regionProvince: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_province'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      localImageBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}local_image_bytes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $SavedOpportunitiesTable createAlias(String alias) {
    return $SavedOpportunitiesTable(attachedDatabase, alias);
  }
}

class SavedOpportunity extends DataClass
    implements Insertable<SavedOpportunity> {
  final String opportunityId;
  final String userId;
  final String opportunityOwnerId;
  final String title;
  final String description;
  final String category;
  final String regionId;
  final String? regionName;
  final String? regionCity;
  final String? regionProvince;
  final DateTime endDate;
  final String? source;
  final String? contact;
  final String? imageUrl;
  final Uint8List? localImageBytes;
  final String status;
  final DateTime? createdAt;
  final DateTime cachedAt;
  const SavedOpportunity({
    required this.opportunityId,
    required this.userId,
    required this.opportunityOwnerId,
    required this.title,
    required this.description,
    required this.category,
    required this.regionId,
    this.regionName,
    this.regionCity,
    this.regionProvince,
    required this.endDate,
    this.source,
    this.contact,
    this.imageUrl,
    this.localImageBytes,
    required this.status,
    this.createdAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['opportunity_id'] = Variable<String>(opportunityId);
    map['user_id'] = Variable<String>(userId);
    map['opportunity_owner_id'] = Variable<String>(opportunityOwnerId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['region_id'] = Variable<String>(regionId);
    if (!nullToAbsent || regionName != null) {
      map['region_name'] = Variable<String>(regionName);
    }
    if (!nullToAbsent || regionCity != null) {
      map['region_city'] = Variable<String>(regionCity);
    }
    if (!nullToAbsent || regionProvince != null) {
      map['region_province'] = Variable<String>(regionProvince);
    }
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || localImageBytes != null) {
      map['local_image_bytes'] = Variable<Uint8List>(localImageBytes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  SavedOpportunitiesCompanion toCompanion(bool nullToAbsent) {
    return SavedOpportunitiesCompanion(
      opportunityId: Value(opportunityId),
      userId: Value(userId),
      opportunityOwnerId: Value(opportunityOwnerId),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      regionId: Value(regionId),
      regionName: regionName == null && nullToAbsent
          ? const Value.absent()
          : Value(regionName),
      regionCity: regionCity == null && nullToAbsent
          ? const Value.absent()
          : Value(regionCity),
      regionProvince: regionProvince == null && nullToAbsent
          ? const Value.absent()
          : Value(regionProvince),
      endDate: Value(endDate),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      localImageBytes: localImageBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(localImageBytes),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory SavedOpportunity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedOpportunity(
      opportunityId: serializer.fromJson<String>(json['opportunityId']),
      userId: serializer.fromJson<String>(json['userId']),
      opportunityOwnerId: serializer.fromJson<String>(
        json['opportunityOwnerId'],
      ),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      regionId: serializer.fromJson<String>(json['regionId']),
      regionName: serializer.fromJson<String?>(json['regionName']),
      regionCity: serializer.fromJson<String?>(json['regionCity']),
      regionProvince: serializer.fromJson<String?>(json['regionProvince']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      source: serializer.fromJson<String?>(json['source']),
      contact: serializer.fromJson<String?>(json['contact']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      localImageBytes: serializer.fromJson<Uint8List?>(json['localImageBytes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opportunityId': serializer.toJson<String>(opportunityId),
      'userId': serializer.toJson<String>(userId),
      'opportunityOwnerId': serializer.toJson<String>(opportunityOwnerId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'regionId': serializer.toJson<String>(regionId),
      'regionName': serializer.toJson<String?>(regionName),
      'regionCity': serializer.toJson<String?>(regionCity),
      'regionProvince': serializer.toJson<String?>(regionProvince),
      'endDate': serializer.toJson<DateTime>(endDate),
      'source': serializer.toJson<String?>(source),
      'contact': serializer.toJson<String?>(contact),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'localImageBytes': serializer.toJson<Uint8List?>(localImageBytes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  SavedOpportunity copyWith({
    String? opportunityId,
    String? userId,
    String? opportunityOwnerId,
    String? title,
    String? description,
    String? category,
    String? regionId,
    Value<String?> regionName = const Value.absent(),
    Value<String?> regionCity = const Value.absent(),
    Value<String?> regionProvince = const Value.absent(),
    DateTime? endDate,
    Value<String?> source = const Value.absent(),
    Value<String?> contact = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<Uint8List?> localImageBytes = const Value.absent(),
    String? status,
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? cachedAt,
  }) => SavedOpportunity(
    opportunityId: opportunityId ?? this.opportunityId,
    userId: userId ?? this.userId,
    opportunityOwnerId: opportunityOwnerId ?? this.opportunityOwnerId,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    regionId: regionId ?? this.regionId,
    regionName: regionName.present ? regionName.value : this.regionName,
    regionCity: regionCity.present ? regionCity.value : this.regionCity,
    regionProvince: regionProvince.present
        ? regionProvince.value
        : this.regionProvince,
    endDate: endDate ?? this.endDate,
    source: source.present ? source.value : this.source,
    contact: contact.present ? contact.value : this.contact,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    localImageBytes: localImageBytes.present
        ? localImageBytes.value
        : this.localImageBytes,
    status: status ?? this.status,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  SavedOpportunity copyWithCompanion(SavedOpportunitiesCompanion data) {
    return SavedOpportunity(
      opportunityId: data.opportunityId.present
          ? data.opportunityId.value
          : this.opportunityId,
      userId: data.userId.present ? data.userId.value : this.userId,
      opportunityOwnerId: data.opportunityOwnerId.present
          ? data.opportunityOwnerId.value
          : this.opportunityOwnerId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      regionName: data.regionName.present
          ? data.regionName.value
          : this.regionName,
      regionCity: data.regionCity.present
          ? data.regionCity.value
          : this.regionCity,
      regionProvince: data.regionProvince.present
          ? data.regionProvince.value
          : this.regionProvince,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      source: data.source.present ? data.source.value : this.source,
      contact: data.contact.present ? data.contact.value : this.contact,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      localImageBytes: data.localImageBytes.present
          ? data.localImageBytes.value
          : this.localImageBytes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedOpportunity(')
          ..write('opportunityId: $opportunityId, ')
          ..write('userId: $userId, ')
          ..write('opportunityOwnerId: $opportunityOwnerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('regionId: $regionId, ')
          ..write('regionName: $regionName, ')
          ..write('regionCity: $regionCity, ')
          ..write('regionProvince: $regionProvince, ')
          ..write('endDate: $endDate, ')
          ..write('source: $source, ')
          ..write('contact: $contact, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('localImageBytes: $localImageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opportunityId,
    userId,
    opportunityOwnerId,
    title,
    description,
    category,
    regionId,
    regionName,
    regionCity,
    regionProvince,
    endDate,
    source,
    contact,
    imageUrl,
    $driftBlobEquality.hash(localImageBytes),
    status,
    createdAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedOpportunity &&
          other.opportunityId == this.opportunityId &&
          other.userId == this.userId &&
          other.opportunityOwnerId == this.opportunityOwnerId &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.regionId == this.regionId &&
          other.regionName == this.regionName &&
          other.regionCity == this.regionCity &&
          other.regionProvince == this.regionProvince &&
          other.endDate == this.endDate &&
          other.source == this.source &&
          other.contact == this.contact &&
          other.imageUrl == this.imageUrl &&
          $driftBlobEquality.equals(
            other.localImageBytes,
            this.localImageBytes,
          ) &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt);
}

class SavedOpportunitiesCompanion extends UpdateCompanion<SavedOpportunity> {
  final Value<String> opportunityId;
  final Value<String> userId;
  final Value<String> opportunityOwnerId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> regionId;
  final Value<String?> regionName;
  final Value<String?> regionCity;
  final Value<String?> regionProvince;
  final Value<DateTime> endDate;
  final Value<String?> source;
  final Value<String?> contact;
  final Value<String?> imageUrl;
  final Value<Uint8List?> localImageBytes;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const SavedOpportunitiesCompanion({
    this.opportunityId = const Value.absent(),
    this.userId = const Value.absent(),
    this.opportunityOwnerId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.regionId = const Value.absent(),
    this.regionName = const Value.absent(),
    this.regionCity = const Value.absent(),
    this.regionProvince = const Value.absent(),
    this.endDate = const Value.absent(),
    this.source = const Value.absent(),
    this.contact = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.localImageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedOpportunitiesCompanion.insert({
    required String opportunityId,
    required String userId,
    this.opportunityOwnerId = const Value.absent(),
    required String title,
    required String description,
    required String category,
    required String regionId,
    this.regionName = const Value.absent(),
    this.regionCity = const Value.absent(),
    this.regionProvince = const Value.absent(),
    required DateTime endDate,
    this.source = const Value.absent(),
    this.contact = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.localImageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : opportunityId = Value(opportunityId),
       userId = Value(userId),
       title = Value(title),
       description = Value(description),
       category = Value(category),
       regionId = Value(regionId),
       endDate = Value(endDate),
       cachedAt = Value(cachedAt);
  static Insertable<SavedOpportunity> custom({
    Expression<String>? opportunityId,
    Expression<String>? userId,
    Expression<String>? opportunityOwnerId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? regionId,
    Expression<String>? regionName,
    Expression<String>? regionCity,
    Expression<String>? regionProvince,
    Expression<DateTime>? endDate,
    Expression<String>? source,
    Expression<String>? contact,
    Expression<String>? imageUrl,
    Expression<Uint8List>? localImageBytes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opportunityId != null) 'opportunity_id': opportunityId,
      if (userId != null) 'user_id': userId,
      if (opportunityOwnerId != null)
        'opportunity_owner_id': opportunityOwnerId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (regionId != null) 'region_id': regionId,
      if (regionName != null) 'region_name': regionName,
      if (regionCity != null) 'region_city': regionCity,
      if (regionProvince != null) 'region_province': regionProvince,
      if (endDate != null) 'end_date': endDate,
      if (source != null) 'source': source,
      if (contact != null) 'contact': contact,
      if (imageUrl != null) 'image_url': imageUrl,
      if (localImageBytes != null) 'local_image_bytes': localImageBytes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedOpportunitiesCompanion copyWith({
    Value<String>? opportunityId,
    Value<String>? userId,
    Value<String>? opportunityOwnerId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<String>? regionId,
    Value<String?>? regionName,
    Value<String?>? regionCity,
    Value<String?>? regionProvince,
    Value<DateTime>? endDate,
    Value<String?>? source,
    Value<String?>? contact,
    Value<String?>? imageUrl,
    Value<Uint8List?>? localImageBytes,
    Value<String>? status,
    Value<DateTime?>? createdAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return SavedOpportunitiesCompanion(
      opportunityId: opportunityId ?? this.opportunityId,
      userId: userId ?? this.userId,
      opportunityOwnerId: opportunityOwnerId ?? this.opportunityOwnerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      regionCity: regionCity ?? this.regionCity,
      regionProvince: regionProvince ?? this.regionProvince,
      endDate: endDate ?? this.endDate,
      source: source ?? this.source,
      contact: contact ?? this.contact,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageBytes: localImageBytes ?? this.localImageBytes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opportunityId.present) {
      map['opportunity_id'] = Variable<String>(opportunityId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (opportunityOwnerId.present) {
      map['opportunity_owner_id'] = Variable<String>(opportunityOwnerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<String>(regionId.value);
    }
    if (regionName.present) {
      map['region_name'] = Variable<String>(regionName.value);
    }
    if (regionCity.present) {
      map['region_city'] = Variable<String>(regionCity.value);
    }
    if (regionProvince.present) {
      map['region_province'] = Variable<String>(regionProvince.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (localImageBytes.present) {
      map['local_image_bytes'] = Variable<Uint8List>(localImageBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedOpportunitiesCompanion(')
          ..write('opportunityId: $opportunityId, ')
          ..write('userId: $userId, ')
          ..write('opportunityOwnerId: $opportunityOwnerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('regionId: $regionId, ')
          ..write('regionName: $regionName, ')
          ..write('regionCity: $regionCity, ')
          ..write('regionProvince: $regionProvince, ')
          ..write('endDate: $endDate, ')
          ..write('source: $source, ')
          ..write('contact: $contact, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('localImageBytes: $localImageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArchivedOpportunitiesTable extends ArchivedOpportunities
    with TableInfo<$ArchivedOpportunitiesTable, ArchivedOpportunity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArchivedOpportunitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opportunityIdMeta = const VerificationMeta(
    'opportunityId',
  );
  @override
  late final GeneratedColumn<String> opportunityId = GeneratedColumn<String>(
    'opportunity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opportunityOwnerIdMeta =
      const VerificationMeta('opportunityOwnerId');
  @override
  late final GeneratedColumn<String> opportunityOwnerId =
      GeneratedColumn<String>(
        'opportunity_owner_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<String> regionId = GeneratedColumn<String>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionNameMeta = const VerificationMeta(
    'regionName',
  );
  @override
  late final GeneratedColumn<String> regionName = GeneratedColumn<String>(
    'region_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionCityMeta = const VerificationMeta(
    'regionCity',
  );
  @override
  late final GeneratedColumn<String> regionCity = GeneratedColumn<String>(
    'region_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionProvinceMeta = const VerificationMeta(
    'regionProvince',
  );
  @override
  late final GeneratedColumn<String> regionProvince = GeneratedColumn<String>(
    'region_province',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localImageBytesMeta = const VerificationMeta(
    'localImageBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> localImageBytes =
      GeneratedColumn<Uint8List>(
        'local_image_bytes',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('archived'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opportunityId,
    userId,
    opportunityOwnerId,
    title,
    description,
    category,
    regionId,
    regionName,
    regionCity,
    regionProvince,
    endDate,
    source,
    contact,
    imageUrl,
    localImageBytes,
    status,
    createdAt,
    deletedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'archived_opportunities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArchivedOpportunity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('opportunity_id')) {
      context.handle(
        _opportunityIdMeta,
        opportunityId.isAcceptableOrUnknown(
          data['opportunity_id']!,
          _opportunityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_opportunityIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('opportunity_owner_id')) {
      context.handle(
        _opportunityOwnerIdMeta,
        opportunityOwnerId.isAcceptableOrUnknown(
          data['opportunity_owner_id']!,
          _opportunityOwnerIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    if (data.containsKey('region_name')) {
      context.handle(
        _regionNameMeta,
        regionName.isAcceptableOrUnknown(data['region_name']!, _regionNameMeta),
      );
    }
    if (data.containsKey('region_city')) {
      context.handle(
        _regionCityMeta,
        regionCity.isAcceptableOrUnknown(data['region_city']!, _regionCityMeta),
      );
    }
    if (data.containsKey('region_province')) {
      context.handle(
        _regionProvinceMeta,
        regionProvince.isAcceptableOrUnknown(
          data['region_province']!,
          _regionProvinceMeta,
        ),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('local_image_bytes')) {
      context.handle(
        _localImageBytesMeta,
        localImageBytes.isAcceptableOrUnknown(
          data['local_image_bytes']!,
          _localImageBytesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, opportunityId};
  @override
  ArchivedOpportunity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArchivedOpportunity(
      opportunityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opportunity_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      opportunityOwnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opportunity_owner_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_id'],
      )!,
      regionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_name'],
      ),
      regionCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_city'],
      ),
      regionProvince: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_province'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      localImageBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}local_image_bytes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ArchivedOpportunitiesTable createAlias(String alias) {
    return $ArchivedOpportunitiesTable(attachedDatabase, alias);
  }
}

class ArchivedOpportunity extends DataClass
    implements Insertable<ArchivedOpportunity> {
  final String opportunityId;
  final String userId;
  final String opportunityOwnerId;
  final String title;
  final String description;
  final String category;
  final String regionId;
  final String? regionName;
  final String? regionCity;
  final String? regionProvince;
  final DateTime endDate;
  final String? source;
  final String? contact;
  final String? imageUrl;
  final Uint8List? localImageBytes;
  final String status;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final DateTime cachedAt;
  const ArchivedOpportunity({
    required this.opportunityId,
    required this.userId,
    required this.opportunityOwnerId,
    required this.title,
    required this.description,
    required this.category,
    required this.regionId,
    this.regionName,
    this.regionCity,
    this.regionProvince,
    required this.endDate,
    this.source,
    this.contact,
    this.imageUrl,
    this.localImageBytes,
    required this.status,
    this.createdAt,
    this.deletedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['opportunity_id'] = Variable<String>(opportunityId);
    map['user_id'] = Variable<String>(userId);
    map['opportunity_owner_id'] = Variable<String>(opportunityOwnerId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['region_id'] = Variable<String>(regionId);
    if (!nullToAbsent || regionName != null) {
      map['region_name'] = Variable<String>(regionName);
    }
    if (!nullToAbsent || regionCity != null) {
      map['region_city'] = Variable<String>(regionCity);
    }
    if (!nullToAbsent || regionProvince != null) {
      map['region_province'] = Variable<String>(regionProvince);
    }
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || localImageBytes != null) {
      map['local_image_bytes'] = Variable<Uint8List>(localImageBytes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ArchivedOpportunitiesCompanion toCompanion(bool nullToAbsent) {
    return ArchivedOpportunitiesCompanion(
      opportunityId: Value(opportunityId),
      userId: Value(userId),
      opportunityOwnerId: Value(opportunityOwnerId),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      regionId: Value(regionId),
      regionName: regionName == null && nullToAbsent
          ? const Value.absent()
          : Value(regionName),
      regionCity: regionCity == null && nullToAbsent
          ? const Value.absent()
          : Value(regionCity),
      regionProvince: regionProvince == null && nullToAbsent
          ? const Value.absent()
          : Value(regionProvince),
      endDate: Value(endDate),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      localImageBytes: localImageBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(localImageBytes),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory ArchivedOpportunity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArchivedOpportunity(
      opportunityId: serializer.fromJson<String>(json['opportunityId']),
      userId: serializer.fromJson<String>(json['userId']),
      opportunityOwnerId: serializer.fromJson<String>(
        json['opportunityOwnerId'],
      ),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      regionId: serializer.fromJson<String>(json['regionId']),
      regionName: serializer.fromJson<String?>(json['regionName']),
      regionCity: serializer.fromJson<String?>(json['regionCity']),
      regionProvince: serializer.fromJson<String?>(json['regionProvince']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      source: serializer.fromJson<String?>(json['source']),
      contact: serializer.fromJson<String?>(json['contact']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      localImageBytes: serializer.fromJson<Uint8List?>(json['localImageBytes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opportunityId': serializer.toJson<String>(opportunityId),
      'userId': serializer.toJson<String>(userId),
      'opportunityOwnerId': serializer.toJson<String>(opportunityOwnerId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'regionId': serializer.toJson<String>(regionId),
      'regionName': serializer.toJson<String?>(regionName),
      'regionCity': serializer.toJson<String?>(regionCity),
      'regionProvince': serializer.toJson<String?>(regionProvince),
      'endDate': serializer.toJson<DateTime>(endDate),
      'source': serializer.toJson<String?>(source),
      'contact': serializer.toJson<String?>(contact),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'localImageBytes': serializer.toJson<Uint8List?>(localImageBytes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ArchivedOpportunity copyWith({
    String? opportunityId,
    String? userId,
    String? opportunityOwnerId,
    String? title,
    String? description,
    String? category,
    String? regionId,
    Value<String?> regionName = const Value.absent(),
    Value<String?> regionCity = const Value.absent(),
    Value<String?> regionProvince = const Value.absent(),
    DateTime? endDate,
    Value<String?> source = const Value.absent(),
    Value<String?> contact = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<Uint8List?> localImageBytes = const Value.absent(),
    String? status,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? cachedAt,
  }) => ArchivedOpportunity(
    opportunityId: opportunityId ?? this.opportunityId,
    userId: userId ?? this.userId,
    opportunityOwnerId: opportunityOwnerId ?? this.opportunityOwnerId,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    regionId: regionId ?? this.regionId,
    regionName: regionName.present ? regionName.value : this.regionName,
    regionCity: regionCity.present ? regionCity.value : this.regionCity,
    regionProvince: regionProvince.present
        ? regionProvince.value
        : this.regionProvince,
    endDate: endDate ?? this.endDate,
    source: source.present ? source.value : this.source,
    contact: contact.present ? contact.value : this.contact,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    localImageBytes: localImageBytes.present
        ? localImageBytes.value
        : this.localImageBytes,
    status: status ?? this.status,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  ArchivedOpportunity copyWithCompanion(ArchivedOpportunitiesCompanion data) {
    return ArchivedOpportunity(
      opportunityId: data.opportunityId.present
          ? data.opportunityId.value
          : this.opportunityId,
      userId: data.userId.present ? data.userId.value : this.userId,
      opportunityOwnerId: data.opportunityOwnerId.present
          ? data.opportunityOwnerId.value
          : this.opportunityOwnerId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      regionName: data.regionName.present
          ? data.regionName.value
          : this.regionName,
      regionCity: data.regionCity.present
          ? data.regionCity.value
          : this.regionCity,
      regionProvince: data.regionProvince.present
          ? data.regionProvince.value
          : this.regionProvince,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      source: data.source.present ? data.source.value : this.source,
      contact: data.contact.present ? data.contact.value : this.contact,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      localImageBytes: data.localImageBytes.present
          ? data.localImageBytes.value
          : this.localImageBytes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArchivedOpportunity(')
          ..write('opportunityId: $opportunityId, ')
          ..write('userId: $userId, ')
          ..write('opportunityOwnerId: $opportunityOwnerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('regionId: $regionId, ')
          ..write('regionName: $regionName, ')
          ..write('regionCity: $regionCity, ')
          ..write('regionProvince: $regionProvince, ')
          ..write('endDate: $endDate, ')
          ..write('source: $source, ')
          ..write('contact: $contact, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('localImageBytes: $localImageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opportunityId,
    userId,
    opportunityOwnerId,
    title,
    description,
    category,
    regionId,
    regionName,
    regionCity,
    regionProvince,
    endDate,
    source,
    contact,
    imageUrl,
    $driftBlobEquality.hash(localImageBytes),
    status,
    createdAt,
    deletedAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArchivedOpportunity &&
          other.opportunityId == this.opportunityId &&
          other.userId == this.userId &&
          other.opportunityOwnerId == this.opportunityOwnerId &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.regionId == this.regionId &&
          other.regionName == this.regionName &&
          other.regionCity == this.regionCity &&
          other.regionProvince == this.regionProvince &&
          other.endDate == this.endDate &&
          other.source == this.source &&
          other.contact == this.contact &&
          other.imageUrl == this.imageUrl &&
          $driftBlobEquality.equals(
            other.localImageBytes,
            this.localImageBytes,
          ) &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.cachedAt == this.cachedAt);
}

class ArchivedOpportunitiesCompanion
    extends UpdateCompanion<ArchivedOpportunity> {
  final Value<String> opportunityId;
  final Value<String> userId;
  final Value<String> opportunityOwnerId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> regionId;
  final Value<String?> regionName;
  final Value<String?> regionCity;
  final Value<String?> regionProvince;
  final Value<DateTime> endDate;
  final Value<String?> source;
  final Value<String?> contact;
  final Value<String?> imageUrl;
  final Value<Uint8List?> localImageBytes;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const ArchivedOpportunitiesCompanion({
    this.opportunityId = const Value.absent(),
    this.userId = const Value.absent(),
    this.opportunityOwnerId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.regionId = const Value.absent(),
    this.regionName = const Value.absent(),
    this.regionCity = const Value.absent(),
    this.regionProvince = const Value.absent(),
    this.endDate = const Value.absent(),
    this.source = const Value.absent(),
    this.contact = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.localImageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArchivedOpportunitiesCompanion.insert({
    required String opportunityId,
    required String userId,
    this.opportunityOwnerId = const Value.absent(),
    required String title,
    required String description,
    required String category,
    required String regionId,
    this.regionName = const Value.absent(),
    this.regionCity = const Value.absent(),
    this.regionProvince = const Value.absent(),
    required DateTime endDate,
    this.source = const Value.absent(),
    this.contact = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.localImageBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : opportunityId = Value(opportunityId),
       userId = Value(userId),
       title = Value(title),
       description = Value(description),
       category = Value(category),
       regionId = Value(regionId),
       endDate = Value(endDate),
       cachedAt = Value(cachedAt);
  static Insertable<ArchivedOpportunity> custom({
    Expression<String>? opportunityId,
    Expression<String>? userId,
    Expression<String>? opportunityOwnerId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? regionId,
    Expression<String>? regionName,
    Expression<String>? regionCity,
    Expression<String>? regionProvince,
    Expression<DateTime>? endDate,
    Expression<String>? source,
    Expression<String>? contact,
    Expression<String>? imageUrl,
    Expression<Uint8List>? localImageBytes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opportunityId != null) 'opportunity_id': opportunityId,
      if (userId != null) 'user_id': userId,
      if (opportunityOwnerId != null)
        'opportunity_owner_id': opportunityOwnerId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (regionId != null) 'region_id': regionId,
      if (regionName != null) 'region_name': regionName,
      if (regionCity != null) 'region_city': regionCity,
      if (regionProvince != null) 'region_province': regionProvince,
      if (endDate != null) 'end_date': endDate,
      if (source != null) 'source': source,
      if (contact != null) 'contact': contact,
      if (imageUrl != null) 'image_url': imageUrl,
      if (localImageBytes != null) 'local_image_bytes': localImageBytes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArchivedOpportunitiesCompanion copyWith({
    Value<String>? opportunityId,
    Value<String>? userId,
    Value<String>? opportunityOwnerId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<String>? regionId,
    Value<String?>? regionName,
    Value<String?>? regionCity,
    Value<String?>? regionProvince,
    Value<DateTime>? endDate,
    Value<String?>? source,
    Value<String?>? contact,
    Value<String?>? imageUrl,
    Value<Uint8List?>? localImageBytes,
    Value<String>? status,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return ArchivedOpportunitiesCompanion(
      opportunityId: opportunityId ?? this.opportunityId,
      userId: userId ?? this.userId,
      opportunityOwnerId: opportunityOwnerId ?? this.opportunityOwnerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      regionCity: regionCity ?? this.regionCity,
      regionProvince: regionProvince ?? this.regionProvince,
      endDate: endDate ?? this.endDate,
      source: source ?? this.source,
      contact: contact ?? this.contact,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageBytes: localImageBytes ?? this.localImageBytes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opportunityId.present) {
      map['opportunity_id'] = Variable<String>(opportunityId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (opportunityOwnerId.present) {
      map['opportunity_owner_id'] = Variable<String>(opportunityOwnerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<String>(regionId.value);
    }
    if (regionName.present) {
      map['region_name'] = Variable<String>(regionName.value);
    }
    if (regionCity.present) {
      map['region_city'] = Variable<String>(regionCity.value);
    }
    if (regionProvince.present) {
      map['region_province'] = Variable<String>(regionProvince.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (localImageBytes.present) {
      map['local_image_bytes'] = Variable<Uint8List>(localImageBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArchivedOpportunitiesCompanion(')
          ..write('opportunityId: $opportunityId, ')
          ..write('userId: $userId, ')
          ..write('opportunityOwnerId: $opportunityOwnerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('regionId: $regionId, ')
          ..write('regionName: $regionName, ')
          ..write('regionCity: $regionCity, ')
          ..write('regionProvince: $regionProvince, ')
          ..write('endDate: $endDate, ')
          ..write('source: $source, ')
          ..write('contact: $contact, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('localImageBytes: $localImageBytes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $RegionsTable regions = $RegionsTable(this);
  late final $SavedOpportunitiesTable savedOpportunities =
      $SavedOpportunitiesTable(this);
  late final $ArchivedOpportunitiesTable archivedOpportunities =
      $ArchivedOpportunitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    regions,
    savedOpportunities,
    archivedOpportunities,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String userId,
      Value<String> name,
      Value<String> username,
      Value<String> email,
      Value<String> phone,
      Value<String> regionId,
      Value<String?> avatarUrl,
      Value<String?> avatarLocalPath,
      Value<bool> isContributor,
      Value<bool> isAdmin,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> userId,
      Value<String> name,
      Value<String> username,
      Value<String> email,
      Value<String> phone,
      Value<String> regionId,
      Value<String?> avatarUrl,
      Value<String?> avatarLocalPath,
      Value<bool> isContributor,
      Value<bool> isAdmin,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarLocalPath => $composableBuilder(
    column: $table.avatarLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isContributor => $composableBuilder(
    column: $table.isContributor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarLocalPath => $composableBuilder(
    column: $table.avatarLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isContributor => $composableBuilder(
    column: $table.isContributor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get avatarLocalPath => $composableBuilder(
    column: $table.avatarLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isContributor => $composableBuilder(
    column: $table.isContributor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAdmin =>
      $composableBuilder(column: $table.isAdmin, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> regionId = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> avatarLocalPath = const Value.absent(),
                Value<bool> isContributor = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                userId: userId,
                name: name,
                username: username,
                email: email,
                phone: phone,
                regionId: regionId,
                avatarUrl: avatarUrl,
                avatarLocalPath: avatarLocalPath,
                isContributor: isContributor,
                isAdmin: isAdmin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<String> name = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> regionId = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> avatarLocalPath = const Value.absent(),
                Value<bool> isContributor = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                userId: userId,
                name: name,
                username: username,
                email: email,
                phone: phone,
                regionId: regionId,
                avatarUrl: avatarUrl,
                avatarLocalPath: avatarLocalPath,
                isContributor: isContributor,
                isAdmin: isAdmin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$RegionsTableCreateCompanionBuilder = RegionsCompanion Function({
  required String regionId,
  required String province,
  required String city,
  required String district,
  required String village,
  Value<int> rowid,
});
typedef $$RegionsTableUpdateCompanionBuilder = RegionsCompanion Function({
  Value<String> regionId,
  Value<String> province,
  Value<String> city,
  Value<String> district,
  Value<String> village,
  Value<int> rowid,
});

class $$RegionsTableFilterComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get village =>
      $composableBuilder(column: $table.village, builder: (column) => column);
}

class $$RegionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegionsTable,
          Region,
          $$RegionsTableFilterComposer,
          $$RegionsTableOrderingComposer,
          $$RegionsTableAnnotationComposer,
          $$RegionsTableCreateCompanionBuilder,
          $$RegionsTableUpdateCompanionBuilder,
          (Region, BaseReferences<_$AppDatabase, $RegionsTable, Region>),
          Region,
          PrefetchHooks Function()
        > {
  $$RegionsTableTableManager(_$AppDatabase db, $RegionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> regionId = const Value.absent(),
                Value<String> province = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> village = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegionsCompanion(
                regionId: regionId,
                province: province,
                city: city,
                district: district,
                village: village,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String regionId,
                required String province,
                required String city,
                required String district,
                required String village,
                Value<int> rowid = const Value.absent(),
              }) => RegionsCompanion.insert(
                regionId: regionId,
                province: province,
                city: city,
                district: district,
                village: village,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RegionsTable, Region>(table),
                  BaseReferences<_$AppDatabase, $RegionsTable, Region>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegionsTable,
      Region,
      $$RegionsTableFilterComposer,
      $$RegionsTableOrderingComposer,
      $$RegionsTableAnnotationComposer,
      $$RegionsTableCreateCompanionBuilder,
      $$RegionsTableUpdateCompanionBuilder,
      (Region, BaseReferences<_$AppDatabase, $RegionsTable, Region>),
      Region,
      PrefetchHooks Function()
    >;
typedef $$SavedOpportunitiesTableCreateCompanionBuilder =
    SavedOpportunitiesCompanion Function({
      required String opportunityId,
      required String userId,
      Value<String> opportunityOwnerId,
      required String title,
      required String description,
      required String category,
      required String regionId,
      Value<String?> regionName,
      Value<String?> regionCity,
      Value<String?> regionProvince,
      required DateTime endDate,
      Value<String?> source,
      Value<String?> contact,
      Value<String?> imageUrl,
      Value<Uint8List?> localImageBytes,
      Value<String> status,
      Value<DateTime?> createdAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$SavedOpportunitiesTableUpdateCompanionBuilder =
    SavedOpportunitiesCompanion Function({
      Value<String> opportunityId,
      Value<String> userId,
      Value<String> opportunityOwnerId,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<String> regionId,
      Value<String?> regionName,
      Value<String?> regionCity,
      Value<String?> regionProvince,
      Value<DateTime> endDate,
      Value<String?> source,
      Value<String?> contact,
      Value<String?> imageUrl,
      Value<Uint8List?> localImageBytes,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$SavedOpportunitiesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedOpportunitiesTable> {
  $$SavedOpportunitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedOpportunitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedOpportunitiesTable> {
  $$SavedOpportunitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedOpportunitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedOpportunitiesTable> {
  $$SavedOpportunitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$SavedOpportunitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedOpportunitiesTable,
          SavedOpportunity,
          $$SavedOpportunitiesTableFilterComposer,
          $$SavedOpportunitiesTableOrderingComposer,
          $$SavedOpportunitiesTableAnnotationComposer,
          $$SavedOpportunitiesTableCreateCompanionBuilder,
          $$SavedOpportunitiesTableUpdateCompanionBuilder,
          (
            SavedOpportunity,
            BaseReferences<
              _$AppDatabase,
              $SavedOpportunitiesTable,
              SavedOpportunity
            >,
          ),
          SavedOpportunity,
          PrefetchHooks Function()
        > {
  $$SavedOpportunitiesTableTableManager(
    _$AppDatabase db,
    $SavedOpportunitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedOpportunitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedOpportunitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedOpportunitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> opportunityId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> opportunityOwnerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> regionId = const Value.absent(),
                Value<String?> regionName = const Value.absent(),
                Value<String?> regionCity = const Value.absent(),
                Value<String?> regionProvince = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<Uint8List?> localImageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedOpportunitiesCompanion(
                opportunityId: opportunityId,
                userId: userId,
                opportunityOwnerId: opportunityOwnerId,
                title: title,
                description: description,
                category: category,
                regionId: regionId,
                regionName: regionName,
                regionCity: regionCity,
                regionProvince: regionProvince,
                endDate: endDate,
                source: source,
                contact: contact,
                imageUrl: imageUrl,
                localImageBytes: localImageBytes,
                status: status,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opportunityId,
                required String userId,
                Value<String> opportunityOwnerId = const Value.absent(),
                required String title,
                required String description,
                required String category,
                required String regionId,
                Value<String?> regionName = const Value.absent(),
                Value<String?> regionCity = const Value.absent(),
                Value<String?> regionProvince = const Value.absent(),
                required DateTime endDate,
                Value<String?> source = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<Uint8List?> localImageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedOpportunitiesCompanion.insert(
                opportunityId: opportunityId,
                userId: userId,
                opportunityOwnerId: opportunityOwnerId,
                title: title,
                description: description,
                category: category,
                regionId: regionId,
                regionName: regionName,
                regionCity: regionCity,
                regionProvince: regionProvince,
                endDate: endDate,
                source: source,
                contact: contact,
                imageUrl: imageUrl,
                localImageBytes: localImageBytes,
                status: status,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedOpportunitiesTable, SavedOpportunity>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SavedOpportunitiesTable,
                    SavedOpportunity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedOpportunitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedOpportunitiesTable,
      SavedOpportunity,
      $$SavedOpportunitiesTableFilterComposer,
      $$SavedOpportunitiesTableOrderingComposer,
      $$SavedOpportunitiesTableAnnotationComposer,
      $$SavedOpportunitiesTableCreateCompanionBuilder,
      $$SavedOpportunitiesTableUpdateCompanionBuilder,
      (
        SavedOpportunity,
        BaseReferences<
          _$AppDatabase,
          $SavedOpportunitiesTable,
          SavedOpportunity
        >,
      ),
      SavedOpportunity,
      PrefetchHooks Function()
    >;
typedef $$ArchivedOpportunitiesTableCreateCompanionBuilder =
    ArchivedOpportunitiesCompanion Function({
      required String opportunityId,
      required String userId,
      Value<String> opportunityOwnerId,
      required String title,
      required String description,
      required String category,
      required String regionId,
      Value<String?> regionName,
      Value<String?> regionCity,
      Value<String?> regionProvince,
      required DateTime endDate,
      Value<String?> source,
      Value<String?> contact,
      Value<String?> imageUrl,
      Value<Uint8List?> localImageBytes,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> deletedAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$ArchivedOpportunitiesTableUpdateCompanionBuilder =
    ArchivedOpportunitiesCompanion Function({
      Value<String> opportunityId,
      Value<String> userId,
      Value<String> opportunityOwnerId,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<String> regionId,
      Value<String?> regionName,
      Value<String?> regionCity,
      Value<String?> regionProvince,
      Value<DateTime> endDate,
      Value<String?> source,
      Value<String?> contact,
      Value<String?> imageUrl,
      Value<Uint8List?> localImageBytes,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$ArchivedOpportunitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ArchivedOpportunitiesTable> {
  $$ArchivedOpportunitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArchivedOpportunitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ArchivedOpportunitiesTable> {
  $$ArchivedOpportunitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArchivedOpportunitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArchivedOpportunitiesTable> {
  $$ArchivedOpportunitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opportunityId => $composableBuilder(
    column: $table.opportunityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get opportunityOwnerId => $composableBuilder(
    column: $table.opportunityOwnerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get regionName => $composableBuilder(
    column: $table.regionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regionCity => $composableBuilder(
    column: $table.regionCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regionProvince => $composableBuilder(
    column: $table.regionProvince,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<Uint8List> get localImageBytes => $composableBuilder(
    column: $table.localImageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ArchivedOpportunitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArchivedOpportunitiesTable,
          ArchivedOpportunity,
          $$ArchivedOpportunitiesTableFilterComposer,
          $$ArchivedOpportunitiesTableOrderingComposer,
          $$ArchivedOpportunitiesTableAnnotationComposer,
          $$ArchivedOpportunitiesTableCreateCompanionBuilder,
          $$ArchivedOpportunitiesTableUpdateCompanionBuilder,
          (
            ArchivedOpportunity,
            BaseReferences<
              _$AppDatabase,
              $ArchivedOpportunitiesTable,
              ArchivedOpportunity
            >,
          ),
          ArchivedOpportunity,
          PrefetchHooks Function()
        > {
  $$ArchivedOpportunitiesTableTableManager(
    _$AppDatabase db,
    $ArchivedOpportunitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArchivedOpportunitiesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ArchivedOpportunitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ArchivedOpportunitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> opportunityId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> opportunityOwnerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> regionId = const Value.absent(),
                Value<String?> regionName = const Value.absent(),
                Value<String?> regionCity = const Value.absent(),
                Value<String?> regionProvince = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<Uint8List?> localImageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArchivedOpportunitiesCompanion(
                opportunityId: opportunityId,
                userId: userId,
                opportunityOwnerId: opportunityOwnerId,
                title: title,
                description: description,
                category: category,
                regionId: regionId,
                regionName: regionName,
                regionCity: regionCity,
                regionProvince: regionProvince,
                endDate: endDate,
                source: source,
                contact: contact,
                imageUrl: imageUrl,
                localImageBytes: localImageBytes,
                status: status,
                createdAt: createdAt,
                deletedAt: deletedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opportunityId,
                required String userId,
                Value<String> opportunityOwnerId = const Value.absent(),
                required String title,
                required String description,
                required String category,
                required String regionId,
                Value<String?> regionName = const Value.absent(),
                Value<String?> regionCity = const Value.absent(),
                Value<String?> regionProvince = const Value.absent(),
                required DateTime endDate,
                Value<String?> source = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<Uint8List?> localImageBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => ArchivedOpportunitiesCompanion.insert(
                opportunityId: opportunityId,
                userId: userId,
                opportunityOwnerId: opportunityOwnerId,
                title: title,
                description: description,
                category: category,
                regionId: regionId,
                regionName: regionName,
                regionCity: regionCity,
                regionProvince: regionProvince,
                endDate: endDate,
                source: source,
                contact: contact,
                imageUrl: imageUrl,
                localImageBytes: localImageBytes,
                status: status,
                createdAt: createdAt,
                deletedAt: deletedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArchivedOpportunitiesTable, ArchivedOpportunity>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ArchivedOpportunitiesTable,
                    ArchivedOpportunity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArchivedOpportunitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArchivedOpportunitiesTable,
      ArchivedOpportunity,
      $$ArchivedOpportunitiesTableFilterComposer,
      $$ArchivedOpportunitiesTableOrderingComposer,
      $$ArchivedOpportunitiesTableAnnotationComposer,
      $$ArchivedOpportunitiesTableCreateCompanionBuilder,
      $$ArchivedOpportunitiesTableUpdateCompanionBuilder,
      (
        ArchivedOpportunity,
        BaseReferences<
          _$AppDatabase,
          $ArchivedOpportunitiesTable,
          ArchivedOpportunity
        >,
      ),
      ArchivedOpportunity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$RegionsTableTableManager get regions =>
      $$RegionsTableTableManager(_db, _db.regions);
  $$SavedOpportunitiesTableTableManager get savedOpportunities =>
      $$SavedOpportunitiesTableTableManager(_db, _db.savedOpportunities);
  $$ArchivedOpportunitiesTableTableManager get archivedOpportunities =>
      $$ArchivedOpportunitiesTableTableManager(_db, _db.archivedOpportunities);
}
