import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedUserType = AppConstants.producerType;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulation de l'authentification
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigation selon le type d'utilisateur
      if (_selectedUserType == AppConstants.producerType) {
        context.go(AppConstants.producerDashboardRoute);
      } else {
        context.go(AppConstants.investorDashboardRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo et titre
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          size: 40,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .scale(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 24),

                      Text(
                        'Bienvenue sur\n${AppConstants.appName}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 600),
                          ),

                      const SizedBox(height: 8),

                      Text(
                        'Connectez-vous pour continuer',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 600),
                          ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Sélection du type d'utilisateur
                Text(
                  'Je suis un(e)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 600),
                    ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildUserTypeCard(
                        type: AppConstants.producerType,
                        title: 'Producteur',
                        subtitle: 'Je cultive des noix de cajou',
                        icon: Icons.agriculture,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUserTypeCard(
                        type: AppConstants.investorType,
                        title: 'Investisseur',
                        subtitle: 'Je finance des projets',
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 800),
                      duration: const Duration(milliseconds: 600),
                    ),

                const SizedBox(height: 32),

                // Champs de saisie
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 600),
                    )
                    .slideX(
                      begin: -0.2,
                      end: 0,
                    ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 1200),
                      duration: const Duration(milliseconds: 600),
                    )
                    .slideX(
                      begin: -0.2,
                      end: 0,
                    ),

                const SizedBox(height: 24),

                // Mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter la récupération de mot de passe
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 1400),
                      duration: const Duration(milliseconds: 600),
                    ),

                const SizedBox(height: 32),

                // Bouton de connexion
                CustomButton(
                  text: 'Se connecter',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 1600),
                      duration: const Duration(milliseconds: 600),
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                    ),

                const SizedBox(height: 32),

                // Lien d'inscription
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pas encore de compte ? ',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppConstants.registerRoute);
                        },
                        child: const Text(
                          'S\'inscrire',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 1800),
                      duration: const Duration(milliseconds: 600),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedUserType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOrange.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppTheme.primaryOrange : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primaryOrange : AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}