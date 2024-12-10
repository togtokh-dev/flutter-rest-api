class ExampleModel {
  final int id;
  final String name;

  ExampleModel({required this.id, required this.name});

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
