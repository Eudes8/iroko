import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:iroko/presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (success) {
          router.go('/home');
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Erreur de connexion'),
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
              const SizedBox(height: AppTheme.spacingXLarge),
              // Logo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: const Center(
                    child: Text(
                      'IROKO',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXLarge),
              // Title
              Text(
                'Connexion',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                'Accédez à votre compte IROKO',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Entrez un email valide';
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
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password
                        },
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _handleLogin(context),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppTheme.white),
                            ),
                          )
                        : const Text('Se connecter'),
                  );
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: AppTheme.grey300)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
                    child: Text('ou', style: TextStyle(color: AppTheme.grey600)),
                  ),
                  Expanded(child: Divider(color: AppTheme.grey300)),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              // Google Login Button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Google Sign In
                },
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Continuer avec Google'),
              ),
              const SizedBox(height: AppTheme.spacingXLarge),
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Vous n\'avez pas de compte ?'),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text(
                      'S\'inscrire',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
