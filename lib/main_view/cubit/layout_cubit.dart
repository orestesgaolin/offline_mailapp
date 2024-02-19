import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(this.storage) : super(InitialState());

  final Storage storage;
  StreamSubscription<Email?>? _documentSub;

  Future<void> newDocument() async {
    _documentSub?.cancel();
    final email = await storage.create<Email>(Email.newEmail());
    emit(ComposingState(email: email));
  }

  Future<void> editDocument(Email email) async {
    _documentSub?.cancel();
    emit(ComposingState(email: email));
  }

  void previewDocument(Email email) {
    emit(PreviewState(email: email));
    _documentSub?.cancel();
    _documentSub = storage.watch<Email>(email.id).listen((email) {
      if (email == null) {
        emit(InitialState());
      } else {
        emit(PreviewState(email: email));
      }
    });
  }

  void sendDocument() {
    _documentSub?.cancel();
    emit(InitialState());
  }

  void closeDocument() {
    _documentSub?.cancel();
    emit(InitialState());
  }

  @override
  Future<void> close() {
    _documentSub?.cancel();
    return super.close();
  }
}

sealed class LayoutState extends Equatable {
  const LayoutState();

  @override
  List<Object> get props => [];
}

final class InitialState extends LayoutState {}

class ComposingState extends LayoutState {
  const ComposingState({
    required this.email,
  });

  final Email email;

  @override
  List<Object> get props => [email];
}

class PreviewState extends LayoutState {
  const PreviewState({
    required this.email,
  });

  final Email email;

  @override
  List<Object> get props => [email];
}
