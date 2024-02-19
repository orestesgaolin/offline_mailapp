import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

class EmailSenderCubit extends Cubit<EmailSenderState> {
  EmailSenderCubit(this.storage) : super(NotSendingState());

  final Storage storage;

  void sendEmail(int id) async {
    // TODO(dominik): 2. Read current email from storage and update its status to pendingSending
    // 3. Add synchronization task to send email
    emit(SendingInProgressState());

    emit(SendingSuccessState());
  }

  Future<void> cancelSending(int id) async {
    final email = await storage.read<Email>(id);
    if (email == null) return;

    if (email.status != EmailStatus.pendingSending) return;

    // Get task related to sending this email

    final task = await storage.find<SynchronizationTask>(
      where: 'entity_id = ${email.id}',
    );

    if (task == null) return;

    if (task.status != SynchronizationTaskStatus.pending) return;

    // TODO(dominik): 6. Cancel sending of the email

    // Update task to indicate that it's canceled
    // await storage.save<SynchronizationTask>(
    //   task.id,
    //   task.copyWith(
    //     status: SynchronizationTaskStatus.canceled,
    //     updatedAt: DateTime.now(),
    //   ),
    // );

    // // Update email to indicate that it's back in draft
    // await storage.save<Email>(
    //   id,
    //   email.copyWith(
    //     status: EmailStatus.draft,
    //     updatedAt: DateTime.now(),
    //   ),
    // );
  }
}

abstract class EmailSenderState extends Equatable {
  const EmailSenderState();
}

class NotSendingState extends EmailSenderState {
  @override
  List<Object> get props => [];
}

class SendingInProgressState extends EmailSenderState {
  @override
  List<Object> get props => [];
}

class SendingSuccessState extends EmailSenderState {
  @override
  List<Object> get props => [];
}


    // // read the email from the storage
    // final email = await storage.read<Email>(id);
    // if (email == null) {
    //   emit(NotSendingState());
    //   return;
    // }

    // // Add synchronization task to send email
    // // Update state to sending
    // final storedEmail = await storage.save<Email>(
    //   id,
    //   email.copyWith(
    //     status: EmailStatus.pendingSending,
    //     updatedAt: DateTime.now(),
    //   ),
    // );
    // await storage.create<SynchronizationTask>(
    //   SynchronizationTask.newTask(
    //     entityId: storedEmail.id,
    //     name: 'send_email',
    //     table: SynchronizationTaskTable.email,
    //   ),
    // );