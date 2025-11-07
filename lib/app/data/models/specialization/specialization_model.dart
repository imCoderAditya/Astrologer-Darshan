// To parse this JSON data, do
//
//     final specializationModel = specializationModelFromJson(jsonString);

import 'dart:convert';

SpecializationModel specializationModelFromJson(String str) => SpecializationModel.fromJson(json.decode(str));

String specializationModelToJson(SpecializationModel data) => json.encode(data.toJson());

class SpecializationModel {
    final bool? status;
    final String? message;
    final List<Specialization>? specialization;

    SpecializationModel({
        this.status,
        this.message,
        this.specialization,
    });

    SpecializationModel copyWith({
        bool? status,
        String? message,
        List<Specialization>? specialization,
    }) => 
        SpecializationModel(
            status: status ?? this.status,
            message: message ?? this.message,
            specialization: specialization ?? this.specialization,
        );

    factory SpecializationModel.fromJson(Map<String, dynamic> json) => SpecializationModel(
        status: json["status"],
        message: json["message"],
        specialization: json["data"] == null ? [] : List<Specialization>.from(json["data"]!.map((x) => Specialization.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": specialization == null ? [] : List<dynamic>.from(specialization!.map((x) => x.toJson())),
    };
}

class Specialization {
    final int? categoryId;
    final String? categoryName;
    final String? description;
    final DateTime? createdAt;

    Specialization({
        this.categoryId,
        this.categoryName,
        this.description,
        this.createdAt,
    });

    Specialization copyWith({
        int? categoryId,
        String? categoryName,
        String? description,
        DateTime? createdAt,
    }) => 
        Specialization(
            categoryId: categoryId ?? this.categoryId,
            categoryName: categoryName ?? this.categoryName,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        description: json["Description"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "Description": description,
        "CreatedAt": createdAt?.toIso8601String(),
    };
}
