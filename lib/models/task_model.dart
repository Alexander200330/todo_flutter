/// Clase que representa una tarea.
class Task {
  int? id;
  String? title;
  bool completed;

  /// Constructor de la clase `Task`.
  ///
  /// El parámetro [id] representa el identificador de la tarea.
  /// El parámetro [title] representa el título de la tarea.
  /// El parámetro [completed] indica si la tarea está completada o no.
  Task({this.id, this.title, this.completed = false});

  /// Convierte la tarea en un mapa de clave-valor para ser almacenada en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
    };
  }

  /// Crea una instancia de la clase `Task` a partir de un mapa de clave-valor.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] == 1 ? true : false,
    );
  }
}
