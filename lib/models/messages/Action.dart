import 'package:hive/hive.dart';
part 'Action.g.dart';

@HiveType(typeId: 4)
class ActionsList {
  @HiveField(0)
  final List<Action> actions;

  ActionsList({
    required this.actions,
  });
  ActionsList.fromJson(List<dynamic> json)
      : actions = json
            .map((dynamic e) => Action.fromJson(e as Map<String, dynamic>))
            .toList();
}

@HiveType(typeId: 3)
class Action {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String value;
  Action({required this.type, required this.title, required this.value});

  factory Action.fromJson(Map<String, dynamic> json) {
    print(json);
    return Action(
        value: json['value'], type: json['type'], title: json['title']);
  }
}
