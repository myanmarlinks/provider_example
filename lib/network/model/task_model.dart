import 'package:json_annotation/json_annotation.dart';


part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  String id;
  String name;
  @JsonKey(nullable: true)
  String avatar;
  String createdAt;

  TaskModel({this.id, this.name, this.avatar, this.createdAt});

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}