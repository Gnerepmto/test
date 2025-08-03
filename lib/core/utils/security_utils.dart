import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class SecurityUtils {
  // Clés de chiffrement (à stocker de manière sécurisée en production)
  static const String _encryptionKey = 'CashewConnect2024SecureKey123456789';
  static const String _saltKey = 'CashewConnectSalt2024';

  /// Génère un hash sécurisé pour les mots de passe
  static String hashPassword(String password, {String? salt}) {
    salt ??= _generateSalt();
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return '$salt:${digest.toString()}';
  }

  /// Vérifie un mot de passe contre son hash
  static bool verifyPassword(String password, String hashedPassword) {
    try {
      final parts = hashedPassword.split(':');
      if (parts.length != 2) return false;
      
      final salt = parts[0];
      final expectedHash = parts[1];
      
      final bytes = utf8.encode(password + salt);
      final digest = sha256.convert(bytes);
      
      return digest.toString() == expectedHash;
    } catch (e) {
      debugPrint('Erreur lors de la vérification du mot de passe: $e');
      return false;
    }
  }

  /// Génère un sel aléatoire pour le hachage
  static String _generateSalt([int length = 16]) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Génère un token sécurisé
  static String generateSecureToken([int length = 32]) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Chiffre une chaîne de caractères
  static String encryptString(String plainText) {
    try {
      final key = utf8.encode(_encryptionKey);
      final bytes = utf8.encode(plainText);
      
      // Simple XOR encryption (pour l'exemple - utiliser AES en production)
      final encrypted = <int>[];
      for (int i = 0; i < bytes.length; i++) {
        encrypted.add(bytes[i] ^ key[i % key.length]);
      }
      
      return base64.encode(encrypted);
    } catch (e) {
      debugPrint('Erreur lors du chiffrement: $e');
      return plainText;
    }
  }

  /// Déchiffre une chaîne de caractères
  static String decryptString(String encryptedText) {
    try {
      final key = utf8.encode(_encryptionKey);
      final encrypted = base64.decode(encryptedText);
      
      // Simple XOR decryption
      final decrypted = <int>[];
      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ key[i % key.length]);
      }
      
      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint('Erreur lors du déchiffrement: $e');
      return encryptedText;
    }
  }

  /// Valide la force d'un mot de passe
  static PasswordStrength validatePasswordStrength(String password) {
    if (password.length < 6) {
      return PasswordStrength.weak;
    }

    int score = 0;
    
    // Longueur
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Contient des minuscules
    if (password.contains(RegExp(r'[a-z]'))) score++;
    
    // Contient des majuscules
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    
    // Contient des chiffres
    if (password.contains(RegExp(r'[0-9]'))) score++;
    
    // Contient des caractères spéciaux
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score < 3) return PasswordStrength.weak;
    if (score < 5) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  /// Valide un numéro de téléphone béninois
  static bool validateBeninPhoneNumber(String phoneNumber) {
    // Format: 8 chiffres commençant par 96, 97, 94, 95, 90, 91, 92, 93
    final regex = RegExp(r'^(96|97|94|95|90|91|92|93)\d{6}$');
    return regex.hasMatch(phoneNumber);
  }

  /// Valide un email
  static bool validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Sanitise une chaîne pour éviter les injections
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Supprime les balises HTML
        .replaceAll(RegExp(r'[<>&"\']'), '') // Supprime les caractères dangereux
        .trim();
  }

  /// Génère un hash pour l'intégrité des données
  static String generateDataHash(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString + _saltKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Vérifie l'intégrité des données
  static bool verifyDataIntegrity(Map<String, dynamic> data, String expectedHash) {
    final actualHash = generateDataHash(data);
    return actualHash == expectedHash;
  }

  /// Masque les informations sensibles pour les logs
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) return '*' * data.length;
    
    final visible = data.substring(0, visibleChars);
    final masked = '*' * (data.length - visibleChars);
    return visible + masked;
  }

  /// Génère un code OTP à 6 chiffres
  static String generateOTP() {
    final random = Random.secure();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Valide les montants de transaction
  static bool validateTransactionAmount(double amount) {
    // Montant minimum: 1000 FCFA, maximum: 50,000,000 FCFA
    return amount >= 1000 && amount <= 50000000;
  }

  /// Détecte les tentatives de fraude basiques
  static bool detectSuspiciousActivity({
    required int loginAttempts,
    required Duration timeSinceLastAttempt,
    required String ipAddress,
  }) {
    // Trop de tentatives de connexion
    if (loginAttempts > 5 && timeSinceLastAttempt.inMinutes < 15) {
      return true;
    }

    // Adresse IP suspecte (exemple basique)
    if (ipAddress.startsWith('192.168.') || ipAddress == '127.0.0.1') {
      return false; // Adresses locales OK pour le développement
    }

    return false;
  }

  /// Génère une signature pour les requêtes API
  static String generateApiSignature({
    required String method,
    required String endpoint,
    required Map<String, dynamic> params,
    required String timestamp,
  }) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    final queryString = sortedParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    final signatureString = '$method|$endpoint|$queryString|$timestamp';
    final bytes = utf8.encode(signatureString + _encryptionKey);
    final digest = sha256.convert(bytes);
    
    return digest.toString();
  }
}

enum PasswordStrength { weak, medium, strong }

/// Extension pour obtenir la description de la force du mot de passe
extension PasswordStrengthExtension on PasswordStrength {
  String get description {
    switch (this) {
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.medium:
        return 'Moyen';
      case PasswordStrength.strong:
        return 'Fort';
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.weak:
        return const Color(0xFFE74C3C);
      case PasswordStrength.medium:
        return const Color(0xFFF39C12);
      case PasswordStrength.strong:
        return const Color(0xFF27AE60);
    }
  }
}

// Import nécessaire pour Color
import 'package:flutter/material.dart';