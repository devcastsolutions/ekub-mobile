import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = group.status.toLowerCase();

    if (status == 'pending') {
      return _buildPendingCard(context);
    } else if (status == 'completed') {
      return _buildCompletedCard(context);
    } else {
      return _buildActiveCard(context);
    }
  }

  Widget _buildActiveCard(BuildContext context) {
    final potAmount = (group.contributionAmount * 12).toInt(); // Estimated payout pot

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined, size: 20, color: AppColors.textPrimary),
                        const SizedBox(width: 8),
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge('• Active', AppColors.statusActiveBg, AppColors.statusActiveText),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.contributionAmount.toInt()} Birr  •  ${_capitalize(group.frequency)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),

                // Grey inner pot box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payout Pot', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text(
                            '$potAmount Birr',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('Round 7 of 12', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          SizedBox(height: 2),
                          Text(
                            'Draw in 2 days',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Footer row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildAvatarStack(),
                        const SizedBox(width: 8),
                        const Text(
                          '+12 members',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'View Pod',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 18, color: AppColors.textPrimary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
              _buildStatusBadge('Pending', AppColors.statusPendingBg, AppColors.statusPendingText),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${group.contributionAmount.toInt()} Birr  •  ${_capitalize(group.frequency)}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Waiting for members inner box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.person_add_outlined, size: 20, color: AppColors.textSecondary),
                SizedBox(width: 10),
                Text(
                  'Waiting for 2 more members to start cycle',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('4 of 6 joined', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Row(
                children: [
                  Text(
                    'Invite Relatives',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accent),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.share_outlined, size: 16, color: AppColors.accent),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
              _buildStatusBadge('Completed', AppColors.statusCompletedBg, AppColors.statusCompletedText),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${group.contributionAmount.toInt()} Birr  •  ${_capitalize(group.frequency)}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'All 10 rounds distributed successfully',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Icon(Icons.verified_outlined, size: 18, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Settled on Oct 2024', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Row(
                children: [
                  Text(
                    'Archive Record',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.article_outlined, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 50,
      height: 24,
      child: Stack(
        children: [
          _avatarCircle('MT', const Color(0xFFE07A5F), 0),
          _avatarCircle('AS', const Color(0xFF81B29A), 14),
          _avatarCircle('HW', const Color(0xFFF2CC8F), 28),
        ],
      ),
    );
  }

  Widget _avatarCircle(String text, Color color, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';
}
