import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import '../../models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task?> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _addTask(String title) async {
    final newTask = Task(title: title);
    await DatabaseHelper.instance.insertTask(newTask);
    _loadTasks();
  }

  void _updateTask(Task task) async {
    task.completed = !task.completed;
    await DatabaseHelper.instance.updateTask(task);
    _loadTasks();
  }

  void _deleteTask(Task task) async {
    await DatabaseHelper.instance.deleteTask(task.id!);
    _loadTasks();
  }

  void _editTask(Task task) async {
    final editedTaskTitle = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String editedTitle = task.title!;
        return AlertDialog(
          title: Text('Editar tarea'),
          content: TextFormField(
            initialValue: task.title!,
            onChanged: (value) {
              editedTitle = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                task.title = editedTitle;
                await DatabaseHelper.instance.updateTask(task);
                Navigator.of(context).pop(editedTitle);
              },
            ),
          ],
        );
      },
    );

    if (editedTaskTitle != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea actualizada: $editedTaskTitle')),
      );
      _loadTasks();
    }
  }

  void _confirmDeleteTask(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              style: TextButton.styleFrom(primary: Colors.red),
              onPressed: () {
                _deleteTask(task);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aplicación lista de tareas',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return ListTile(
              title: Text(
                task!.title!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => _updateTask(task),
                checkColor: Colors.white,
                activeColor: Colors.blue,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 24,
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editTask(task),
                  ),
                  IconButton(
                    iconSize: 24,
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteTask(task),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 32),
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTaskTitle = '';
              return AlertDialog(
                title: Text('Agregar Tarea'),
                content: TextFormField(
                  onChanged: (value) {
                    newTaskTitle = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Agregar'),
                    onPressed: () {
                      _addTask(newTaskTitle);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
