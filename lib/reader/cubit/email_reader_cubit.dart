import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

class EmailReaderCubit extends Cubit<EmailReaderState> {
  EmailReaderCubit({
    required this.id,
    required this.storage,
  }) : super(EmailReaderInitial()) {
    _loadEmail();
  }

  final Storage storage;
  final int id;

  Future<void> _loadEmail() async {
    try {
      final email = await storage.read<Email>(id);
      if (email != null) {
        emit(EmailReaderLoaded(email));
      }
    } catch (e) {
      print('Failed to load email: $e');
    }
  }
}

sealed class EmailReaderState extends Equatable {
  const EmailReaderState();

  @override
  List<Object> get props => [];
}

final class EmailReaderInitial extends EmailReaderState {}

final class EmailReaderLoaded extends EmailReaderState {
  const EmailReaderLoaded(this.email);

  final Email email;

  @override
  List<Object> get props => [email];
}
