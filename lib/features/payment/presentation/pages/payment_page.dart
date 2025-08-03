import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

class PaymentPage extends StatefulWidget {
  final String projectId;
  final double amount;

  const PaymentPage({
    super.key,
    required this.projectId,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedProvider = 'mtn';
  bool _isProcessing = false;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _paymentProviders = [
    {
      'id': 'mtn',
      'name': 'MTN Mobile Money',
      'logo': 'assets/images/mtn_logo.png',
      'color': AppTheme.warningYellow,
      'prefix': '96',
    },
    {
      'id': 'moov',
      'name': 'Moov Money',
      'logo': 'assets/images/moov_logo.png',
      'color': AppTheme.infoBlue,
      'prefix': '97',
    },
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
      _currentStep = 1;
    });

    // Simulation du processus de paiement
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _currentStep = 2;
      });

      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _currentStep = 3;
          _isProcessing = false;
        });

        // Afficher le dialogue de succès
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: AppTheme.successGreen,
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 24),
            const Text(
              'Paiement Réussi !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre investissement de ${widget.amount.toStringAsFixed(0)} FCFA a été traité avec succès.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Continuer',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Paiement'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations du projet
                _buildProjectInfo(),
                const SizedBox(height: 32),

                // Sélection du fournisseur de paiement
                if (_currentStep == 0) ...[
                  _buildPaymentProviderSelection(),
                  const SizedBox(height: 24),
                  _buildPaymentForm(),
                  const SizedBox(height: 32),
                  _buildPaymentButton(),
                ],

                // Processus de paiement
                if (_currentStep > 0) _buildPaymentProgress(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 30,
                  color: AppTheme.primaryOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plantation Cajou Bio 2024',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Producteur: Kofi Mensah',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Montant à investir:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              Text(
                '${widget.amount.toStringAsFixed(0)} FCFA',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildPaymentProviderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choisir un moyen de paiement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_paymentProviders.length, (index) {
          final provider = _paymentProviders[index];
          final isSelected = _selectedProvider == provider['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedProvider = provider['id'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? provider['color'].withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? provider['color']
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: provider['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.phone_android,
                      color: provider['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      provider['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? provider['color']
                            : AppTheme.darkGrey,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: provider['color'],
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
        );
  }

  Widget _buildPaymentForm() {
    final selectedProvider = _paymentProviders
        .firstWhere((p) => p['id'] == _selectedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations de paiement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          label: 'Numéro de téléphone',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
          hint: '${selectedProvider['prefix']}XXXXXX',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez saisir votre numéro';
            }
            if (value.length != 8) {
              return 'Le numéro doit contenir 8 chiffres';
            }
            if (!value.startsWith(selectedProvider['prefix'])) {
              return 'Le numéro doit commencer par ${selectedProvider['prefix']}';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _amountController,
          label: 'Montant (FCFA)',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.attach_money,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez saisir le montant';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Montant invalide';
            }
            if (amount < 10000) {
              return 'Montant minimum: 10,000 FCFA';
            }
            return null;
          },
        ),
      ],
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
        );
  }

  Widget _buildPaymentButton() {
    return CustomButton(
      text: 'Procéder au paiement',
      icon: Icons.payment,
      onPressed: _processPayment,
      isLoading: _isProcessing,
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
        )
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildPaymentProgress() {
    final steps = [
      'Initialisation du paiement',
      'Envoi de la requête',
      'Confirmation du paiement',
      'Paiement terminé',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Traitement du paiement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGrey,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(steps.length, (index) {
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : isCurrent
                              ? AppTheme.primaryOrange
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check
                          : isCurrent
                              ? Icons.hourglass_empty
                              : Icons.circle,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        color: isCompleted || isCurrent
                            ? AppTheme.darkGrey
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (isCurrent && _isProcessing)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryOrange,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.3, end: 0);
  }
}