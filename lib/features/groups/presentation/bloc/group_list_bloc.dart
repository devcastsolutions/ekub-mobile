import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/group_usecases.dart';
import 'group_list_event.dart';
import 'group_list_state.dart';

class GroupListBloc extends Bloc<GroupListEvent, GroupListState> {
  final GetMyGroupsUseCase getMyGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final StartGroupUseCase startGroupUseCase;

  GroupListBloc({
    required this.getMyGroupsUseCase,
    required this.createGroupUseCase,
    required this.startGroupUseCase,
  }) : super(GroupListInitial()) {
    on<FetchMyGroups>(_onFetchMyGroups);
    on<CreateGroupSubmitted>(_onCreateGroupSubmitted);
    on<StartGroupRequested>(_onStartGroupRequested);
  }

  Future<void> _onFetchMyGroups(
    FetchMyGroups event,
    Emitter<GroupListState> emit,
  ) async {
    emit(GroupListLoading());
    final result = await getMyGroupsUseCase();
    result.fold(
      (failure) => emit(GroupListError(failure.message)),
      (groups) => emit(GroupListLoaded(groups)),
    );
  }

  Future<void> _onCreateGroupSubmitted(
    CreateGroupSubmitted event,
    Emitter<GroupListState> emit,
  ) async {
    emit(GroupListLoading());
    final result = await createGroupUseCase(
      name: event.name,
      contributionAmount: event.contributionAmount,
      frequency: event.frequency,
      startDate: event.startDate,
    );
    result.fold(
      (failure) => emit(GroupListError(failure.message)),
      (_) => add(FetchMyGroups()),
    );
  }

  Future<void> _onStartGroupRequested(
    StartGroupRequested event,
    Emitter<GroupListState> emit,
  ) async {
    emit(GroupListLoading());
    final result = await startGroupUseCase(event.groupId, event.randomize);
    result.fold(
      (failure) => emit(GroupListError(failure.message)),
      (_) => add(FetchMyGroups()),
    );
  }
}
