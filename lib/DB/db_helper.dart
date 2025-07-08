import 'package:hive/hive.dart';
import 'package:todo_hive/models/todo.dart';  // Modelo Todo

class TodoHelper {
  static const String _boxName = 'todos';  // Nome da caixa de dados do Hive
  static Box<Todo>? _box;

  // Conexão com a caixa de dados usando Singleton
  static Future<Box<Todo>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }

    try {
      _box = await Hive.openBox<Todo>(_boxName);
      return _box!;
    } catch (e) {
      throw Exception('Erro ao abrir a caixa de dados: $e');
    }
  }

  // Verifica se o Hive está conectado
  static Future<bool> isConnected() async {
    try {
      final box = await _getBox();
      return box.isOpen;
    } catch (e) {
      return false;
    }
  }

  // Adiciona uma nova tarefa
  static Future<void> addTodo(Todo todo) async {
    try {
      final box = await _getBox();
      await box.add(todo);
    } catch (e) {
      throw Exception('Erro ao adicionar tarefa: $e');
    }
  }

  // Retorna todas as tarefas
  static Future<List<Todo>> getTodos() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Erro ao obter tarefas: $e');
    }
  }

  // Remove uma tarefa
  static Future<void> removeTodo(dynamic id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
    } catch (e) {
      throw Exception('Erro ao remover tarefa: $e');
    }
  }
}
