import 'package:equatable/equatable.dart';
import '../../domain/entities/group.dart';

abstract class GroupListState extends Equatable {
  const GroupListState();
  @override
  List<Object?> get props => [];
}

class GroupListInitial extends GroupListState {}

class GroupListLoading extends GroupListState {}

class GroupListLoaded extends GroupListState {
  final List<Group> groups;
  const GroupListLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupListError extends GroupListState {
  final String message;
  const GroupListError(this.message);

  @override
  List<Object?> get props => [message];
}
