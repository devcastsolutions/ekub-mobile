import 'package:equatable/equatable.dart';

abstract class GroupListEvent extends Equatable {
  const GroupListEvent();
  @override
  List<Object?> get props => [];
}

class FetchMyGroups extends GroupListEvent {}

class CreateGroupSubmitted extends GroupListEvent {
  final String name;
  final double contributionAmount;
  final String frequency;
  final String startDate;

  const CreateGroupSubmitted({
    required this.name,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
  });

  @override
  List<Object?> get props => [name, contributionAmount, frequency, startDate];
}

class StartGroupRequested extends GroupListEvent {
  final int groupId;
  final bool randomize;

  const StartGroupRequested({required this.groupId, this.randomize = false});

  @override
  List<Object?> get props => [groupId, randomize];
}
