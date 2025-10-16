// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) => ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
    final bool? success;
    final int? total;
    final List<Datum>? data;
    final RatingSummary? ratingSummary;

    ReviewModel({
        this.success,
        this.total,
        this.data,
        this.ratingSummary,
    });

    ReviewModel copyWith({
        bool? success,
        int? total,
        List<Datum>? data,
        RatingSummary? ratingSummary,
    }) => 
        ReviewModel(
            success: success ?? this.success,
            total: total ?? this.total,
            data: data ?? this.data,
            ratingSummary: ratingSummary ?? this.ratingSummary,
        );

    factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        success: json["success"],
        total: json["total"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        ratingSummary: json["ratingSummary"] == null ? null : RatingSummary.fromJson(json["ratingSummary"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "ratingSummary": ratingSummary?.toJson(),
    };
}

class Datum {
    final int? reviewId;
    final int? sessionId;
    final int? customerId;
    final String? customerName;
    final String? customerProfilePic;
    final int? astrologerId;
    final String? astrologerName;
    final String? astrologerProfilePic;
    final int? rating;
    final String? reviewText;
    final DateTime? createdAt;

    Datum({
        this.reviewId,
        this.sessionId,
        this.customerId,
        this.customerName,
        this.customerProfilePic,
        this.astrologerId,
        this.astrologerName,
        this.astrologerProfilePic,
        this.rating,
        this.reviewText,
        this.createdAt,
    });

    Datum copyWith({
        int? reviewId,
        int? sessionId,
        int? customerId,
        String? customerName,
        String? customerProfilePic,
        int? astrologerId,
        String? astrologerName,
        String? astrologerProfilePic,
        int? rating,
        String? reviewText,
        DateTime? createdAt,
    }) => 
        Datum(
            reviewId: reviewId ?? this.reviewId,
            sessionId: sessionId ?? this.sessionId,
            customerId: customerId ?? this.customerId,
            customerName: customerName ?? this.customerName,
            customerProfilePic: customerProfilePic ?? this.customerProfilePic,
            astrologerId: astrologerId ?? this.astrologerId,
            astrologerName: astrologerName ?? this.astrologerName,
            astrologerProfilePic: astrologerProfilePic ?? this.astrologerProfilePic,
            rating: rating ?? this.rating,
            reviewText: reviewText ?? this.reviewText,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reviewId: json["ReviewID"],
        sessionId: json["SessionID"],
        customerId: json["CustomerID"],
        customerName: json["CustomerName"],
        customerProfilePic: json["CustomerProfilePic"],
        astrologerId: json["AstrologerID"],
        astrologerName: json["AstrologerName"],
        astrologerProfilePic: json["AstrologerProfilePic"],
        rating: json["Rating"],
        reviewText: json["ReviewText"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "ReviewID": reviewId,
        "SessionID": sessionId,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "CustomerProfilePic": customerProfilePic,
        "AstrologerID": astrologerId,
        "AstrologerName": astrologerName,
        "AstrologerProfilePic": astrologerProfilePic,
        "Rating": rating,
        "ReviewText": reviewText,
        "CreatedAt": createdAt?.toIso8601String(),
    };
}

class RatingSummary {
    final int? star5;
    final int? star4;
    final int? star3;
    final int? star2;
    final int? star1;
    final double? average;

    RatingSummary({
        this.star5,
        this.star4,
        this.star3,
        this.star2,
        this.star1,
        this.average,
    });

    RatingSummary copyWith({
        int? star5,
        int? star4,
        int? star3,
        int? star2,
        int? star1,
        double? average,
    }) => 
        RatingSummary(
            star5: star5 ?? this.star5,
            star4: star4 ?? this.star4,
            star3: star3 ?? this.star3,
            star2: star2 ?? this.star2,
            star1: star1 ?? this.star1,
            average: average ?? this.average,
        );

    factory RatingSummary.fromJson(Map<String, dynamic> json) => RatingSummary(
        star5: json["Star5"],
        star4: json["Star4"],
        star3: json["Star3"],
        star2: json["Star2"],
        star1: json["Star1"],
        average: json["Average"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Star5": star5,
        "Star4": star4,
        "Star3": star3,
        "Star2": star2,
        "Star1": star1,
        "Average": average,
    };
}
