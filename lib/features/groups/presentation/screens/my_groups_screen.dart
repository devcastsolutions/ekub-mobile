import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/ekub_logo.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/group.dart';
import '../bloc/group_list_bloc.dart';
import '../bloc/group_list_event.dart';
import '../bloc/group_list_state.dart';
import '../widgets/group_card.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  int _selectedFilterIndex = 0;
  int _currentNavIndex = 0;

  final List<String> _filters = ['All Circles', 'Active', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    context.read<GroupListBloc>().add(FetchMyGroups());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildTabBody(context),
      ),
      floatingActionButton: _currentNavIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                _showCreateGroupDialog(context);
              },
              backgroundColor: AppColors.primary,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'New group',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (idx) => setState(() => _currentNavIndex = idx),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Payouts'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTabBody(BuildContext context) {
    switch (_currentNavIndex) {
      case 0:
        return _buildGroupsTab(context);
      case 1:
        return _buildPayoutsTab(context);
      case 2:
        return _buildActivityTab(context);
      case 3:
        return _buildProfileTab(context);
      default:
        return _buildGroupsTab(context);
    }
  }

  List<Group> _filterGroups(List<Group> groups) {
    if (_selectedFilterIndex == 1) {
      return groups.where((g) => g.status.toLowerCase() == 'active').toList();
    } else if (_selectedFilterIndex == 2) {
      return groups.where((g) => g.status.toLowerCase() == 'pending').toList();
    } else if (_selectedFilterIndex == 3) {
      return groups.where((g) => g.status.toLowerCase() == 'completed').toList();
    }
    return groups;
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String frequency = 'weekly';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: const Text('Create Ekub Group', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Group Name', hintText: 'e.g. Merkato Traders Circle'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Contribution Amount (Birr)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: frequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: const [
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                ],
                onChanged: (val) => frequency = val ?? 'weekly',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dlgContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && amountCtrl.text.isNotEmpty) {
                  final amount = double.tryParse(amountCtrl.text) ?? 1000.0;
                  context.read<GroupListBloc>().add(
                        CreateGroupSubmitted(
                          name: nameCtrl.text.trim(),
                          contributionAmount: amount,
                          frequency: frequency,
                          startDate: DateTime.now().toString().split(' ')[0],
                        ),
                      );
                  Navigator.of(dlgContext).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GroupListBloc>().add(FetchMyGroups());
      },
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Top Header Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const EkubLogo(size: 38),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'TENA YISTELEGN,',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'My Groups',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.04),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 22),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String initials = 'EK';
                          if (state is RegisterSuccess && state.user.name.isNotEmpty) {
                            final parts = state.user.name.trim().split(' ');
                            if (parts.length >= 2) {
                              initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                            } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
                              initials = parts[0][0].toUpperCase();
                            }
                          }
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFD1E2C4),
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Active Portfolio Card Banner (Real Data)
          SliverToBoxAdapter(
            child: BlocBuilder<GroupListBloc, GroupListState>(
              builder: (context, state) {
                double activeCommitment = 0.0;
                int activeCount = 0;

                if (state is GroupListLoaded) {
                  final activeGroups = state.groups.where((g) => g.status.toLowerCase() == 'active').toList();
                  activeCount = activeGroups.length;
                  activeCommitment = activeGroups.fold(0.0, (sum, g) => sum + g.contributionAmount);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Container(
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
                            Row(
                              children: const [
                                Icon(Icons.check_circle_outline, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'ACTIVE PORTFOLIO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '$activeCount Active',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Monthly Commitment',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${activeCommitment.toInt()} ',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(
                                text: 'Birr',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                activeCount > 0 ? Icons.alarm : Icons.info_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                activeCount > 0
                                    ? '$activeCount active circle${activeCount > 1 ? 's' : ''} in rotation'
                                    : 'No active draw scheduled',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_filters[index]),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedFilterIndex = index);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // Group Cards List from Backend / Real Data & Empty States
          BlocBuilder<GroupListBloc, GroupListState>(
            builder: (context, state) {
              if (state is GroupListLoading) {
                return const SliverFillRemaining(
                  child: LoadingIndicator(message: 'Loading your ekub circles...'),
                );
              } else if (state is GroupListError) {
                return SliverFillRemaining(
                  child: ErrorView(
                    message: state.message,
                    onRetry: () => context.read<GroupListBloc>().add(FetchMyGroups()),
                  ),
                );
              } else if (state is GroupListLoaded) {
                final groups = _filterGroups(state.groups);
                if (groups.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildGroupsEmptyState(_selectedFilterIndex),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final group = groups[index];
                        return GroupCard(
                          group: group,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/group-dashboard',
                              arguments: group.id,
                            );
                          },
                        );
                      },
                      childCount: groups.length,
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildGroupsEmptyState(int filterIndex) {
    IconData icon;
    String title;
    String subtitle;

    switch (filterIndex) {
      case 1:
        icon = Icons.play_circle_outline;
        title = 'No Active Circles';
        subtitle = 'None of your circles are currently active.';
        break;
      case 2:
        icon = Icons.hourglass_empty;
        title = 'No Pending Circles';
        subtitle = 'No circles waiting for members to join.';
        break;
      case 3:
        icon = Icons.task_alt;
        title = 'No Completed Circles';
        subtitle = 'No completed circle records found.';
        break;
      default:
        icon = Icons.groups_outlined;
        title = 'No Ekub Circles Yet';
        subtitle = 'You have not joined or created any Ekub circles. Tap "+ New group" below to start one!';
        break;
    }

    return _buildEmptyStateWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
    );
  }

  Widget _buildEmptyStateWidget({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsTab(BuildContext context) {
    return BlocBuilder<GroupListBloc, GroupListState>(
      builder: (context, state) {
        List<Group> activeGroups = [];
        if (state is GroupListLoaded) {
          activeGroups = state.groups.where((g) => g.status.toLowerCase() == 'active').toList();
        }

        final hasActive = activeGroups.isNotEmpty;
        final topGroup = hasActive ? activeGroups.first : null;
        final topPayoutPot = hasActive ? (topGroup!.contributionAmount * 10).toInt() : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 28),
                  SizedBox(width: 10),
                  Text('Payout Schedule', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Track your turns and upcoming rotating community payouts', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 20),

              // Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1B4931)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('NEXT ESTIMATED PAYOUT', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasActive ? AppColors.accent : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            hasActive ? '${_capitalize(topGroup!.frequency)} Rotation' : 'No Active Draws',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hasActive ? '$topPayoutPot ETB' : '0 ETB',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasActive
                          ? '${topGroup!.name} • Scheduled ${topGroup.startDate}'
                          : 'Join or create a group to view upcoming payout rotations.',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Upcoming Rotation Draws', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),

              if (!hasActive)
                _buildEmptyStateWidget(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'No Payout Schedules',
                  subtitle: 'Your rotation draw dates will automatically appear here once an Ekub circle is activated.',
                )
              else
                ...activeGroups.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final g = entry.value;
                  final pot = (g.contributionAmount * 10).toInt();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _buildPayoutTile(
                      g.name,
                      'Turn #${idx + 1} • ${_capitalize(g.frequency)} draw',
                      '$pot ETB',
                      g.startDate,
                      idx == 0 ? AppColors.accent : AppColors.primary,
                      idx == 0,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPayoutTile(String title, String subtitle, String amount, String date, Color color, bool isUserTurn) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUserTurn ? Border.all(color: AppColors.accent, width: 1.5) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return BlocBuilder<GroupListBloc, GroupListState>(
      builder: (context, state) {
        List<Group> groups = [];
        if (state is GroupListLoaded) {
          groups = state.groups;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.history, color: AppColors.primary, size: 28),
                  SizedBox(width: 10),
                  Text('Activity & Audit Log', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Verifiable ledger of contributions and automated payouts', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 20),

              if (groups.isEmpty)
                _buildEmptyStateWidget(
                  icon: Icons.history_toggle_off,
                  title: 'No Activity Logged Yet',
                  subtitle: 'A verifiable ledger of your contributions and automated draw results will appear here.',
                )
              else
                ...groups.map((g) {
                  final isActive = g.status.toLowerCase() == 'active';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildActivityItem(
                      isActive ? 'Circle Active' : 'Circle Initialized',
                      '${g.name} • ${g.frequency.toUpperCase()} cycle',
                      '${g.contributionAmount.toInt()} ETB',
                      g.startDate,
                      isActive ? Icons.check_circle : Icons.group_add,
                      isActive ? AppColors.success : AppColors.primary,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String amount, String date, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconColor.withValues(alpha: 0.12), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Ekub User';
        String userEmail = 'user@ekub.et';
        String initials = 'EU';

        if (state is RegisterSuccess) {
          userName = state.user.name;
          userEmail = state.user.email;
          final parts = userName.trim().split(' ');
          if (parts.length >= 2) {
            initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
          } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
            initials = parts[0][0].toUpperCase();
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFD1E2C4),
                child: Text(
                  initials,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified, color: AppColors.accent, size: 16),
                    SizedBox(width: 6),
                    Text('Verified Trustee • Tier 1', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                      title: const Text('Security & Biometrics', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                      title: const Text('Payout & Draw Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.account_balance_outlined, color: AppColors.primary),
                      title: const Text('Linked Account & Wallet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Telebirr / Bank Account', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                      title: const Text('Community Bylaws & Trust Terms', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.error, size: 20),
                  label: const Text('Sign out of Ekub', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _capitalize(String s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';
}
