// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
    final bool? status;
    final String? message;
    final Summary? summary;
    final List<Transaction>? transactions;

    WalletModel({
        this.status,
        this.message,
        this.summary,
        this.transactions,
    });

    WalletModel copyWith({
        bool? status,
        String? message,
        Summary? summary,
        List<Transaction>? transactions,
    }) => 
        WalletModel(
            status: status ?? this.status,
            message: message ?? this.message,
            summary: summary ?? this.summary,
            transactions: transactions ?? this.transactions,
        );

    factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        status: json["status"],
        message: json["message"],
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "summary": summary?.toJson(),
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    };
}

class Summary {
    final double? availableBalance;
    final double? totalWithdrawAmount;
    final double? totalPendingWithdraw;
    final double? totalCancelledWithdraw;
    final double? overallIncome;

    Summary({
        this.availableBalance,
        this.totalWithdrawAmount,
        this.totalPendingWithdraw,
        this.totalCancelledWithdraw,
        this.overallIncome,
    });

    Summary copyWith({
        double? availableBalance,
        double? totalWithdrawAmount,
        double? totalPendingWithdraw,
        double? totalCancelledWithdraw,
        double? overallIncome,
    }) => 
        Summary(
            availableBalance: availableBalance ?? this.availableBalance,
            totalWithdrawAmount: totalWithdrawAmount ?? this.totalWithdrawAmount,
            totalPendingWithdraw: totalPendingWithdraw ?? this.totalPendingWithdraw,
            totalCancelledWithdraw: totalCancelledWithdraw ?? this.totalCancelledWithdraw,
            overallIncome: overallIncome ?? this.overallIncome,
        );

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        availableBalance: json["availableBalance"]?.toDouble(),
        totalWithdrawAmount: json["totalWithdrawAmount"]?.toDouble(),
        totalPendingWithdraw: json["totalPendingWithdraw"]?.toDouble(),
        totalCancelledWithdraw: json["totalCancelledWithdraw"]?.toDouble(),
        overallIncome: json["overallIncome"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "availableBalance": availableBalance,
        "totalWithdrawAmount": totalWithdrawAmount,
        "totalPendingWithdraw": totalPendingWithdraw,
        "totalCancelledWithdraw": totalCancelledWithdraw,
        "overallIncome": overallIncome,
    };
}

class Transaction {
    final int? transactionId;
    final String? transactionType;
    final double? amount;
    final String? description;
    final String? reference;
    final String? status;
    final String? createdAt;

    Transaction({
        this.transactionId,
        this.transactionType,
        this.amount,
        this.description,
        this.reference,
        this.status,
        this.createdAt,
    });

    Transaction copyWith({
        int? transactionId,
        String? transactionType,
        double? amount,
        String? description,
        String? reference,
        String? status,
        String? createdAt,
    }) => 
        Transaction(
            transactionId: transactionId ?? this.transactionId,
            transactionType: transactionType ?? this.transactionType,
            amount: amount ?? this.amount,
            description: description ?? this.description,
            reference: reference ?? this.reference,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["TransactionID"],
        transactionType: json["TransactionType"],
        amount: json["Amount"]?.toDouble(),
        description: json["Description"],
        reference: json["Reference"],
        status: json["Status"],
        createdAt: json["CreatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "TransactionID": transactionId,
        "TransactionType": transactionType,
        "Amount": amount,
        "Description": description,
        "Reference": reference,
        "Status": status,
        "CreatedAt": createdAt,
    };
}
