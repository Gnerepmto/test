# 🥜 CashewConnect

**Connecter • Financer • Prospérer**

CashewConnect est une application mobile Flutter innovante qui connecte les producteurs de noix de cajou du Bénin avec des investisseurs pour financer leurs projets agricoles de manière sécurisée et transparente.

## 📱 Aperçu de l'Application

### Fonctionnalités Principales

#### 🌾 Pour les Producteurs
- **Profil Détaillé** : Création de profils complets avec informations sur la ferme, localisation, et expérience
- **Gestion de Projets** : Création et suivi de projets de financement avec objectifs clairs
- **Tableau de Bord** : Statistiques en temps réel sur les financements et les performances
- **Communication** : Chat intégré avec les investisseurs
- **Vérification** : Système de vérification pour renforcer la confiance

#### 💰 Pour les Investisseurs
- **Catalogue Interactif** : Navigation dans les projets disponibles avec filtres avancés
- **Profils d'Investissement** : Définition de préférences et critères d'investissement
- **Portefeuille** : Suivi des investissements et des rendements
- **Évaluations** : Système de notation et commentaires
- **Notifications** : Alertes sur les opportunités correspondant aux critères

#### 🔒 Sécurité et Paiements
- **Paiements Mobile Money** : Intégration MTN MoMo et Moov Money
- **Chiffrement** : Protection des données sensibles
- **Authentification** : Système d'authentification robuste avec Firebase
- **Règles de Sécurité** : Règles Firestore strictes pour la protection des données

## 🏗️ Architecture

### Structure du Projet

```
lib/
├── core/                          # Configuration et utilitaires centraux
│   ├── constants/                 # Constantes de l'application
│   ├── theme/                     # Thème et styles
│   ├── utils/                     # Utilitaires (sécurité, validation)
│   └── services/                  # Services centraux (navigation, Firebase)
├── features/                      # Fonctionnalités par domaine
│   ├── auth/                      # Authentification
│   ├── producer/                  # Fonctionnalités producteurs
│   ├── investor/                  # Fonctionnalités investisseurs
│   ├── payment/                   # Système de paiement
│   └── chat/                      # Messagerie
└── shared/                        # Composants partagés
    ├── models/                    # Modèles de données
    ├── widgets/                   # Widgets réutilisables
    └── providers/                 # Providers d'état
```

### Technologies Utilisées

- **Framework** : Flutter 3.10+
- **Base de Données** : Firebase Firestore
- **Authentification** : Firebase Auth
- **Stockage** : Firebase Storage
- **État** : Riverpod
- **Navigation** : GoRouter
- **Animations** : Flutter Animate
- **Graphiques** : FL Chart
- **Paiements** : Flutter Paystack (MTN MoMo, Moov Money)
- **Cartes** : Google Maps
- **Sécurité** : Crypto, règles Firestore

## 🎨 Design

