import 'package:hive/hive.dart';

part 'todo.g.dart';  // Arquivo gerado pelo build_runner que contém o TypeAdapter

// Anotação obrigatória: define que essa classe será armazenada no Hive
@HiveType(typeId: 0)  // typeId deve ser único no projeto (0 a 223)
class Todo {
  // Campo título da tarefa
  @HiveField(0)
  final String title;

  // Campo que indica se a tarefa foi concluída
  @HiveField(1)
  bool isCompleted;

  // Construtor nomeado — título obrigatório, isCompleted padrão false
  Todo({required this.title, this.isCompleted = false});

  // Getter necessário apenas porque o Hive às vezes espera uma propriedade "key"
  // Aqui retornamos null porque não usamos chave explícita no modelo
  get key => null;
}