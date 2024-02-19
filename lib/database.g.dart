// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EmailItemsTable extends EmailItems
    with TableInfo<$EmailItemsTable, EmailItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientMeta =
      const VerificationMeta('recipient');
  @override
  late final GeneratedColumn<String> recipient = GeneratedColumn<String>(
      'recipient', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
      'sender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<EmailStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<EmailStatus>($EmailItemsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        content,
        subject,
        recipient,
        sender,
        sentAt,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_items';
  @override
  VerificationContext validateIntegrity(Insertable<EmailItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('recipient')) {
      context.handle(_recipientMeta,
          recipient.isAcceptableOrUnknown(data['recipient']!, _recipientMeta));
    } else if (isInserting) {
      context.missing(_recipientMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta,
          sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      recipient: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient'])!,
      sender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender'])!,
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at']),
      status: $EmailItemsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EmailItemsTable createAlias(String alias) {
    return $EmailItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmailStatus, String, String> $converterstatus =
      const EnumNameConverter<EmailStatus>(EmailStatus.values);
}

class EmailItem extends DataClass implements Insertable<EmailItem> {
  final int id;
  final String content;
  final String subject;
  final String recipient;
  final String sender;
  final DateTime? sentAt;
  final EmailStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EmailItem(
      {required this.id,
      required this.content,
      required this.subject,
      required this.recipient,
      required this.sender,
      this.sentAt,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['subject'] = Variable<String>(subject);
    map['recipient'] = Variable<String>(recipient);
    map['sender'] = Variable<String>(sender);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    {
      map['status'] =
          Variable<String>($EmailItemsTable.$converterstatus.toSql(status));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmailItemsCompanion toCompanion(bool nullToAbsent) {
    return EmailItemsCompanion(
      id: Value(id),
      content: Value(content),
      subject: Value(subject),
      recipient: Value(recipient),
      sender: Value(sender),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmailItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailItem(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      subject: serializer.fromJson<String>(json['subject']),
      recipient: serializer.fromJson<String>(json['recipient']),
      sender: serializer.fromJson<String>(json['sender']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      status: $EmailItemsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'subject': serializer.toJson<String>(subject),
      'recipient': serializer.toJson<String>(recipient),
      'sender': serializer.toJson<String>(sender),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'status': serializer
          .toJson<String>($EmailItemsTable.$converterstatus.toJson(status)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmailItem copyWith(
          {int? id,
          String? content,
          String? subject,
          String? recipient,
          String? sender,
          Value<DateTime?> sentAt = const Value.absent(),
          EmailStatus? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      EmailItem(
        id: id ?? this.id,
        content: content ?? this.content,
        subject: subject ?? this.subject,
        recipient: recipient ?? this.recipient,
        sender: sender ?? this.sender,
        sentAt: sentAt.present ? sentAt.value : this.sentAt,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('EmailItem(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('subject: $subject, ')
          ..write('recipient: $recipient, ')
          ..write('sender: $sender, ')
          ..write('sentAt: $sentAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, subject, recipient, sender,
      sentAt, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailItem &&
          other.id == this.id &&
          other.content == this.content &&
          other.subject == this.subject &&
          other.recipient == this.recipient &&
          other.sender == this.sender &&
          other.sentAt == this.sentAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmailItemsCompanion extends UpdateCompanion<EmailItem> {
  final Value<int> id;
  final Value<String> content;
  final Value<String> subject;
  final Value<String> recipient;
  final Value<String> sender;
  final Value<DateTime?> sentAt;
  final Value<EmailStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EmailItemsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.subject = const Value.absent(),
    this.recipient = const Value.absent(),
    this.sender = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmailItemsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required String subject,
    required String recipient,
    required String sender,
    this.sentAt = const Value.absent(),
    required EmailStatus status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : content = Value(content),
        subject = Value(subject),
        recipient = Value(recipient),
        sender = Value(sender),
        status = Value(status);
  static Insertable<EmailItem> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? subject,
    Expression<String>? recipient,
    Expression<String>? sender,
    Expression<DateTime>? sentAt,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (subject != null) 'subject': subject,
      if (recipient != null) 'recipient': recipient,
      if (sender != null) 'sender': sender,
      if (sentAt != null) 'sent_at': sentAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmailItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? content,
      Value<String>? subject,
      Value<String>? recipient,
      Value<String>? sender,
      Value<DateTime?>? sentAt,
      Value<EmailStatus>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return EmailItemsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      recipient: recipient ?? this.recipient,
      sender: sender ?? this.sender,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (recipient.present) {
      map['recipient'] = Variable<String>(recipient.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $EmailItemsTable.$converterstatus.toSql(status.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailItemsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('subject: $subject, ')
          ..write('recipient: $recipient, ')
          ..write('sender: $sender, ')
          ..write('sentAt: $sentAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SynchronizationTaskItemsTable extends SynchronizationTaskItems
    with TableInfo<$SynchronizationTaskItemsTable, SynchronizationTaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SynchronizationTaskItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SynchronizationTaskStatus, String>
      status = GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SynchronizationTaskStatus>(
              $SynchronizationTaskItemsTable.$converterstatus);
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumnWithTypeConverter<SynchronizationTaskTable, String>
      table = GeneratedColumn<String>('table', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SynchronizationTaskTable>(
              $SynchronizationTaskItemsTable.$convertertable);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, entityId, status, table, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'synchronization_task_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<SynchronizationTaskItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    context.handle(_tableMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SynchronizationTaskItem map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SynchronizationTaskItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      status: $SynchronizationTaskItemsTable.$converterstatus.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      table: $SynchronizationTaskItemsTable.$convertertable.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}table'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SynchronizationTaskItemsTable createAlias(String alias) {
    return $SynchronizationTaskItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SynchronizationTaskStatus, String, String>
      $converterstatus = const EnumNameConverter<SynchronizationTaskStatus>(
          SynchronizationTaskStatus.values);
  static JsonTypeConverter2<SynchronizationTaskTable, String, String>
      $convertertable = const EnumNameConverter<SynchronizationTaskTable>(
          SynchronizationTaskTable.values);
}

class SynchronizationTaskItem extends DataClass
    implements Insertable<SynchronizationTaskItem> {
  final int id;
  final String name;
  final int entityId;
  final SynchronizationTaskStatus status;
  final SynchronizationTaskTable table;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SynchronizationTaskItem(
      {required this.id,
      required this.name,
      required this.entityId,
      required this.status,
      required this.table,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['entity_id'] = Variable<int>(entityId);
    {
      map['status'] = Variable<String>(
          $SynchronizationTaskItemsTable.$converterstatus.toSql(status));
    }
    {
      map['table'] = Variable<String>(
          $SynchronizationTaskItemsTable.$convertertable.toSql(table));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SynchronizationTaskItemsCompanion toCompanion(bool nullToAbsent) {
    return SynchronizationTaskItemsCompanion(
      id: Value(id),
      name: Value(name),
      entityId: Value(entityId),
      status: Value(status),
      table: Value(table),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SynchronizationTaskItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SynchronizationTaskItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      entityId: serializer.fromJson<int>(json['entityId']),
      status: $SynchronizationTaskItemsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      table: $SynchronizationTaskItemsTable.$convertertable
          .fromJson(serializer.fromJson<String>(json['table'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'entityId': serializer.toJson<int>(entityId),
      'status': serializer.toJson<String>(
          $SynchronizationTaskItemsTable.$converterstatus.toJson(status)),
      'table': serializer.toJson<String>(
          $SynchronizationTaskItemsTable.$convertertable.toJson(table)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SynchronizationTaskItem copyWith(
          {int? id,
          String? name,
          int? entityId,
          SynchronizationTaskStatus? status,
          SynchronizationTaskTable? table,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SynchronizationTaskItem(
        id: id ?? this.id,
        name: name ?? this.name,
        entityId: entityId ?? this.entityId,
        status: status ?? this.status,
        table: table ?? this.table,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('SynchronizationTaskItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('table: $table, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, entityId, status, table, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SynchronizationTaskItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.entityId == this.entityId &&
          other.status == this.status &&
          other.table == this.table &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SynchronizationTaskItemsCompanion
    extends UpdateCompanion<SynchronizationTaskItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> entityId;
  final Value<SynchronizationTaskStatus> status;
  final Value<SynchronizationTaskTable> table;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SynchronizationTaskItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.table = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SynchronizationTaskItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int entityId,
    required SynchronizationTaskStatus status,
    required SynchronizationTaskTable table,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        entityId = Value(entityId),
        status = Value(status),
        table = Value(table);
  static Insertable<SynchronizationTaskItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? entityId,
    Expression<String>? status,
    Expression<String>? table,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (entityId != null) 'entity_id': entityId,
      if (status != null) 'status': status,
      if (table != null) 'table': table,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SynchronizationTaskItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? entityId,
      Value<SynchronizationTaskStatus>? status,
      Value<SynchronizationTaskTable>? table,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SynchronizationTaskItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      table: table ?? this.table,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $SynchronizationTaskItemsTable.$converterstatus.toSql(status.value));
    }
    if (table.present) {
      map['table'] = Variable<String>(
          $SynchronizationTaskItemsTable.$convertertable.toSql(table.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SynchronizationTaskItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('table: $table, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $EmailItemsTable emailItems = $EmailItemsTable(this);
  late final $SynchronizationTaskItemsTable synchronizationTaskItems =
      $SynchronizationTaskItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [emailItems, synchronizationTaskItems];
}
