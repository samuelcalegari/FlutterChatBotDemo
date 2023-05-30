class BotList {
  final List<Bots>? bots;

  BotList({
    this.bots,
  });

  BotList.fromJson(Map<String, dynamic> json)
      : bots = (json['bots'] as List?)
            ?.map((dynamic e) => Bots.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'bots': bots?.map((e) => e.toJson()).toList()};
}

class Bots {
  final String? name;
  final String? avatar;
  final String? moodleUrl;
  final String? moodleUser;
  final String? moodlePasswort;
  final String? directlineSecret;

  String? conversationId;
  String? streamUrl;

  Bots({
    this.name,
    this.avatar,
    this.moodleUrl,
    this.moodleUser,
    this.moodlePasswort,
    this.directlineSecret,
  });

  Bots.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        avatar = json['avatar'] as String?,
        moodleUrl = json['moodleUrl'] as String?,
        moodleUser = json['moodleUser'] as String?,
        moodlePasswort = json['moodlePasswort'] as String?,
        directlineSecret = json['directlineSecret'] as String?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
        'moodleUrl': moodleUrl,
        'moodleUser': moodleUser,
        'moodlePasswort': moodlePasswort,
        'directlineSecret': directlineSecret
      };
}
