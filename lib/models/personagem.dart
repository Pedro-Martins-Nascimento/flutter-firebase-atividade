class Personagem {
  String? id;
  String nome;
  int forca;
  int vida;

  Personagem({
    this.id,
    required this.nome,
    required this.forca,
    required this.vida,
  });

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'forca': forca, 'vida': vida};
  }

  factory Personagem.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Personagem(
      id: docId ?? map['id'],
      nome: map['nome'] ?? '',
      forca: map['forca'] ?? 10,
      vida: map['vida'] ?? 100,
    );
  }
}
