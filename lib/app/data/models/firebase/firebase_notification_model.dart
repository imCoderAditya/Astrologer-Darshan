class NoticationFirebaseModel {
  final String? sound;
  final String? deeplink;
  final String? screen;
  final String? sessionId;
  final String? priority;
  final String? body;
  final String? type;
  final String? title;
  final String? clickAction;
  final String? customerId;
  final String? sessionType;
  final String? id;
  final String? event;
  final String? channelId;
  final DateTime? timestamp;

  NoticationFirebaseModel({
    this.sound,
    this.deeplink,
    this.screen,
    this.sessionId,
    this.priority,
    this.body,
    this.type,
    this.title,
    this.clickAction,
    this.customerId,
    this.sessionType,
    this.id,
    this.event,
    this.channelId,
    this.timestamp,
  });

  factory NoticationFirebaseModel.fromJson(Map<String, dynamic> json) {
    return NoticationFirebaseModel(
      sound: json["sound"]?.toString(),
      deeplink: json["deeplink"]?.toString(),
      screen: json["screen"]?.toString(),
      sessionId: json["sessionId"]?.toString(),
      priority: json["priority"]?.toString(),
      body: json["body"]?.toString(),
      type: json["type"]?.toString(),
      title: json["title"]?.toString(),
      clickAction: json["click_action"]?.toString(),
      customerId: json["customerId"]?.toString(),
      sessionType: json["sessionType"]?.toString(),
      id: json["id"]?.toString(),
      event: json["event"]?.toString(),
      channelId: json["channelId"]?.toString(),
      timestamp:
          json["timestamp"] == null
              ? null
              : DateTime.tryParse(json["timestamp"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "sound": sound,
    "deeplink": deeplink,
    "screen": screen,
    "sessionId": sessionId,
    "priority": priority,
    "body": body,
    "type": type,
    "title": title,
    "click_action": clickAction,
    "customerId": customerId,
    "sessionType": sessionType,
    "id": id,
    "event": event,
    "channelId": channelId,
    "timestamp": timestamp?.toIso8601String(),
  };
}
