import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/models/todo.dart';  // Modelo de dados da tarefa
import 'pages/todo_page.dart';

void main() async {
  // Garante que os bindings do Flutter estejam inicializados antes de usar plugins assíncronos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive para o ambiente Flutter (cria/abre o diretório de armazenamento no dispositivo)
  await Hive.initFlutter();

  // Registra o adaptador gerado automaticamente para a classe Todo
  // Sem isso o Hive não sabe como serializar/deserializar objetos do tipo Todo
  Hive.registerAdapter(TodoAdapter());

  // Inicia o aplicativo Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa "DEBUG" no canto superior direito
      home: TodoPage(),                  // Define a página inicial do app
    );
  }
}