import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MemberPaidTile extends StatelessWidget {
  final String memberName;
  final double amount;
  final bool isPaid;
  final VoidCallback onTogglePaid;

  const MemberPaidTile({
    super.key,
    required this.memberName,
    required this.amount,
    required this.isPaid,
    required this.onTogglePaid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPaid ? AppColors.success.withOpacity(0.2) : Colors.grey.shade200,
        child: Icon(
          isPaid ? Icons.check : Icons.person,
          color: isPaid ? AppColors.success : Colors.grey,
        ),
      ),
      title: Text(memberName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Amount: ETB ${amount.toStringAsFixed(2)}'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPaid ? AppColors.success : AppColors.primary,
        ),
        onPressed: onTogglePaid,
        child: Text(isPaid ? 'PAID' : 'MARK PAID'),
      ),
    );
  }
}
