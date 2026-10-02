import 'package:equatable/equatable.dart';

class Contribution extends Equatable {
  final int id;
  final int roundId;
  final int memberId;
  final double amount;
  final String status;
  final String paidAt;

  const Contribution({
    required this.id,
    required this.roundId,
    required this.memberId,
    required this.amount,
    required this.status,
    required this.paidAt,
  });

  @override
  List<Object?> get props => [id, roundId, memberId, amount, status, paidAt];
}
