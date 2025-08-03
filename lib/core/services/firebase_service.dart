import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../shared/models/user_model.dart' as app_models;
import '../../shared/models/producer_model.dart';
import '../../shared/models/investor_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _producersCollection = 'producers';
  static const String _investorsCollection = 'investors';
  static const String _projectsCollection = 'projects';
  static const String _investmentsCollection = 'investments';
  static const String _chatsCollection = 'chats';
  static const String _messagesCollection = 'messages';

  // Authentication
  static Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  static Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // User Management
  static Future<void> createUser(app_models.User user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur: $e');
    }
  }

  static Future<app_models.User?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return app_models.User.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  static Future<void> updateUser(app_models.User user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: $e');
    }
  }

  // Producer Management
  static Future<void> createProducer(Producer producer) async {
    try {
      await _firestore
          .collection(_producersCollection)
          .doc(producer.id)
          .set(producer.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la création du producteur: $e');
    }
  }

  static Future<Producer?> getProducer(String producerId) async {
    try {
      final doc = await _firestore
          .collection(_producersCollection)
          .doc(producerId)
          .get();
      
      if (doc.exists) {
        return Producer.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du producteur: $e');
    }
  }

  static Stream<List<Producer>> getProducers({
    int? limit,
    String? region,
    bool? isVerified,
  }) {
    Query query = _firestore.collection(_producersCollection);

    if (region != null) {
      query = query.where('location.region', isEqualTo: region);
    }

    if (isVerified != null) {
      query = query.where('isVerified', isEqualTo: isVerified);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Producer.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Investor Management
  static Future<void> createInvestor(Investor investor) async {
    try {
      await _firestore
          .collection(_investorsCollection)
          .doc(investor.id)
          .set(investor.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'investisseur: $e');
    }
  }

  static Future<Investor?> getInvestor(String investorId) async {
    try {
      final doc = await _firestore
          .collection(_investorsCollection)
          .doc(investorId)
          .get();
      
      if (doc.exists) {
        return Investor.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'investisseur: $e');
    }
  }

  // Project Management
  static Future<String> createProject(Map<String, dynamic> projectData) async {
    try {
      final docRef = await _firestore
          .collection(_projectsCollection)
          .add(projectData);
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du projet: $e');
    }
  }

  static Stream<List<Map<String, dynamic>>> getProjects({
    int? limit,
    String? status,
    String? producerId,
  }) {
    Query query = _firestore.collection(_projectsCollection);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    if (producerId != null) {
      query = query.where('producerId', isEqualTo: producerId);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  // Investment Management
  static Future<String> createInvestment(Map<String, dynamic> investmentData) async {
    try {
      final docRef = await _firestore
          .collection(_investmentsCollection)
          .add(investmentData);
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'investissement: $e');
    }
  }

  static Stream<List<Map<String, dynamic>>> getInvestments({
    String? investorId,
    String? projectId,
  }) {
    Query query = _firestore.collection(_investmentsCollection);

    if (investorId != null) {
      query = query.where('investorId', isEqualTo: investorId);
    }

    if (projectId != null) {
      query = query.where('projectId', isEqualTo: projectId);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  // File Upload
  static Future<String> uploadFile({
    required String filePath,
    required String fileName,
    required String folder,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(File(filePath));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Erreur lors du téléchargement du fichier: $e');
    }
  }

  // Chat Management
  static Future<String> createChat({
    required String participantId1,
    required String participantId2,
  }) async {
    try {
      final chatData = {
        'participants': [participantId1, participantId2],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection(_chatsCollection)
          .add(chatData);
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du chat: $e');
    }
  }

  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    try {
      final messageData = {
        'senderId': senderId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      await _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .collection(_messagesCollection)
          .add(messageData);

      // Mettre à jour le dernier message du chat
      await _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du message: $e');
    }
  }

  static Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    });
  }

  // Error Handling
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email.';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Une erreur s\'est produite: ${e.message}';
    }
  }
}

// Import manquant pour File
import 'dart:io';