import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/member_history_bloc.dart';

class MemberHistoryScreen extends StatefulWidget {
  final int groupId;
  const MemberHistoryScreen({super.key, required this.groupId});

  @override
  State<MemberHistoryScreen> createState() => _MemberHistoryScreenState();
}

class _MemberHistoryScreenState extends State<MemberHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MemberHistoryBloc>().add(LoadMemberStatus(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Contribution History')),
      body: BlocBuilder<MemberHistoryBloc, MemberHistoryState>(
        builder: (context, state) {
          if (state is MemberHistoryLoading) {
            return const LoadingIndicator(message: 'Loading status history...');
          } else if (state is MemberHistoryError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<MemberHistoryBloc>().add(LoadMemberStatus(widget.groupId)),
            );
          } else if (state is MemberHistoryLoaded) {
            final st = state.status;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        st.groupName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        leading: const Icon(Icons.star, color: AppColors.accent),
                        title: const Text('Turn Position'),
                        subtitle: Text(st.turnOrder != null ? '#${st.turnOrder}' : 'Not assigned yet'),
                      ),
                      ListTile(
                        leading: Icon(
                          st.hasBeenPaidOut ? Icons.check_circle : Icons.pending,
                          color: st.hasBeenPaidOut ? AppColors.success : AppColors.accent,
                        ),
                        title: const Text('Payout Received'),
                        subtitle: Text(st.hasBeenPaidOut ? 'Yes' : 'No'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.attach_money, color: AppColors.primary),
                        title: const Text('Total Amount Contributed'),
                        subtitle: Text('ETB ${st.totalContributionsPaid.toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.repeat, color: AppColors.secondary),
                        title: const Text('Rounds Paid Progress'),
                        subtitle: Text('${st.roundsPaidCount} of ${st.totalRoundsCount} rounds'),
                      ),
                      if (st.nextPayoutDate != null)
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: const Text('Estimated Payout Date'),
                          subtitle: Text(st.nextPayoutDate!),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
