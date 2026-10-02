import '../../domain/entities/contribution.dart';

class ContributionModel extends Contribution {
  const ContributionModel({
    required super.id,
    required super.roundId,
    required super.memberId,
    required super.amount,
    required super.status,
    required super.paidAt,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      id: json['id'] as int,
      roundId: json['round_id'] as int,
      memberId: json['member_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidAt: json['paid_at'] as String,
    );
  }
}
