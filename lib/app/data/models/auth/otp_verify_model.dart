// To parse this JSON data, do
//
//     final otpVerifyModel = otpVerifyModelFromJson(jsonString);

import 'dart:convert';

OtpVerifyModel otpVerifyModelFromJson(String str) => OtpVerifyModel.fromJson(json.decode(str));

String otpVerifyModelToJson(OtpVerifyModel data) => json.encode(data.toJson());

class OtpVerifyModel {
    final bool? status;
    final String? message;
    final User? user;

    OtpVerifyModel({
        this.status,
        this.message,
        this.user,
    });

    OtpVerifyModel copyWith({
        bool? status,
        String? message,
        User? user,
    }) => 
        OtpVerifyModel(
            status: status ?? this.status,
            message: message ?? this.message,
            user: user ?? this.user,
        );

    factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
        status: json["status"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user?.toJson(),
    };
}

class User {
    final int? userId;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? userType;
    final String? phoneNumber;
    final DateTime? dateOfBirth;
    final String? gender;
    final String? profilePicture;
    final String? placeOfBirth;
    final String? timeOfBirth;
    final String? fcm;

    User({
        this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.userType,
        this.phoneNumber,
        this.dateOfBirth,
        this.gender,
        this.profilePicture,
        this.placeOfBirth,
        this.timeOfBirth,
        this.fcm,
    });

    User copyWith({
        int? userId,
        String? firstName,
        String? lastName,
        String? email,
        String? userType,
        String? phoneNumber,
        DateTime? dateOfBirth,
        String? gender,
        String? profilePicture,
        String? placeOfBirth,
        String? timeOfBirth,
        String? fcm,
    }) => 
        User(
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            userType: userType ?? this.userType,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            gender: gender ?? this.gender,
            profilePicture: profilePicture ?? this.profilePicture,
            placeOfBirth: placeOfBirth ?? this.placeOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
            fcm: fcm ?? this.fcm,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        userType: json["UserType"],
        phoneNumber: json["PhoneNumber"],
        dateOfBirth: json["DateOfBirth"] == null ? null : DateTime.parse(json["DateOfBirth"]),
        gender: json["Gender"],
        profilePicture: json["ProfilePicture"],
        placeOfBirth: json["PlaceOfBirth"],
        timeOfBirth: json["TimeOfBirth"],
        fcm: json["fcm"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "UserType": userType,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": dateOfBirth?.toIso8601String(),
        "Gender": gender,
        "ProfilePicture": profilePicture,
        "PlaceOfBirth": placeOfBirth,
        "TimeOfBirth": timeOfBirth,
        "fcm": fcm,
    };
}
