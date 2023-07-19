class Task {
  int? id;
  String? title;
  bool completed;

  Task({this.id, this.title, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] == 1 ? true : false,
    );
  }
}
