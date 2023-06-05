class Task {
  final String name;
  bool isDone;
  final String? joke;

  Task({required this.name, this.isDone = false, this.joke});

  void toggleDone() {
    isDone = !isDone;
  }
}
