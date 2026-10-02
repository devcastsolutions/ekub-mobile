import 'package:equatable/equatable.dart';
import '../../domain/entities/contribution.dart';

abstract class ContributionEvent extends Equatable {
  const ContributionEvent();
  @override
  List<Object?> get props => [];
}

class LogMemberContribution extends ContributionEvent {
  final int roundId;
  final int memberId;
  final double amount;
  final String status;

  const LogMemberContribution({
    required this.roundId,
    required this.memberId,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [roundId, memberId, amount, status];
}

class CloseRoundRequested extends ContributionEvent {
  final int roundId;
  const CloseRoundRequested(this.roundId);

  @override
  List<Object?> get props => [roundId];
}

abstract class ContributionState extends Equatable {
  const ContributionState();
  @override
  List<Object?> get props => [];
}

class ContributionInitial extends ContributionState {}

class ContributionLoading extends ContributionState {}

class ContributionLoggedSuccess extends ContributionState {
  final Contribution contribution;
  const ContributionLoggedSuccess(this.contribution);

  @override
  List<Object?> get props => [contribution];
}

class RoundClosedSuccess extends ContributionState {}

class ContributionError extends ContributionState {
  final String message;
  const ContributionError(this.message);

  @override
  List<Object?> get props => [message];
}
