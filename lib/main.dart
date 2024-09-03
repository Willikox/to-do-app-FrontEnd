import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/chart_page.dart';
import 'package:todo_app_flutter/websocket_service.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late WebsocketService _websocketService;
  List<dynamic> _tasks = [];
  int completedCount = 0;
  int notCompletedCount = 0;
  int deletedCount = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _websocketService = WebsocketService('ws://localhost:5287/ws');
    _websocketService.stream.listen((message) {
      setState(() {
        _updateCounts();
      });
    });
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost:5287/api/todo'));
    if (response.statusCode == 200) {
      setState(() {
        _tasks = json.decode(response.body);
        _updateCounts();
      });
    }
  }

  Future<void> _addTask(String title, String description) async {
    final response = await http.post(
      Uri.parse('http://localhost:5287/api/todo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
      }),
    );
    if (response.statusCode == 201) {
      _fetchTasks();
    }
  }

  Future<void> _toogleTaskCompletion(int id, bool currentStatus) async {
    setState(() {
      _tasks = _tasks.map((task) {
        if (task['id'] == id) {
          task['isCompleted'] = !currentStatus;
        }
        return task;
      }).toList();
    });

    final response =
        await http.put(Uri.parse('http://localhost:5287/api/todo/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, bool>{
              'isCompleted': !currentStatus,
            }));

    if (response.statusCode == 204) {
      setState(() {
        _tasks = _tasks.map((task) {
          if (task['id'] == id) {
            task['isCompleted'] = !currentStatus;
          }
          return task;
        }).toList();
      });
    }
  }

  Future<void> _deleteTask(int id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:5287/api/todo/$id'));
    if (response.statusCode == 204) {
      setState(() {
        deletedCount++;
      });
      _fetchTasks();
    }
  }

  void _updateCounts() {
    completedCount = _tasks.where((task) => task['isCompleted']).length;
    notCompletedCount = _tasks.where((task) => !task['isCompleted']).length;
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Agregar Nueva Tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Título'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Descripción'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _addTask(
                        _titleController.text, _descriptionController.text);
                    _titleController.clear();
                    _descriptionController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Agregar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar')),
            ],
          );
        });
  }

  @override
  void dispose() {
    _websocketService.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartPage(
                    completedCount: completedCount,
                    notCompletedCount: notCompletedCount,
                    deletedCount: deletedCount,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Completadas: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '$completedCount',
                        style: const TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ',No completadas: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '$notCompletedCount',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                bool isCompleted = _tasks[index]['isCompleted'];
                DateTime createdDate =
                    DateTime.parse(_tasks[index]['createdDate']).toLocal();
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm').format(createdDate);

                return Card(
                  color: isCompleted
                      ? Colors.lightBlue[100]
                      : Colors.amber[
                          100], // Cambiar el color de fondo basado en el estado de la tarea
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          isCompleted ? Colors.lightBlue : Colors.orangeAccent,
                    ),
                    title: Text(
                      _tasks[index]['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${_tasks[index]['description']} - Fecha: $formattedDate',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTask(_tasks[index]['id']);
                      },
                    ),
                    onTap: () {
                      _toogleTaskCompletion(_tasks[index]['id'], isCompleted);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
