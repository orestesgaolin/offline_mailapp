import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

part 'emails_list_state.dart';

class EmailsListCubit extends Cubit<EmailsListState> {
  EmailsListCubit(this.storage) : super(EmailsListInitial()) {
    init();
  }

  final Storage storage;
  late final StreamSubscription<List<Email>> _emailsSub;

  void init() {
    _emailsSub = storage.watchAll<Email>().listen((emails) {
      emit(EmailsListLoaded(emails));
    });
  }

  @override
  Future<void> close() {
    _emailsSub.cancel();
    return super.close();
  }
}
