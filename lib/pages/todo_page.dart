import 'package:flutter/material.dart';
import 'package:todo_hive/DB/db_helper.dart';
import 'package:todo_hive/models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];
  String _errorMessage = '';  // Mensagem de erro, se houver
  bool _isConnected = false;  // Status de conexão com o banco

  @override
  void initState() {
    super.initState();
    _checkConnection();  // Verifica a conexão ao banco assim que a página é carregada
  }

  // Verifica a conexão com o banco
  void _checkConnection() async {
    _isConnected = await TodoHelper.isConnected();
    if (_isConnected) {
      _loadTodos();  // Carrega as tarefas se estiver conectado
    } else {
      setState(() {
        _errorMessage = 'Erro: Não foi possível conectar ao banco de dados.';
      });
    }
  }

  // Carrega todas as tarefas
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

  // Adiciona uma nova tarefa
  Future<void> _addTodo() async {
    if (_controller.text.isNotEmpty) {
      final newTodo = Todo(
        title: _controller.text,
        isCompleted: false,
      );

      try {
        await TodoHelper.addTodo(newTodo);
        _controller.clear();  // Limpa o campo de texto
        _loadTodos();  // Recarrega a lista de tarefas
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao adicionar tarefa: $e';
        });
      }
    }
  }

  // Remove uma tarefa
  Future<void> _removeTodo(dynamic id) async {
    try {
      await TodoHelper.removeTodo(id);
      _controller.clear();
      _loadTodos();  // Recarrega a lista de tarefas após remover
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
          // Exibe mensagem de erro, se houver
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          // Campo de texto para adicionar tarefas
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
                return ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTodo(index),
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
