import 'package:flutter/material.dart';
import '../../../../injection_container.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../data/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = sl<AuthService>();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _successMessage = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = false;
    });

    try {
      await _authService.sendPasswordResetEmail(_emailController.text.trim());
      setState(() {
        _successMessage = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSection),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.spacingScreen),
              Text(
                'Forgot your password?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingTight),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingScreen),
              
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingDefault),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingDefault),
              ],

              if (_successMessage) ...[
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingDefault),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                  ),
                  child: Text(
                    'Password reset email sent! Check your inbox.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.success),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingDefault),
              ],

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingSection),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : const Text('Send Reset Link'),
              ),
              
              const SizedBox(height: AppTheme.spacingSection),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Back to Login',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
