class TestModel {
  final String name;
  final int id;
  final bool isTest;

  TestModel({required this.name, required this.id, required this.isTest, t});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'isTest': isTest,
    };
  }

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      name: json['name'],
      id: json['id'],
      isTest: json['isTest'],
    );
  }
}
