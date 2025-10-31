
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    final bool? status;
    final String? message;
    final ProfileData? data;

    ProfileModel({
        this.status,
        this.message,
        this.data,
    });

    ProfileModel copyWith({
        bool? status,
        String? message,
        ProfileData? data,
    }) => 
        ProfileModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class ProfileData {
    final int? userId;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? phoneNumber;
    final String? dateOfBirth;
    final String? timeOfBirth;
    final String? placeOfBirth;
    final String? gender;
    final String? profilePicture;
    final String? userType;
    final bool? isVerified;
    final bool? isActive;
    final String? displayName;
    final String? bio;
    final int? experience;
    final String? specializations;
    final String? languages;
    final String? education;
    final String? certifications;
    final double? consultationRate;
    final double? rating;
    final int? totalRatings;
    final int? totalConsultations;
    final bool? isOnline;
    final bool? isAvailableForCall;
    final bool? isAvailableForChat;
    final bool? isBoosted;
    final bool? isApproved;
    final String? bankAccountDetails;
    final String? taxDetails;

    ProfileData({
        this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.dateOfBirth,
        this.timeOfBirth,
        this.placeOfBirth,
        this.gender,
        this.profilePicture,
        this.userType,
        this.isVerified,
        this.isActive,
        this.displayName,
        this.bio,
        this.experience,
        this.specializations,
        this.languages,
        this.education,
        this.certifications,
        this.consultationRate,
        this.rating,
        this.totalRatings,
        this.totalConsultations,
        this.isOnline,
        this.isAvailableForCall,
        this.isAvailableForChat,
        this.isBoosted,
        this.isApproved,
        this.bankAccountDetails,
        this.taxDetails,
    });

    ProfileData copyWith({
        int? userId,
        String? firstName,
        String? lastName,
        String? email,
        String? phoneNumber,
        String? dateOfBirth,
        String? timeOfBirth,
        String? placeOfBirth,
        String? gender,
        String? profilePicture,
        String? userType,
        bool? isVerified,
        bool? isActive,
        String? displayName,
        String? bio,
        int? experience,
        String? specializations,
        String? languages,
        String? education,
        String? certifications,
        double? consultationRate,
        double? rating,
        int? totalRatings,
        int? totalConsultations,
        bool? isOnline,
        bool? isAvailableForCall,
        bool? isAvailableForChat,
        bool? isBoosted,
        bool? isApproved,
        String? bankAccountDetails,
        String? taxDetails,
    }) => 
        ProfileData(
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
            placeOfBirth: placeOfBirth ?? this.placeOfBirth,
            gender: gender ?? this.gender,
            profilePicture: profilePicture ?? this.profilePicture,
            userType: userType ?? this.userType,
            isVerified: isVerified ?? this.isVerified,
            isActive: isActive ?? this.isActive,
            displayName: displayName ?? this.displayName,
            bio: bio ?? this.bio,
            experience: experience ?? this.experience,
            specializations: specializations ?? this.specializations,
            languages: languages ?? this.languages,
            education: education ?? this.education,
            certifications: certifications ?? this.certifications,
            consultationRate: consultationRate ?? this.consultationRate,
            rating: rating ?? this.rating,
            totalRatings: totalRatings ?? this.totalRatings,
            totalConsultations: totalConsultations ?? this.totalConsultations,
            isOnline: isOnline ?? this.isOnline,
            isAvailableForCall: isAvailableForCall ?? this.isAvailableForCall,
            isAvailableForChat: isAvailableForChat ?? this.isAvailableForChat,
            isBoosted: isBoosted ?? this.isBoosted,
            isApproved: isApproved ?? this.isApproved,
            bankAccountDetails: bankAccountDetails ?? this.bankAccountDetails,
            taxDetails: taxDetails ?? this.taxDetails,
        );

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        userId: json["UserID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        dateOfBirth: json["DateOfBirth"],
        timeOfBirth: json["TimeOfBirth"],
        placeOfBirth: json["PlaceOfBirth"],
        gender: json["Gender"],
        profilePicture: json["ProfilePicture"],
        userType: json["UserType"],
        isVerified: json["IsVerified"],
        isActive: json["IsActive"],
        displayName: json["DisplayName"],
        bio: json["Bio"],
        experience: json["Experience"],
        specializations: json["Specializations"],
        languages: json["Languages"],
        education: json["Education"],
        certifications: json["Certifications"],
        consultationRate: json["ConsultationRate"]?.toDouble(),
        rating: json["Rating"]?.toDouble(),
        totalRatings: json["TotalRatings"],
        totalConsultations: json["TotalConsultations"],
        isOnline: json["IsOnline"],
        isAvailableForCall: json["IsAvailableForCall"],
        isAvailableForChat: json["IsAvailableForChat"],
        isBoosted: json["IsBoosted"],
        isApproved: json["IsApproved"],
        bankAccountDetails: json["BankAccountDetails"],
        taxDetails: json["TaxDetails"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": dateOfBirth,
        "TimeOfBirth": timeOfBirth,
        "PlaceOfBirth": placeOfBirth,
        "Gender": gender,
        "ProfilePicture": profilePicture,
        "UserType": userType,
        "IsVerified": isVerified,
        "IsActive": isActive,
        "DisplayName": displayName,
        "Bio": bio,
        "Experience": experience,
        "Specializations": specializations,
        "Languages": languages,
        "Education": education,
        "Certifications": certifications,
        "ConsultationRate": consultationRate,
        "Rating": rating,
        "TotalRatings": totalRatings,
        "TotalConsultations": totalConsultations,
        "IsOnline": isOnline,
        "IsAvailableForCall": isAvailableForCall,
        "IsAvailableForChat": isAvailableForChat,
        "IsBoosted": isBoosted,
        "IsApproved": isApproved,
        "BankAccountDetails": bankAccountDetails,
        "TaxDetails": taxDetails,
    };
}
