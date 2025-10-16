// To parse this JSON data, do
//
//     final followersModel = followersModelFromJson(jsonString);

import 'dart:convert';

FollowersModel followersModelFromJson(String str) => FollowersModel.fromJson(json.decode(str));

String followersModelToJson(FollowersModel data) => json.encode(data.toJson());

class FollowersModel {
    final bool? success;
    final int? totalCount;
    final List<Followrs>? data;

    FollowersModel({
        this.success,
        this.totalCount,
        this.data,
    });

    FollowersModel copyWith({
        bool? success,
        int? totalCount,
        List<Followrs>? data,
    }) => 
        FollowersModel(
            success: success ?? this.success,
            totalCount: totalCount ?? this.totalCount,
            data: data ?? this.data,
        );

    factory FollowersModel.fromJson(Map<String, dynamic> json) => FollowersModel(
        success: json["success"],
        totalCount: json["totalCount"],
        data: json["data"] == null ? [] : List<Followrs>.from(json["data"]!.map((x) => Followrs.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "totalCount": totalCount,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Followrs {
    final int? customerId;
    final FollowrsUser? user;

    Followrs({
        this.customerId,
        this.user,
    });

    Followrs copyWith({
        int? customerId,
        FollowrsUser? user,
    }) => 
        Followrs(
            customerId: customerId ?? this.customerId,
            user: user ?? this.user,
        );

    factory Followrs.fromJson(Map<String, dynamic> json) => Followrs(
        customerId: json["CustomerID"],
        user: json["User"] == null ? null : FollowrsUser.fromJson(json["User"]),
    );

    Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "User": user?.toJson(),
    };
}

class FollowrsUser {
    final int? userId;
    final String? email;
    final String? passwordHash;
    final String? firstName;
    final String? lastName;
    final String? phoneNumber;
    final String? dateOfBirth;
    final String? timeOfBirth;
    final String? placeOfBirth;
    final String? gender;
    final String? profilePicture;
    final String? userType;

    FollowrsUser({
        this.userId,
        this.email,
        this.passwordHash,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.dateOfBirth,
        this.timeOfBirth,
        this.placeOfBirth,
        this.gender,
        this.profilePicture,
        this.userType,
    });

    FollowrsUser copyWith({
        int? userId,
        String? email,
        String? passwordHash,
        String? firstName,
        String? lastName,
        String? phoneNumber,
        String? dateOfBirth,
        String? timeOfBirth,
        String? placeOfBirth,
        String? gender,
        String? profilePicture,
        String? userType,
    }) => 
        FollowrsUser(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            passwordHash: passwordHash ?? this.passwordHash,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
            placeOfBirth: placeOfBirth ?? this.placeOfBirth,
            gender: gender ?? this.gender,
            profilePicture: profilePicture ?? this.profilePicture,
            userType: userType ?? this.userType,
        );

    factory FollowrsUser.fromJson(Map<String, dynamic> json) => FollowrsUser(
        userId: json["UserID"],
        email: json["Email"],
        passwordHash: json["PasswordHash"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        phoneNumber: json["PhoneNumber"],
        dateOfBirth: json["DateOfBirth"],
        timeOfBirth: json["TimeOfBirth"],
        placeOfBirth: json["PlaceOfBirth"],
        gender: json["Gender"],
        profilePicture: json["ProfilePicture"],
        userType: json["UserType"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Email": email,
        "PasswordHash": passwordHash,
        "FirstName": firstName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": dateOfBirth,
        "TimeOfBirth": timeOfBirth,
        "PlaceOfBirth": placeOfBirth,
        "Gender": gender,
        "ProfilePicture": profilePicture,
        "UserType": userType,
    };
}
