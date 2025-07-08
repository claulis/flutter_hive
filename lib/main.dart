import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/models/todo.dart';  // Importando o modelo Todo
import 'pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Hive e registra o adaptador
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());  // Registra o adaptador do modelo Todo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}
