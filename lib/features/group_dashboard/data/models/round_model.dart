import '../../domain/entities/dashboard_entities.dart';

class RoundModel extends EkubRound {
  const RoundModel({
    required super.id,
    required super.groupId,
    required super.roundNumber,
    required super.dueDate,
    required super.payoutMemberId,
    required super.status,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      roundNumber: json['round_number'] as int,
      dueDate: json['due_date'] as String,
      payoutMemberId: json['payout_member_id'] as int,
      status: json['status'] as String,
    );
  }
}
