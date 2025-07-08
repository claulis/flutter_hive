import 'package:hive/hive.dart';

part 'todo.g.dart';  // Arquivo gerado pelo build_runner

@HiveType(typeId: 0)  // typeId é um identificador único para o modelo
class Todo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});

  get key => null;
}
