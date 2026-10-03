import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/ekub_logo.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Welcome back!'), backgroundColor: AppColors.success),
            );
            Navigator.of(context).pushReplacementNamed('/groups');
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully! Signing in...'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/groups');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),

                // Top Ekub Logo
                const Center(child: EkubLogo(size: 72)),

                const SizedBox(height: 16),

                // App Title
                const Text(
                  'Ekub',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                // Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isLogin ? 'Welcome back' : 'Create your account • Trusted Savings Circles',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Description text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _isLogin
                        ? 'Sign in to your rotating savings circle\nand track your collective stewardship'
                        : 'Sign up to save collectively and take turns\nreceiving rotating community payouts.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Auth Form Box
                AuthForm(
                  isLogin: _isLogin,
                  onToggleMode: () => setState(() => _isLogin = !_isLogin),
                ),

                const SizedBox(height: 20),

                // Security Shield Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        _isLogin
                            ? '256-bit encryption  •  Insured community vault'
                            : '256-bit bank encryption  •  Insured community vault',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Social Proof Card / Circle Preview Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isLogin ? _buildLoginPreviewCard() : _buildRegisterSocialProofCard(),
                ),

                const SizedBox(height: 20),

                // Toggle Mode Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? "Don't have an ekub account?" : "Already have an account?",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => _isLogin = !_isLogin),
                      child: Row(
                        children: [
                          Text(
                            _isLogin ? 'Register circle' : 'Log in',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Footer Text
                const Text(
                  'Support & Rules   •   Bylaws & Trust',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPreviewCard() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          height: 32,
          child: Stack(
            children: [
              _buildAvatar('MT', const Color(0xFFE07A5F), 0),
              _buildAvatar('AS', const Color(0xFF81B29A), 18),
              _buildAvatar('HW', const Color(0xFFF2CC8F), 36),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: const [
              Text(
                'Merkato Traders Circle',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              Text(
                'Round 7 Draw in 2 days',
                style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const Icon(Icons.people_outline, color: AppColors.textSecondary, size: 20),
      ],
    );
  }

  Widget _buildRegisterSocialProofCard() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFFDE8E0),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.people, color: AppColors.accent, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAlignment: CrossAlignment.start,
            children: const [
              Text(
                'Join 14,000+ verified members',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              Text(
                'Active circles in Addis Ababa, Bole, Merkato...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String label, Color color, double leftOffset) {
    return Positioned(
      left: leftOffset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
