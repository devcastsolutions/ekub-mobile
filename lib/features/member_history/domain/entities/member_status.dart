import 'package:equatable/equatable.dart';

class MemberStatus extends Equatable {
  final int groupId;
  final String groupName;
  final int userId;
  final int? turnOrder;
  final bool hasBeenPaidOut;
  final double totalContributionsPaid;
  final int roundsPaidCount;
  final int totalRoundsCount;
  final String? nextPayoutDate;

  const MemberStatus({
    required this.groupId,
    required this.groupName,
    required this.userId,
    this.turnOrder,
    required this.hasBeenPaidOut,
    required this.totalContributionsPaid,
    required this.roundsPaidCount,
    required this.totalRoundsCount,
    this.nextPayoutDate,
  });

  @override
  List<Object?> get props => [
        groupId,
        groupName,
        userId,
        turnOrder,
        hasBeenPaidOut,
        totalContributionsPaid,
        roundsPaidCount,
        totalRoundsCount,
        nextPayoutDate,
      ];
}
