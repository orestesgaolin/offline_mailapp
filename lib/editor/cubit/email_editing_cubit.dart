import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

class EmailEditingCubit extends Cubit<EmailEditingState> {
  EmailEditingCubit({
    required Email email,
    required this.storage,
  }) : super(EmailEditingState(email));

  final Storage storage;

  void updateSubject(String subject) async {
    try {
      final email = await storage.save<Email>(
        state.email.id,
        state.email.copyWith(
          subject: subject,
          updatedAt: DateTime.now(),
        ),
      );

      emit(EmailEditingState(email));
    } catch (e) {
      print('Failed to save email: $e');
    }
  }

  void updateRecipients(String recipients) async {
    try {
      final email = await storage.save<Email>(
        state.email.id,
        state.email.copyWith(
          recipient: recipients,
          updatedAt: DateTime.now(),
        ),
      );

      emit(EmailEditingState(email));
    } catch (e) {
      print('Failed to save email: $e');
    }
  }

  void updateContent(String content) async {
    try {
      final email = await storage.save<Email>(
        state.email.id,
        state.email.copyWith(
          content: content,
          updatedAt: DateTime.now(),
        ),
      );

      emit(EmailEditingState(email));
    } catch (e) {
      print('Failed to save email: $e');
    }
  }
}

class EmailEditingState extends Equatable {
  const EmailEditingState(this.email);

  final Email email;

  @override
  List<Object> get props => [email];
}
