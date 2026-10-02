import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/member_status.dart';
import '../../domain/repositories/member_status_repository.dart';

abstract class MemberHistoryEvent extends Equatable {
  const MemberHistoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadMemberStatus extends MemberHistoryEvent {
  final int groupId;
  const LoadMemberStatus(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

abstract class MemberHistoryState extends Equatable {
  const MemberHistoryState();
  @override
  List<Object?> get props => [];
}

class MemberHistoryInitial extends MemberHistoryState {}
class MemberHistoryLoading extends MemberHistoryState {}
class MemberHistoryLoaded extends MemberHistoryState {
  final MemberStatus status;
  const MemberHistoryLoaded(this.status);
  @override
  List<Object?> get props => [status];
}
class MemberHistoryError extends MemberHistoryState {
  final String message;
  const MemberHistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class MemberHistoryBloc extends Bloc<MemberHistoryEvent, MemberHistoryState> {
  final GetMyStatusUseCase getMyStatusUseCase;

  MemberHistoryBloc({required this.getMyStatusUseCase}) : super(MemberHistoryInitial()) {
    on<LoadMemberStatus>((event, emit) async {
      emit(MemberHistoryLoading());
      final result = await getMyStatusUseCase(event.groupId);
      result.fold(
        (failure) => emit(MemberHistoryError(failure.message)),
        (status) => emit(MemberHistoryLoaded(status)),
      );
    });
  }
}
