import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/contribution_bloc.dart';
import '../bloc/contribution_event_state.dart';

class AddContributionScreen extends StatefulWidget {
  final int roundId;
  const AddContributionScreen({super.key, required this.roundId});

  @override
  State<AddContributionScreen> createState() => _AddContributionScreenState();
}

class _AddContributionScreenState extends State<AddContributionScreen> {
  String _selectedFilter = 'All (5)';

  final List<Map<String, dynamic>> _members = [
    {
      'initials': 'AT',
      'name': 'Almaz Tadesse',
      'shortName': 'Almaz T...',
      'isBeneficiary': true,
      'isYou': false,
      'isPaid': true,
      'amount': '2,500 Birr',
      'method': 'via Tele...',
      'time': 'Oct 14, 09:12',
      'avatarColor': const Color(0xFFC8E6C9),
    },
    {
      'initials': 'DK',
      'name': 'Dawit Kebede',
      'shortName': 'Dawit Kebede',
      'isBeneficiary': false,
      'isYou': false,
      'isPaid': false,
      'note': '• Due to...',
      'avatarColor': const Color(0xFFE0E0E0),
    },
    {
      'initials': 'BM',
      'name': 'Bethlehem Mengistu',
      'shortName': 'Bethlehem Mengistu',
      'isBeneficiary': false,
      'isYou': false,
      'isPaid': true,
      'amount': '2,500 Birr',
      'method': 'via CBE ...',
      'time': 'Oct 14, 11:45',
      'avatarColor': const Color(0xFFC8E6C9),
    },
    {
      'initials': 'YG',
      'name': 'Yonas Girma',
      'shortName': 'Yonas Girma',
      'isBeneficiary': false,
      'isYou': false,
      'isPaid': false,
      'note': '• Cash inte...',
      'avatarColor': const Color(0xFFE0E0E0),
    },
    {
      'initials': 'ST',
      'name': 'Solomon Tadesse',
      'shortName': 'Solomon Tades...',
      'isBeneficiary': false,
      'isYou': true,
      'isPaid': true,
      'amount': '2,500 Birr',
      'method': 'via CBE ...',
      'time': 'Oct 13, 18:20',
      'avatarColor': const Color(0xFFC8E6C9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredMembers = _members;
    if (_selectedFilter == 'Pending (2)') {
      filteredMembers = _members.where((m) => !(m['isPaid'] as bool)).toList();
    } else if (_selectedFilter == 'Paid (3)') {
      filteredMembers = _members.where((m) => m['isPaid'] as bool).toList();
    }

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
          children: [
            Row(
              children: [
                const Text(
                  'Round 3 — Contributions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EBE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '3 of 5 paid',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Merkato Traders Circle • 2,500 Birr',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: BlocListener<ContributionBloc, ContributionState>(
        listener: (context, state) {
          if (state is ContributionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          } else if (state is RoundClosedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Round successfully closed!'), backgroundColor: AppColors.success),
            );
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Round Collection Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ROUND COLLECTION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFDE8E0),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.accent, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '7,500 ',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: '/ 12,500 Birr',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: const LinearProgressIndicator(
                              value: 0.60,
                              minHeight: 8,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '60% verified',
                                style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '2 pending',
                                style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Inner verification info box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.verified_user_outlined, size: 18, color: AppColors.textPrimary),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Verify via Telebirr, CBE Birr, or physical cash deposit.',
                                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. Filter Chips
                    Row(
                      children: [
                        _buildFilterChip('All (5)'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Pending (2)'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Paid (3)'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. Member Contribution List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredMembers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        final bool isPaid = member['isPaid'] as bool;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              // Avatar with status badge overlay
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: member['avatarColor'] as Color,
                                    child: Text(
                                      member['initials'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isPaid ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isPaid ? Icons.check_circle : Icons.circle_outlined,
                                        size: 14,
                                        color: isPaid ? AppColors.primary : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),

                              // Name & Subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          member['shortName'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        if (member['isBeneficiary'] == true) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFDE8E0),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'BENEFICIARY',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          ),
                                        ],
                                        if (member['isYou'] == true) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.inputFill,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'You',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    if (isPaid)
                                      Text(
                                        'Paid • ${member['amount']}   ${member['method']}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      )
                                    else
                                      Text(
                                        'Not paid yet   ${member['note']}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                  ],
                                ),
                              ),

                              // Right side: Date or Mark paid button
                              if (isPaid)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    member['time'] as String,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                )
                              else
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFE8F5E9),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      member['isPaid'] = true;
                                      member['amount'] = '2,500 Birr';
                                      member['method'] = 'via Telebirr';
                                      member['time'] = 'Just now';
                                      member['avatarColor'] = const Color(0xFFC8E6C9);
                                    });
                                  },
                                  icon: const Icon(Icons.check, size: 16, color: Color(0xFF1B5E20)),
                                  label: const Text(
                                    'Mark paid',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 4. Round 3 Payout Pool Notice Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.campaign_outlined, color: AppColors.accent, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Round 3 Payout Pool',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '12,500 Birr will disburse to Almaz Tadesse upon final collection.',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 5. Bottom Sticky Bar: Waiting for all members to pay
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EBE8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_outline, size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Text(
                          'Waiting for all members to pay',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '2 payments remaining before payout can be disbursed',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
