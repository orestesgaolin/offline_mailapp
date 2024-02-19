import 'package:equatable/equatable.dart';

sealed class Model extends Equatable {}

enum SynchronizationTaskStatus {
  pending,
  inProgress,
  completed,
  failed,
  canceled
}

enum SynchronizationTaskTable { email }

class SynchronizationTask extends Model {
  SynchronizationTask({
    required this.id,
    required this.name,
    required this.entityId,
    required this.table,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  SynchronizationTask.newTask({
    required this.name,
    required this.entityId,
    required this.table,
  })  : id = 0,
        status = SynchronizationTaskStatus.pending,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  final int id;
  final String name;
  final int entityId;
  final SynchronizationTaskTable table;
  final SynchronizationTaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props =>
      [id, name, entityId, table, status, createdAt, updatedAt];

  SynchronizationTask copyWith({
    int? id,
    String? name,
    int? entityId,
    SynchronizationTaskTable? table,
    SynchronizationTaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SynchronizationTask(
      id: id ?? this.id,
      name: name ?? this.name,
      entityId: entityId ?? this.entityId,
      table: table ?? this.table,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum EmailStatus {
  sent,
  pendingSending,
  sending,
  unread,
  received,
  draft;

  bool get canBeEdited => this == draft;
  bool get canBeStopped => this == pendingSending;
}

class Email extends Model {
  Email({
    required this.id,
    required this.content,
    required this.subject,
    required this.recipient,
    required this.sender,
    required this.sentAt,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  Email.newEmail()
      : id = 0,
        content = '',
        subject = '',
        recipient = '',
        sender = '',
        sentAt = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        status = EmailStatus.draft;

  final int id;
  final String content;
  final String subject;
  final String recipient;
  final String sender;
  final DateTime? sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EmailStatus status;

  @override
  List<Object?> get props => [
        id,
        content,
        subject,
        recipient,
        sender,
        sentAt,
        createdAt,
        updatedAt,
        status,
      ];

  Email copyWith({
    int? id,
    String? content,
    String? subject,
    String? recipient,
    String? sender,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    EmailStatus? status,
  }) {
    return Email(
      id: id ?? this.id,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      recipient: recipient ?? this.recipient,
      sender: sender ?? this.sender,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}
