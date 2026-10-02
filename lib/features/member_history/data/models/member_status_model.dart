import '../../domain/entities/member_status.dart';

class MemberStatusModel extends MemberStatus {
  const MemberStatusModel({
    required super.groupId,
    required super.groupName,
    required super.userId,
    super.turnOrder,
    required super.hasBeenPaidOut,
    required super.totalContributionsPaid,
    required super.roundsPaidCount,
    required super.totalRoundsCount,
    super.nextPayoutDate,
  });

  factory MemberStatusModel.fromJson(Map<String, dynamic> json) {
    return MemberStatusModel(
      groupId: json['group_id'] as int,
      groupName: json['group_name'] as String,
      userId: json['user_id'] as int,
      turnOrder: json['turn_order'] as int?,
      hasBeenPaidOut: json['has_been_paid_out'] as bool,
      totalContributionsPaid: (json['total_contributions_paid'] as num).toDouble(),
      roundsPaidCount: json['rounds_paid_count'] as int,
      totalRoundsCount: json['total_rounds_count'] as int,
      nextPayoutDate: json['next_payout_date'] as String?,
    );
  }
}
