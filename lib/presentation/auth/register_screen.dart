import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:iroko/presentation/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'client'; // 'client' ou 'provider'

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
      );

      if (mounted) {
        if (success) {
          // Navigate to home screen
          navigator.pushReplacementNamed('/home');
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Erreur lors de l\'inscription'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.spacingLarge),
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              // Logo
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: const Center(
                    child: Text(
                      'IROKO',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              // Title
              Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                'Rejoignez la plateforme IROKO',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Jean Dupont',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        if (value.length < 3) {
                          return 'Le nom doit contenir au moins 3 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adresse email',
                        hintText: 'exemple@email.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Minimum 6 caractères',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        hintText: 'Confirmez votre mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(
                              () =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    // Role Selection
                    Text(
                      'Choisir un rôle',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedRole = 'client');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppTheme.spacingMedium),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedRole == 'client'
                                      ? AppTheme.primaryColor
                                      : AppTheme.greyLight,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                color: _selectedRole == 'client'
                                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                                    : AppTheme.white,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: _selectedRole == 'client'
                                        ? AppTheme.primaryColor
                                        : AppTheme.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Client',
                                    style: TextStyle(
                                      color: _selectedRole == 'client'
                                          ? AppTheme.primaryColor
                                          : AppTheme.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedRole = 'provider');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppTheme.spacingMedium),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedRole == 'provider'
                                      ? AppTheme.primaryColor
                                      : AppTheme.greyLight,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                color: _selectedRole == 'provider'
                                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                                    : AppTheme.white,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.work_outline,
                                    color: _selectedRole == 'provider'
                                        ? AppTheme.primaryColor
                                        : AppTheme.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Prestataire',
                                    style: TextStyle(
                                      color: _selectedRole == 'provider'
                                          ? AppTheme.primaryColor
                                          : AppTheme.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    // Submit Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () => _handleRegister(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingMedium,
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('S\'inscrire'),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Vous avez un compte? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
