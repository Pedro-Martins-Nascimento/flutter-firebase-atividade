import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/personagem.dart';

class PersonagemService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // UID do usuário logado
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _colecao => firestore.collection('personagens');

  Future<void> criarHeroi (Personagem p) async{
    final dados = p.toMap();
    dados['userId'] = _uid; // marca invisível do usuário que está criando personagem
    await _colecao.add(dados);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarPersonagens(){
    //return _colecao.snapshots(); //agora que há login, aqui muda para:
    // a "peneira". Só irão aparecer os personagens do usuário logado
    return _colecao.where('userId', isEqualTo: _uid).snapshots();
  }

  Future<void> tomarDano(String id, int novaVida) async{
    await _colecao.doc(id).update({'vida': novaVida});
  }

  Future<void> deletarPersonagem(String id) async{
    await _colecao.doc(id).delete();
  }


}