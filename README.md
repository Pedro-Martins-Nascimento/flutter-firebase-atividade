# The Dev's Quest

App Flutter com **Firebase Auth** e **Cloud Firestore**. Atividade de reorganização do banco com subcoleções.

## 🗂️ Estrutura do banco

```
usuarios (coleção)
 └── {uid} (documento: o id é o UID do Auth)
      ├── personagens (subcoleção)
      │    └── {id} → nome, vida, forca
      └── missoes (subcoleção)
           └── {id} → titulo, concluidaEm
```

Os dados pertencem ao usuário pelo **caminho**, e não por um campo `userId`.

## 🔒 Security Rules

O arquivo [`firestore.rules`](firestore.rules) libera leitura e escrita apenas para o dono dos dados:

```
match /usuarios/{userId}/{document=**} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

- Cada usuário acessa somente `usuarios/{o próprio uid}`.
- Vale para qualquer subcoleção, atual ou futura.
- Usuário sem login não acessa nada.

## ✨ Funcionalidades

- Login e cadastro com e-mail e senha
- CRUD de personagens (criar, listar, dano, excluir)
- Missões concluídas: registrar e listar (aba "Missões")

## ▶️ Como rodar

Os arquivos de configuração do Firebase **não** estão no repositório. Cada pessoa precisa gerar os seus:

1. Instale as dependências:
```bash
   flutter pub get
```
2. Instale as ferramentas do Firebase e faça login:
```bash
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
```
3. Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
4. Conecte o app ao seu projeto (gera `lib/firebase_options.dart`, `firebase.json` e `android/app/google-services.json`):
```bash
   flutterfire configure
```
5. No console, ative **Authentication → E-mail/senha** e crie o **Firestore Database**.
6. Publique as regras do arquivo `firestore.rules` em *Firestore → Regras*.
7. Rode o app:
```bash
   flutter run
```

> ⚠️ `firebase_options.dart`, `firebase.json` e `google-services.json` estão no `.gitignore` e não devem ser enviados ao GitHub.