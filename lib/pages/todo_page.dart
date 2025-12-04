import 'package:flutter/material.dart';
import 'package:todo_hive/DB/db_helper.dart';  // Helper com operações no Hive
import 'package:todo_hive/models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];               // Lista que será exibida na tela
  String _errorMessage = '';             // Mensagem de erro para o usuário
  bool _isConnected = false;             // Indica se o Hive está acessível

  @override
  void initState() {
    super.initState();
    _checkConnection(); // Verifica logo ao abrir a página se o banco está ok
  }

  // Testa se conseguimos abrir a caixa do Hive
  void _checkConnection() async {
    _isConnected = await TodoHelper.isConnected();
    if (_isConnected) {
      _loadTodos(); // Se estiver tudo certo, carrega as tarefas
    } else {
      setState(() {
        _errorMessage = 'Erro: Não foi possível conectar ao banco de dados.';
      });
    }
  }

  // Busca todas as tarefas salvas e atualiza o estado da tela
  void _loadTodos() async {
    try {
      final todos = await TodoHelper.getTodos();
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar tarefas: $e';
      });
    }
  }

  // Adiciona uma nova tarefa quando o usuário pressiona o botão "+"
  Future<void> _addTodo() async {
    if (_controller.text.isNotEmpty) {
      final newTodo = Todo(
        title: _controller.text,
        isCompleted: false,
      );

      try {
        await TodoHelper.addTodo(newTodo);
        _controller.clear(); // Limpa o campo de texto
        _loadTodos();        // Recarrega a lista para mostrar a nova tarefa
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao adicionar tarefa: $e';
        });
      }
    }
  }

  // Remove uma tarefa — atenção: aqui usamos o índice da lista como chave
  // Isso funciona porque Hive.add() retorna chaves sequenciais (0, 1, 2...)
  Future<void> _removeTodo(dynamic id) async {
    try {
      await TodoHelper.removeTodo(id);
      _loadTodos(); // Recarrega a lista após exclusão
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao remover tarefa: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive: Tarefas'),
      ),
      body: Column(
        children: [
          // Exibe mensagem de erro caso algo dê errado com o Hive
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // Campo de texto + botão de adicionar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Adicionar tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),

          // Lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                // Cada item da lista — usamos o índice como chave para deletar
                return ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTodo(index), // Importante: índice = chave do Hive nesse caso
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}