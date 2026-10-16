import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/personagem.dart';
import '../services/auth_service.dart';
import '../services/personagem_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PersonagemService();
  final _auth = AuthService();

  final _nomeController = TextEditingController();
  final _forcaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _forcaController.dispose();
    super.dispose();
  }

  void _dialogCriarHeroi() {
    _nomeController.clear();
    _forcaController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('NOVO HERÓI'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Herói'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _forcaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Força'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = _nomeController.text.trim();
                final forca = int.tryParse(_forcaController.text.trim()) ?? 10;

                if (nome.isNotEmpty) {
                  await _service.criarHeroi(
                    Personagem(nome: nome, forca: forca, vida: 100),
                  );
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('CRIAR'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const ouro = Color(0xFFD4A94A);
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Aventureiro';

    return Scaffold(
      appBar: AppBar(
        title: const Text("THE DEV'S QUEST"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _auth.sair(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Logado como: $userEmail',
              style: const TextStyle(color: ouro),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _service.listarPersonagens(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum herói cadastrado na sua jornada.'),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final p = Personagem.fromMap(data, doc.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ouro,
                          child: Text(
                            '${p.forca}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(p.nome),
                        subtitle: Text('Vida: ${p.vida} HP'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.flash_on,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _service.tomarDano(p.id!, p.vida),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                                  _service.deletarPersonagem(p.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _dialogCriarHeroi,
        backgroundColor: ouro,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
