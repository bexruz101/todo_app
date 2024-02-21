import 'dart:convert';

class TaskModel {
  String? id;
  String? title;
  String? desc;
  String? image;
  TaskModel({
    this.id,
    this.title,
    this.desc,
    this.image,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? desc,
    String? image,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'image': image,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      desc: map['desc'] != null ? map['desc'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, desc: $desc, image: $image)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.desc == desc &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ desc.hashCode ^ image.hashCode;
  }
}
