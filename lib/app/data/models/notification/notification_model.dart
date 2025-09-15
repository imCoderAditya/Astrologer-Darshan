// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  final bool? status;
  final String? message;
  final int? unreadCount;
  final int? totalCount;
  final List<NotificationData>? data;

  NotificationModel({
    this.status,
    this.message,
    this.data,
    this.unreadCount,
    this.totalCount,
  });

  NotificationModel copyWith({
    bool? status,
    String? message,
    int? unreadCount,
    int? totalCount,
    List<NotificationData>? data,
  }) => NotificationModel(
    status: status ?? this.status,
    message: message ?? this.message,
    unreadCount: unreadCount ?? this.unreadCount,
    totalCount: totalCount ?? this.totalCount,
    data: data ?? this.data,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        message: json["message"],
        unreadCount: json["unreadCount"],
        totalCount: json["totalCount"],
        data:
            json["data"] == null
                ? []
                : List<NotificationData>.from(
                  json["data"]!.map((x) => NotificationData.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationData {
  final int? notificationId;
  final int? userId;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? actionUrl;
  final DateTime? createdAt;

  NotificationData({
    this.notificationId,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.actionUrl,
    this.createdAt,
  });

  NotificationData copyWith({
    int? notificationId,
    int? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? actionUrl,
    DateTime? createdAt,
  }) => NotificationData(
    notificationId: notificationId ?? this.notificationId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    message: message ?? this.message,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
    actionUrl: actionUrl ?? this.actionUrl,
    createdAt: createdAt ?? this.createdAt,
  );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        notificationId: json["notificationId"],
        userId: json["userId"],
        title: json["title"],
        message: json["message"],
        type: json["type"],
        isRead: json["isRead"],
        actionUrl: json["actionUrl"],
        createdAt:
            json["createdAt"] == null
                ? null
                : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
    "notificationId": notificationId,
    "userId": userId,
    "title": title,
    "message": message,
    "type": type,
    "isRead": isRead,
    "actionUrl": actionUrl,
    "createdAt": createdAt?.toIso8601String(),
  };
}
