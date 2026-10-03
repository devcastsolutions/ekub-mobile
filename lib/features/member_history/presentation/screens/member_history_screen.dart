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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'My Contribution History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Merkato Traders Circle',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
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
            final String totalPaidFormatted = '${st.totalContributionsPaid.toInt()} Birr';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Summary Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL CONTRIBUTIONS PAID',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                st.turnOrder != null ? 'Turn #${st.turnOrder}' : 'Turn Pending',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          totalPaidFormatted,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: st.totalRoundsCount > 0 ? (st.roundsPaidCount / st.totalRoundsCount) : 0,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${st.roundsPaidCount} of ${st.totalRoundsCount} rounds completed',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              st.hasBeenPaidOut ? 'Payout Received' : 'Payout Upcoming',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Detail Tiles Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF3EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star_outline, color: AppColors.accent, size: 20),
                          ),
                          title: const Text('Turn Position', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(st.turnOrder != null ? 'Assigned Turn #${st.turnOrder}' : 'Not assigned yet'),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              st.hasBeenPaidOut ? Icons.check_circle_outline : Icons.hourglass_top,
                              color: st.hasBeenPaidOut ? AppColors.primary : AppColors.accent,
                              size: 20,
                            ),
                          ),
                          title: const Text('Payout Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(st.hasBeenPaidOut ? 'Disbursed to bank account' : 'Pending turn sequence'),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF2F1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history, color: AppColors.primary, size: 20),
                          ),
                          title: const Text('Rounds Paid Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text('${st.roundsPaidCount} payments of ${st.totalRoundsCount} verified'),
                        ),
                        if (st.nextPayoutDate != null) ...[
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE3F2FD),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_month_outlined, color: Colors.blue, size: 20),
                            ),
                            title: const Text('Estimated Payout Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text(st.nextPayoutDate!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