### Thème Visuel
- **Couleur Principale** : Orange (#FF8C42) - représentant la noix de cajou
- **Couleurs Secondaires** : Vert feuillage, Marron terre, Crème
- **Typographie** : Poppins
- **Style** : Material Design 3 avec touches personnalisées

### UX/UI
- **Responsive** : Adaptation Android et iOS
- **Animations** : Transitions fluides et micro-interactions
- **Accessibilité** : Respect des standards d'accessibilité
- **Thème Sombre** : Support du mode sombre

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK 3.10.0 ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / VS Code
- Compte Firebase
- Clés API (Google Maps, paiements)

### Installation

1. **Cloner le projet**
```bash
git clone https://github.com/votre-username/cashew-connect.git
cd cashew-connect
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration Firebase**
```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter à Firebase
firebase login

# Configurer le projet
flutterfire configure
```

4. **Configuration des variables d'environnement**
```bash
# Créer le fichier .env
cp .env.example .env

# Ajouter vos clés API
GOOGLE_MAPS_API_KEY=votre_cle_google_maps
MTN_MOMO_API_KEY=votre_cle_mtn
MOOV_MONEY_API_KEY=votre_cle_moov
```

5. **Générer les fichiers**
```bash
flutter packages pub run build_runner build
```

6. **Lancer l'application**
```bash
flutter run
```

## 🔐 Configuration de Sécurité

### Firebase Security Rules
Les règles de sécurité Firestore sont configurées dans `firestore.rules` avec :
- Authentification obligatoire
- Vérification des propriétaires
- Validation des données
- Protection contre les injections

### Chiffrement
- Hachage des mots de passe avec salt
- Chiffrement des données sensibles
- Signatures API pour l'intégrité
- Validation des entrées utilisateur

## 💳 Intégration Paiements

### MTN Mobile Money
- API MTN MoMo Collection
- Validation des numéros (96xxxxxx)
- Gestion des callbacks
- Gestion des erreurs

### Moov Money
- API Moov Money
- Validation des numéros (97xxxxxx)
- Processus de paiement sécurisé
- Suivi des transactions

## 📊 Base de Données

### Collections Firestore

#### Users
```javascript
{
  id: string,
  email: string,
  firstName: string,
  lastName: string,
  phoneNumber: string,
  userType: 'producer' | 'investor',
  profileImageUrl?: string,
  isVerified: boolean,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

#### Producers
```javascript
{
  id: string,
  user: User,
  farmName: string,
  description: string,
  location: Location,
  farmSizeHectares: number,
  cashewTreesCount: number,
  expectedYieldKg: number,
  pricePerKg: number,
  certifications: string[],
  farmImages: string[],
  fundingGoal: number,
  currentFunding: number,
  projectDescription: string,
  projectDeadline: timestamp,
  rating: number,
  isVerified: boolean
}
```

#### Investors
```javascript
{
  id: string,
  user: User,
  investorType: 'individual' | 'company' | 'institution',
  availableFunds: number,
  investmentPreferences: string[],
  preferredRegions: string[],
  minInvestmentAmount: number,
  maxInvestmentAmount: number,
  riskTolerance: number,
  activeInvestments: string[],
  rating: number,
  isVerified: boolean
}
```

## 🧪 Tests

### Tests Unitaires
```bash
flutter test
```

### Tests d'Intégration
```bash
flutter test integration_test/
```

### Tests de Performance
```bash
flutter test --coverage
```

## 📱 Déploiement

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS
flutter build ios --release
```

### Firebase Hosting (Web)
```bash
# Build Web
flutter build web

# Deploy
firebase deploy --only hosting
```

## 🔧 Maintenance

### Monitoring
- Firebase Analytics
- Crashlytics pour le suivi des erreurs
- Performance Monitoring
- Logs structurés

### Mises à Jour
- Versioning sémantique
- Tests automatisés
- Déploiement progressif
- Rollback automatique

## 🤝 Contribution

### Guide de Contribution
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Standards de Code
- Respect des conventions Dart/Flutter
- Documentation des fonctions publiques
- Tests pour les nouvelles fonctionnalités
- Vérification avec `flutter analyze`

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🌍 Impact Social

CashewConnect contribue au développement économique du Bénin en :
- **Facilitant l'accès au financement** pour les petits producteurs
- **Créant des liens directs** entre producteurs et investisseurs
- **Promouvant l'agriculture durable** et les pratiques biologiques
- **Renforçant la transparence** dans les chaînes d'approvisionnement
- **Soutenant l'économie numérique** béninoise

## 📞 Support

- **Email** : support@cashewconnect.bj
- **Téléphone** : +229 XX XX XX XX
- **Documentation** : [docs.cashewconnect.bj](https://docs.cashewconnect.bj)
- **Issues** : [GitHub Issues](https://github.com/votre-username/cashew-connect/issues)

## 🙏 Remerciements

- Communauté Flutter Bénin
- Producteurs de noix de cajou partenaires
- Investisseurs early adopters
- Équipe de développement

---

**Développé avec ❤️ au Bénin pour connecter l'agriculture à l'innovation**