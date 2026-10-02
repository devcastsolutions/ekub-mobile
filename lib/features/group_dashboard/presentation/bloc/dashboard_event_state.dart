import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entities.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final int groupId;
  const LoadDashboardData(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<EkubRound> rounds;
  const DashboardLoaded(this.rounds);

  @override
  List<Object?> get props => [rounds];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
