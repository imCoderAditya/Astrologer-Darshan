// Message Model
import 'package:astrology/app/modules/chat/controllers/chat_controller.dart';

class Message {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final MessageStatus status;
  final String? imageUrl;
  final MessageType type;
  final int? messageID;
  final int? sessionID;
  final int senderID;
  final bool isRead;

  Message({
    required this.id,
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    required this.senderID,
    this.status = MessageStatus.sent,
    this.imageUrl,
    this.type = MessageType.text,
    this.messageID,
    this.sessionID,
    this.isRead = false,
  });

  factory Message.fromWebSocket(Map<String, dynamic> json, int currentUserID) {
    return Message(
      id:
          json['messageID']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['content'] ?? '',
      isSentByMe: json['senderID'] == currentUserID,
      timestamp: DateTime.parse(
        json['sentAt'] ?? DateTime.now().toIso8601String(),
      ),
      senderID: json['senderID'] ?? 0,
      status:
          json['isRead'] == true ? MessageStatus.read : MessageStatus.delivered,
      type: _getMessageType(json['messageType']),
      messageID: json['messageID'],
      sessionID: json['sessionID'],
      isRead: json['isRead'] ?? false,
      imageUrl: json['fileURL'],
    );
  }

  // Convert Message to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isSentByMe': isSentByMe,
      'timestamp': timestamp.toIso8601String(),
      'status': status.index,
      'imageUrl': imageUrl,
      'type': type.index,
      'messageID': messageID,
      'sessionID': sessionID,
      'senderID': senderID,
      'isRead': isRead,
    };
  }

  // Convert JSON to Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isSentByMe: json['isSentByMe'] ?? false,
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      status: MessageStatus.values[json['status'] ?? 0],
      imageUrl: json['imageUrl'],
      type: MessageType.values[json['type'] ?? 0],
      messageID: json['messageID'],
      sessionID: json['sessionID'],
      senderID: json['senderID'] ?? 0,
      isRead: json['isRead'] ?? false,
    );
  }

  static MessageType _getMessageType(String? type) {
    switch (type?.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }

  // Copy method to update message properties
  Message copyWith({
    String? id,
    String? text,
    bool? isSentByMe,
    DateTime? timestamp,
    MessageStatus? status,
    String? imageUrl,
    MessageType? type,
    int? messageID,
    int? sessionID,
    int? senderID,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      messageID: messageID ?? this.messageID,
      sessionID: sessionID ?? this.sessionID,
      senderID: senderID ?? this.senderID,
      isRead: isRead ?? this.isRead,
    );
  }
}
