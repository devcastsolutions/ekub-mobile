import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/contribution_repository.dart';
import 'contribution_event_state.dart';

class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  final LogContributionUseCase logContributionUseCase;
  final CloseRoundUseCase closeRoundUseCase;

  ContributionBloc({
    required this.logContributionUseCase,
    required this.closeRoundUseCase,
  }) : super(ContributionInitial()) {
    on<LogMemberContribution>(_onLogMemberContribution);
    on<CloseRoundRequested>(_onCloseRoundRequested);
  }

  Future<void> _onLogMemberContribution(
    LogMemberContribution event,
    Emitter<ContributionState> emit,
  ) async {
    emit(ContributionLoading());
    final result = await logContributionUseCase(
      roundId: event.roundId,
      memberId: event.memberId,
      amount: event.amount,
      status: event.status,
    );
    result.fold(
      (failure) => emit(ContributionError(failure.message)),
      (contrib) => emit(ContributionLoggedSuccess(contrib)),
    );
  }

  Future<void> _onCloseRoundRequested(
    CloseRoundRequested event,
    Emitter<ContributionState> emit,
  ) async {
    emit(ContributionLoading());
    final result = await closeRoundUseCase(event.roundId);
    result.fold(
      (failure) => emit(ContributionError(failure.message)),
      (_) => emit(RoundClosedSuccess()),
    );
  }
}
