part of 'emails_list_cubit.dart';

sealed class EmailsListState extends Equatable {
  const EmailsListState();

  @override
  List<Object> get props => [];
}

final class EmailsListInitial extends EmailsListState {}

final class EmailsListLoaded extends EmailsListState {
  const EmailsListLoaded(this.emails);

  final List<Email> emails;

  @override
  List<Object> get props => [emails];
}
