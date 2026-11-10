# Elo Pet

O Elo Pet é um aplicativo Flutter para aproximar pessoas interessadas em adotar de animais que precisam de um lar. Pelo app, é possível consultar e filtrar animais, ver detalhes, salvar favoritos, enviar solicitações de adoção e acompanhar o gerenciamento dessas solicitações. Também há opções para cadastrar e editar animais.

## Como executar

É necessário ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado, com uma versão do Dart a partir de `3.13.3` e anterior à `4.0.0`, conforme o `pubspec.yaml`. Para conferir se o ambiente está configurado, execute `flutter doctor`.

No terminal, na raiz deste repositório, execute:

```bash
cd elopet
flutter pub get
flutter run
```

O comando `flutter run` inicia o app em um dispositivo ou emulador disponível. Para listar os dispositivos reconhecidos pelo Flutter, execute `flutter devices`.

## Funcionalidades

- Lista, busca e filtros de animais disponíveis para adoção.
- Tela de detalhes, cadastro e edição de animais.
- Perfil local e lista de animais favoritos.
- Envio de solicitações de adoção e tela para aprovar ou recusar solicitações.
- Geração de recibo após a aprovação de uma adoção.

Os dados de animais e solicitações são lidos e alterados pela API configurada em `lib/services/animal_service.dart` (`https://elopet-api-1.onrender.com`).

## Tratamento de dados pessoais

O perfil, com nome e e-mail, os favoritos e os recibos são armazenados localmente no dispositivo com `SharedPreferences`. Após a aprovação de uma adoção, o app também grava um recibo `.txt` no diretório de documentos do aplicativo, exceto na versão Web. `SharedPreferences` não oferece criptografia própria.

Ao enviar uma solicitação, o formulário transmite à API o identificador e o nome do animal, nome, telefone e e-mail do adotante, mensagem opcional e data da solicitação. O envio usa HTTPS pela rota `POST /solicitacoes`. A tela de gerenciamento consulta solicitações pela rota `GET /solicitacoes`; o app não envia credenciais nessa consulta, então a proteção dos dados depende das regras configuradas no backend.
