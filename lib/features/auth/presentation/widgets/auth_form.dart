import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final VoidCallback onToggleMode;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onToggleMode,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'solomon.tadesse@habesha.co');
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _biometricEnabled = true;
  bool _agreeTerms = true;
  String _role = 'member';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        context.read<AuthBloc>().add(
              LoginSubmitted(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            );
      } else {
        if (!_agreeTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please accept the Community Bylaws & Terms to proceed.'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
        context.read<AuthBloc>().add(
              RegisterSubmitted(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim().isEmpty
                    ? '0911000000'
                    : _phoneController.text.trim(),
                password: _passwordController.text,
                role: _role,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                if (!widget.isLogin) ...[
                  // Full name
                  _buildLabelHeader('Full name', 'Legal name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Solomon Tadesse',
                      prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textSecondary),
                    ),
                    validator: (v) => Validators.requiredField(v, fieldName: 'Full name'),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Address
                _buildLabelHeader(
                  'Email address',
                  widget.isLogin ? 'Personal' : 'Personal email',
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'solomon@example.com',
                    prefixIcon: Icon(Icons.mail_outline, size: 20, color: AppColors.textSecondary),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password / Passcode
                _buildLabelHeader(
                  widget.isLogin ? 'Security passcode' : 'Password',
                  widget.isLogin ? 'Encrypted' : 'Secure',
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: widget.isLogin ? '••••••••••••' : 'Create password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: Validators.password,
                ),

                if (widget.isLogin) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Biometric Tile
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: const [
                              Text(
                                'Biometric Unlock',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'FaceID or TouchID enabled',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _biometricEnabled,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _biometricEnabled = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  const SizedBox(height: 12),
                  // Must be at least 8 chars check
                  Row(
                    children: const [
                      Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Must be at least 8 characters with a number or symbol',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Agreement checkbox
                  Row(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeTerms,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            children: [
                              TextSpan(text: "By continuing, you agree to Ekub's "),
                              TextSpan(
                                text: 'Community Bylaws & Terms of Stewardship.',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isLogin ? 'Sign in to Ekub' : 'Create account',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelHeader(String label, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          badge,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
