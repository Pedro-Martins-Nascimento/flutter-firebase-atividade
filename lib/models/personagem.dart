class Personagem {
  String? id;
  String? nome;
  int? vida;
  int? forca;
  String userId; // Aqui é a conexão do usuário logado com seus personagens


  Personagem({this.id, required this.nome, required this.vida, required this.forca, this.userId = ''}); // this.userId é preenchido pelo Service no create

  Map<String, dynamic> toMap(){
    return{
      'nome': nome,
      'vida': vida,
      'forca': forca,
      'userId': userId, // adiciona aqui também o userId
    };
  }

  factory Personagem.fromMap(Map<String, dynamic> map, {String? id}){
    return Personagem(
      id: id,
      nome: map['nome'] ?? '',
      vida: (map['vida'] ?? 0) as int,
      forca: (map['forca'] ?? 0) as int,
      userId: map['userId'] ?? '', // e aqui também
    );

  }
}