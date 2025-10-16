// To parse this JSON data, do
//
//     final giftModel = giftModelFromJson(jsonString);

import 'dart:convert';

GiftModel giftModelFromJson(String str) => GiftModel.fromJson(json.decode(str));

String giftModelToJson(GiftModel data) => json.encode(data.toJson());

class GiftModel {
    final bool? success;
    final int? totalCount;
    final double? totalEarned;
    final List<Datum>? data;

    GiftModel({
        this.success,
        this.totalCount,
        this.totalEarned,
        this.data,
    });

    GiftModel copyWith({
        bool? success,
        int? totalCount,
        double? totalEarned,
        List<Datum>? data,
    }) => 
        GiftModel(
            success: success ?? this.success,
            totalCount: totalCount ?? this.totalCount,
            totalEarned: totalEarned ?? this.totalEarned,
            data: data ?? this.data,
        );

    factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        success: json["success"],
        totalCount: json["totalCount"],
        totalEarned: json["totalEarned"]?.toDouble(),
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "totalCount": totalCount,
        "totalEarned": totalEarned,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? transactionId;
    final int? liveSessionId;
    final int? quantity;
    final double? totalAmount;
    final DateTime? createdAt;
    final Sender? sender;
    final Receiver? receiver;
    final Gift? gift;

    Datum({
        this.transactionId,
        this.liveSessionId,
        this.quantity,
        this.totalAmount,
        this.createdAt,
        this.sender,
        this.receiver,
        this.gift,
    });

    Datum copyWith({
        int? transactionId,
        int? liveSessionId,
        int? quantity,
        double? totalAmount,
        DateTime? createdAt,
        Sender? sender,
        Receiver? receiver,
        Gift? gift,
    }) => 
        Datum(
            transactionId: transactionId ?? this.transactionId,
            liveSessionId: liveSessionId ?? this.liveSessionId,
            quantity: quantity ?? this.quantity,
            totalAmount: totalAmount ?? this.totalAmount,
            createdAt: createdAt ?? this.createdAt,
            sender: sender ?? this.sender,
            receiver: receiver ?? this.receiver,
            gift: gift ?? this.gift,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        transactionId: json["TransactionID"],
        liveSessionId: json["LiveSessionID"],
        quantity: json["Quantity"],
        totalAmount: json["TotalAmount"]?.toDouble(),
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        sender: json["Sender"] == null ? null : Sender.fromJson(json["Sender"]),
        receiver: json["Receiver"] == null ? null : Receiver.fromJson(json["Receiver"]),
        gift: json["Gift"] == null ? null : Gift.fromJson(json["Gift"]),
    );

    Map<String, dynamic> toJson() => {
        "TransactionID": transactionId,
        "LiveSessionID": liveSessionId,
        "Quantity": quantity,
        "TotalAmount": totalAmount,
        "CreatedAt": createdAt?.toIso8601String(),
        "Sender": sender?.toJson(),
        "Receiver": receiver?.toJson(),
        "Gift": gift?.toJson(),
    };
}

class Gift {
    final String? giftName;
    final String? giftImage;
    final String? giftAnimation;

    Gift({
        this.giftName,
        this.giftImage,
        this.giftAnimation,
    });

    Gift copyWith({
        String? giftName,
        String? giftImage,
        String? giftAnimation,
    }) => 
        Gift(
            giftName: giftName ?? this.giftName,
            giftImage: giftImage ?? this.giftImage,
            giftAnimation: giftAnimation ?? this.giftAnimation,
        );

    factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        giftName: json["GiftName"],
        giftImage: json["GiftImage"],
        giftAnimation: json["GiftAnimation"],
    );

    Map<String, dynamic> toJson() => {
        "GiftName": giftName,
        "GiftImage": giftImage,
        "GiftAnimation": giftAnimation,
    };
}

class Receiver {
    final int? userId;
    final String? firstName;
    final String? profilePicture;

    Receiver({
        this.userId,
        this.firstName,
        this.profilePicture,
    });

    Receiver copyWith({
        int? userId,
        String? firstName,
        String? profilePicture,
    }) => 
        Receiver(
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            profilePicture: profilePicture ?? this.profilePicture,
        );

    factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        userId: json["UserID"],
        firstName: json["FirstName"],
        profilePicture: json["ProfilePicture"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "ProfilePicture": profilePicture,
    };
}

class Sender {
    final int? userId;
    final String? fullName;
    final String? profilePicture;

    Sender({
        this.userId,
        this.fullName,
        this.profilePicture,
    });

    Sender copyWith({
        int? userId,
        String? fullName,
        String? profilePicture,
    }) => 
        Sender(
            userId: userId ?? this.userId,
            fullName: fullName ?? this.fullName,
            profilePicture: profilePicture ?? this.profilePicture,
        );

    factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        userId: json["UserID"],
        fullName: json["FullName"],
        profilePicture: json["ProfilePicture"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FullName": fullName,
        "ProfilePicture": profilePicture,
    };
}
