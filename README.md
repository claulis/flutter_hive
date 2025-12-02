# Todo Hive - Aplicativo de Tarefas com Flutter e Hive

[![Flutter](https://img.shields.io/badge/Flutter-3.6.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Hive](https://img.shields.io/badge/Hive-2.2.3-FFA500?style=for-the-badge&logo=hive&logoColor=white)](https://docs.hivedb.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

Um aplicativo de lista de tarefas desenvolvido em Flutter utilizando Hive como banco de dados local para persistência de dados.

## 📋 Sobre o Projeto

Este projeto demonstra a implementação de um sistema CRUD (Create, Read, Update, Delete) simples usando o Hive, um banco de dados NoSQL leve e rápido para Flutter e Dart. O aplicativo permite adicionar, visualizar e remover tarefas de forma persistente.

## 🚀 Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento mobile multiplataforma
- **Hive**: Banco de dados NoSQL local, rápido e leve
- **Hive Flutter**: Extensão do Hive para integração com Flutter
- **Build Runner**: Ferramenta para geração de código

## 🔧 Instalação

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd todo_hive
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Gere os arquivos necessários do Hive

O Hive utiliza geração de código para criar adaptadores. Execute o comando:

```bash
flutter pub run build_runner build
```

Ou, se preferir modo de observação (watch mode) para regenerar automaticamente:

```bash
flutter pub run build_runner watch
```

### 4. Execute o aplicativo

```bash
flutter run
```

## 📁 Estrutura do Projeto

```
lib/
├── DB/
│   └── db_helper.dart          # Helper para operações com banco de dados
├── models/
│   ├── todo.dart               # Modelo de dados Todo
│   └── todo.g.dart            # Arquivo gerado automaticamente pelo build_runner
├── pages/
│   └── todo_page.dart         # Página principal do aplicativo
└── main.dart                  # Ponto de entrada do aplicativo
```

## 📚 Documentação das Classes

### 1. `main.dart`

**Descrição**: Ponto de entrada da aplicação. Inicializa o Hive e registra os adaptadores necessários.

**Funções principais**:
- `main()`: Função assíncrona que inicializa o Flutter, o Hive e registra o adaptador do modelo Todo
- `MyApp`: Widget raiz da aplicação que configura o MaterialApp

**Código importante**:
```dart
await Hive.initFlutter();              // Inicializa o Hive para Flutter
Hive.registerAdapter(TodoAdapter());   // Registra o adaptador do modelo Todo
```

### 2. `models/todo.dart`

**Descrição**: Define o modelo de dados para as tarefas (Todo).

**Anotações Hive**:
- `@HiveType(typeId: 0)`: Identifica o tipo no Hive com ID único
- `@HiveField(n)`: Identifica cada campo do modelo para serialização

**Propriedades**:
- `title` (String): Título da tarefa
- `isCompleted` (bool): Status de conclusão da tarefa
- `key`: Getter que retorna null (usado internamente pelo Hive)

**Construtor**:
```dart
Todo({required this.title, this.isCompleted = false})
```

### 3. `models/todo.g.dart`

**Descrição**: Arquivo gerado automaticamente pelo `build_runner`. Contém o adaptador que serializa e desserializa objetos Todo.

**Classe principal**:
- `TodoAdapter`: Implementa `TypeAdapter<Todo>` para converter objetos Todo em bytes e vice-versa

**Métodos**:
- `read()`: Lê dados binários e reconstrói o objeto Todo
- `write()`: Escreve o objeto Todo como dados binários

⚠️ **Importante**: Nunca edite este arquivo manualmente, ele é regenerado automaticamente.

### 4. `DB/db_helper.dart`

**Descrição**: Classe helper que encapsula todas as operações de banco de dados usando padrão Singleton.

**Propriedades estáticas**:
- `_boxName`: Nome da caixa (box) do Hive onde os dados são armazenados
- `_box`: Instância singleton da caixa de dados

**Métodos principais**:

#### `_getBox()`
- **Tipo**: Privado, assíncrono
- **Retorno**: `Future<Box<Todo>>`
- **Descrição**: Obtém ou abre a caixa de dados do Hive usando padrão Singleton

#### `isConnected()`
- **Tipo**: Público, assíncrono
- **Retorno**: `Future<bool>`
- **Descrição**: Verifica se a conexão com o banco de dados está ativa

#### `addTodo(Todo todo)`
- **Tipo**: Público, assíncrono
- **Parâmetro**: Objeto Todo a ser adicionado
- **Descrição**: Adiciona uma nova tarefa ao banco de dados

#### `getTodos()`
- **Tipo**: Público, assíncrono
- **Retorno**: `Future<List<Todo>>`
- **Descrição**: Retorna todas as tarefas armazenadas

#### `removeTodo(dynamic id)`
- **Tipo**: Público, assíncrono
- **Parâmetro**: ID da tarefa a ser removida (índice na caixa)
- **Descrição**: Remove uma tarefa específica do banco de dados

**Tratamento de erros**: Todos os métodos possuem try-catch e lançam exceções descritivas em caso de falha.

### 5. `pages/todo_page.dart`

**Descrição**: Interface principal do aplicativo onde o usuário interage com as tarefas.

**Estado da página** (`_TodoPageState`):

**Propriedades**:
- `_controller`: Controlador para o campo de texto de entrada
- `_todos`: Lista de tarefas carregadas do banco
- `_errorMessage`: Mensagem de erro para exibir ao usuário
- `_isConnected`: Status da conexão com o banco de dados

**Métodos do ciclo de vida**:

#### `initState()`
- Executado ao criar o widget
- Chama `_checkConnection()` para verificar a conexão com o banco

**Métodos principais**:

#### `_checkConnection()`
- **Tipo**: Assíncrono, void
- **Descrição**: Verifica se o banco está acessível e carrega as tarefas

#### `_loadTodos()`
- **Tipo**: Assíncrono, void
- **Descrição**: Carrega todas as tarefas do banco e atualiza a interface

#### `_addTodo()`
- **Tipo**: Assíncrono, Future<void>
- **Descrição**: Adiciona uma nova tarefa se o campo de texto não estiver vazio

#### `_removeTodo(dynamic id)`
- **Tipo**: Assíncrono, Future<void>
- **Parâmetro**: ID/índice da tarefa
- **Descrição**: Remove uma tarefa específica

**Interface**:
- AppBar com título "Hive: Tarefas"
- Campo de texto para adicionar novas tarefas
- ListView com todas as tarefas e botão de exclusão
- Área de exibição de mensagens de erro

## 🔑 Conceitos Importantes do Hive

### Box (Caixa)
Uma "box" é como uma tabela no Hive. Cada box pode armazenar múltiplos objetos do mesmo tipo. No projeto, usamos uma box chamada `'todos'`.

### TypeAdapter
Adaptador que ensina ao Hive como converter seus objetos personalizados em bytes (serialização) e vice-versa (desserialização).

### Persistência Local
O Hive armazena dados localmente no dispositivo, permitindo acesso offline e rápida recuperação de informações.

## 🛠️ Comandos Úteis

```bash
# Instalar dependências
flutter pub get

# Gerar arquivos do Hive
flutter pub run build_runner build

# Limpar e regenerar arquivos
flutter pub run build_runner build --delete-conflicting-outputs

# Executar em modo watch (regenera automaticamente)
flutter pub run build_runner watch

# Limpar projeto
flutter clean

# Executar aplicativo
flutter run
```

## 📝 Dependências do Projeto

```yaml
dependencies:
  hive: ^2.2.3              # Banco de dados NoSQL
  hive_flutter: ^1.1.0      # Integração Hive com Flutter
  hive_generator: ^2.0.1    # Gerador de código para adaptadores
  build_runner: ^2.5.4      # Ferramenta de geração de código
```

## 🐛 Solução de Problemas

### Erro: "type 'Null' is not a subtype of type 'String'"
**Solução**: Execute `flutter pub run build_runner build --delete-conflicting-outputs`

### Erro ao abrir a box
**Solução**: Verifique se `Hive.initFlutter()` foi chamado no `main()` antes de usar qualquer funcionalidade do Hive

### Mudanças no modelo não refletem
**Solução**: Regenere os arquivos com `flutter pub run build_runner build --delete-conflicting-outputs`

## 📄 Licença

Este projeto é um exemplo educacional e está disponível para uso livre.


