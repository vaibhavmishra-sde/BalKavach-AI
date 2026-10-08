import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      setState(() => _error = 'Please accept the terms to continue.');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _displayNameController.text.trim(),
        'parent',
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Container(width: 48, height: 48, decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28)),
                    const SizedBox(width: 14),
                    Text('Create your account', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 10),
                  Text('Set up a secure family workspace in less than a minute.', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 28),
                  Text('Your name', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _displayNameController, textCapitalization: TextCapitalization.words, autofillHints: const [AutofillHints.name], decoration: const InputDecoration(hintText: 'Alex Morgan', prefixIcon: Icon(Icons.person_outline_rounded)), validator: (value) => value == null || value.trim().length < 2 ? 'Enter your name' : null),
                  const SizedBox(height: 16),
                  Text('Email address', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, autofillHints: const [AutofillHints.email], decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Icons.mail_outline_rounded)), validator: (value) { final email = value?.trim() ?? ''; if (email.isEmpty) return 'Enter your email address'; if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) return 'Enter a valid email address'; return null; }),
                  const SizedBox(height: 16),
                  Text('Password', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _passwordController, autofillHints: const [AutofillHints.newPassword], decoration: InputDecoration(hintText: 'At least 8 characters', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => _obscurePassword = !_obscurePassword), icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined))), obscureText: _obscurePassword, validator: (value) { if (value == null || value.length < 8) return 'Use at least 8 characters'; if (!RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) return 'Include at least one letter and one number'; return null; }),
                  const SizedBox(height: 16),
                  TextFormField(controller: _confirmPasswordController, decoration: InputDecoration(hintText: 'Repeat your password', prefixIcon: const Icon(Icons.verified_user_outlined), suffixIcon: IconButton(onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword), icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined))), obscureText: _obscureConfirmPassword, validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null),
                  const SizedBox(height: 10),
                  CheckboxListTile(value: _acceptedTerms, onChanged: (value) => setState(() => _acceptedTerms = value ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('I agree to the privacy policy and family safety terms.'), dense: true),
                  const SizedBox(height: 10),
                  if (_error != null) Container(width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.red.withOpacity(.10), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.error_outline, color: Colors.redAccent), const SizedBox(width: 8), Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))])),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: _loading ? null : _submit, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create secure workspace', style: TextStyle(fontWeight: FontWeight.w700)))),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
