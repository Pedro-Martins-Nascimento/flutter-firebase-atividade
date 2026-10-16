import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/personagem.dart';

class PersonagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não autenticado.");
    return user.uid;
  }

  // --- SUBCOLEÇÃO DE PERSONAGENS (usuarios/{uid}/personagens) ---

  // Retorna o QuerySnapshot esperado pelo StreamBuilder da HomeScreen
  Stream<QuerySnapshot<Map<String, dynamic>>> listarPersonagens() {
    return _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('personagens')
        .snapshots();
  }

  // Adiciona um novo personagem na subcoleção do usuário
  Future<void> criarHeroi(Personagem personagem) async {
    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('personagens')
        .add(personagem.toMap());
  }

  // Aplica dano ao personagem pelo ID
  Future<void> tomarDano(String id, int vidaAtual) async {
    final novaVida = (vidaAtual - 10).clamp(0, 999);
    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('personagens')
        .doc(id)
        .update({'vida': novaVida});
  }

  // Deleta um personagem
  Future<void> deletarPersonagem(String id) async {
    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('personagens')
        .doc(id)
        .delete();
  }

  // --- PARTE 3: SUBCOLEÇÃO DE MISSÕES (usuarios/{uid}/missoes) ---

  Future<void> concluirMissao(String tituloMissao) async {
    await _firestore.collection('usuarios').doc(_uid).collection('missoes').add(
      {'titulo': tituloMissao, 'concluidaEm': FieldValue.serverTimestamp()},
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarMissoes() {
    return _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('missoes')
        .orderBy('concluidaEm', descending: true)
        .snapshots();
  }
}
