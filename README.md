📱 Institutional Assessment Platform — App Aluno (Flutter)

Aplicativo mobile desenvolvido em Flutter voltado para a realização de avaliações institucionais de forma segura, com suporte nativo a offline-first e mecanismos de prevenção a fraudes.  

🚀 Sobre o Projeto

O aplicativo é o módulo do aluno da plataforma de avaliação. Ele permite que o estudante baixe a prova, responda às questões mesmo sem conexão com a internet e sincronize suas respostas de forma assíncrona assim que a conectividade for reestabelecida.  

🌟 Principais Recursos
Arquitetura Offline-First: Persistência local de dados para garantir a realização de provas em ambientes sem conectividade.  
Sincronização Assíncrona: Envio automático do pacote de respostas assim que o dispositivo detecta conexão ativa.  
Mecanismo de Sandbox & Segurança: Recursos para controle de estado e restrições de navegação durante a execução do teste para prevenção de fraudes.  
Interface Responsiva: Telas fielmente traduzidas a partir do design do Figma.

🛠️ Tecnologias e Pacientes
Linguagem: Dart
Framework: Flutter
Gerenciamento de Estado: flutter_bloc
Persistência Local: sqflite + flutter_secure_storage
Comunicação HTTP: dio + connectivity_plus
Injeção de Dependências: get_it📂 Estrutura de Pastas

A arquitetura do projeto segue o padrão Feature-First combinado com conceitos de Clean Architecture:

lib/
├── app/                  # Configurações globais, rotas e temas
├── core/                 # Módulos compartilhados (banco local, rede, segurança, UI kit)
│   ├── constants/
│   ├── database/         # Configuração do SQLite local
│   ├── network/          # Cliente Dio e interceptores
│   ├── security/         # Regras do modo sandbox/bloqueio
│   └── widgets/          # Componentes visuais globais
├── features/             # Módulos independentes por funcionalidade
│   ├── auth/             # Autenticação do aluno
│   ├── prova/            # Download, execução e salvamento local da prova
│   └── sincronizacao/    # Worker/serviço de sincronização background
└── main.dart             # Ponto de entrada da aplicação

⚙️ Como Executar o Projeto
Pré-requisitosFlutter SDK (versão 3.x ou superior)
Android Studio / VS Code com extensões do Flutter
Emulador Android/iOS ou dispositivo físico conectado

Passo a Passo
Clone este repositório:
Bash
git clone https://github.com/seu-usuario/seu-repo-flutter.git
Acesse a pasta do projeto:
Bash
cd seu-repo-flutter
Instale as dependências:
Bash
flutter pub get
Execute o aplicativo:
Bash
flutter run
🔗 Repositórios Relacionados⚙️ 
Backend: API Spring Boot (Java)🌐 
Dashboard Web: Painel do Professor (React / Next.js)
