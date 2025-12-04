import 'package:hive/hive.dart';
import 'package:todo_hive/models/todo.dart';  // Modelo que será armazenado

class TodoHelper {
  // Nome da "caixa" (box) no Hive — é como se fosse uma tabela ou arquivo de banco de dados
  static const String _boxName = 'todos';
  
  // Variável estática para guardar a caixa aberta (padrão Singleton simples)
  static Box<Todo>? _box;

  // Método privado que garante que a caixa esteja aberta e retorna ela
  // Usa lazy loading + reutilização da mesma instância
  static Future<Box<Todo>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!; // Já está aberta → reutiliza
    }

    try {
      // Abre (ou cria) a caixa chamada 'todos' que armazena objetos do tipo Todo
      _box = await Hive.openBox<Todo>(_boxName);
      return _box!;
    } catch (e) {
      throw Exception('Erro ao abrir a caixa de dados: $e');
    }
  }

  // Verifica se o Hive está funcionando e a caixa está acessível
  static Future<bool> isConnected() async {
    try {
      final box = await _getBox();
      return box.isOpen;
    } catch (e) {
      return false;
    }
  }

  // Adiciona uma nova tarefa no banco
  static Future<void> addTodo(Todo todo) async {
    try {
      final box = await _getBox();
      // Hive retorna uma chave (geralmente um int autoincrementado) ao adicionar
      await box.add(todo);
    } catch (e) {
      throw Exception('Erro ao adicionar tarefa: $e');
    }
  }

  // Retorna todas as tarefas salvas, em forma de List<Todo>
  static Future<List<Todo>> getTodos() async {
    try {
      final box = await _getBox();
      // box.values retorna todos os objetos armazenados
      return box.values.toList();
    } catch (e) {
      throw Exception('Erro ao obter tarefas: $e');
    }
  }

  // Remove uma tarefa pela chave (key) que o Hive atribuiu quando foi adicionada
  // A chave normalmente é um int (índice) quando usamos box.add()
  static Future<void> removeTodo(dynamic id) async {
    try {
      final box = await _getBox();
      await box.delete(id); // Deleta pelo identificador único
    } catch (e) {
      throw Exception('Erro ao remover tarefa: $e');
    }
  }
}