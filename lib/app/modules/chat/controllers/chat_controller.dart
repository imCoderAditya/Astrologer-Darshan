import 'dart:async';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/message/message_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/app/services/webshoket/web_shoket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum MessageStatus { sending, sent, delivered, read }

enum MessageType { text, image, voice }

// Chat Controller
class ChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var showEmojiPicker = false.obs;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  StreamSubscription? _wsSubscription;

  // WebSocket service
  WebSocketService? webSocketService;

  // Storage instance
  final GetStorage storage = GetStorage();

  final RxList<Message> messages = <Message>[].obs;
  final RxBool isTyping = false.obs;
  final RxString messageText = ''.obs;

  // Chat info
  // final RxString chatTitle = 'Sarah Johnson'.obs;
  final RxString lastSeen = 'Online'.obs;

  // Current user ID
  int? currentUserID;
  int? sessionID;
  RxBool isDisable = false.obs;
  final msg = """Welcome to Astro Darshan! ✨
We’re glad to have you here. Our expert astrologers are ready to guide you with insights and remedies tailored just for you. 🙏
Please confirm your name, date of birth, time, and place of birth to begin your consultation.""";

  Future<void> setData({int? sessionId, String? status}) async {
    final userId_ = LocalStorageService.getUserId();
    final userId = userId_;
    currentUserID = int.parse(userId.toString());
    sessionID = sessionId;
    update();
    debugPrint("currentUserID=$currentUserID sessionID $sessionID");
    await initializeWebSocket();

    if (status?.toLowerCase() == "pending") {
      await Future.delayed(Duration(seconds: 1));
      sendMessage(message: msg);
    }
  }

  // Storage key for messages
  String get messagesKey => 'chat_messages_session_$sessionID';

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    messageController.addListener(() {
      messageText.value = messageController.text;
      isTyping.value = messageController.text.isNotEmpty;
    });

    animationController.forward();
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  void hideEmojiPicker() {
    showEmojiPicker.value = false;
  }

  Future<void> initializeWebSocket() async {
    messages.clear();
    scrollToBottom();
    // Check if WebSocketService is already initialized
    if (Get.isRegistered<WebSocketService>()) {
      webSocketService = Get.find<WebSocketService>();
    } else {
      webSocketService = Get.put(WebSocketService());
    }

    // Connect if not already connected
    if (!(webSocketService?.isConnected.value == true)) {
      webSocketService?.connect(sessionId: sessionID.toString());
    }

    // Cancel previous subscription before listening again
    _wsSubscription?.cancel();

    // Listen to incoming messages
    _wsSubscription = webSocketService?.messageStream.listen((messageData) {
      handleIncomingMessage(messageData);
    });
  }

  void handleIncomingMessage(Map<String, dynamic> messageData) {
    LoggerUtils.debug("📨 Received message: $messageData");

    if (messageData['type'] == 'chat_message') {
      final incomingMessage = Message.fromWebSocket(
        messageData,
        currentUserID ?? 0,
      );

      if (incomingMessage.text.toLowerCase() == "disconnect") {
        isDisable.value = true;
      }

      LoggerUtils.debug(
        "📋 Processed message - SenderID: ${incomingMessage.senderID}, CurrentUserID: $currentUserID, Text: ${incomingMessage.text}",
      );

      // Check if this message is from current user (our own message coming back from server)
      if (incomingMessage.senderID == currentUserID) {
        LoggerUtils.debug("🔄 This is our own message coming back from server");

        // ✅ Find local message by text content and remove it, then add server message
        final localMessageIndex = messages.indexWhere(
          (message) =>
              message.isSentByMe &&
              message.text == incomingMessage.text &&
              message.senderID == currentUserID &&
              message.messageID == null, // Local messages don't have messageID
        );

        if (localMessageIndex != -1) {
          // ✅ Remove local message and add server message at same position
          messages.removeAt(localMessageIndex);
          messages.insert(localMessageIndex, incomingMessage);

          LoggerUtils.debug("✅ Replaced local message with server message");
        } else {
          LoggerUtils.debug(
            "⚠️ No matching local message found - adding as new message",
          );

          // If we can't find matching local message, add as new
          final existingIndex = messages.indexWhere(
            (m) => m.messageID == incomingMessage.messageID,
          );

          if (existingIndex == -1) {
            messages.add(incomingMessage);
            scrollToBottom();

            LoggerUtils.debug("✅ Added own message as new");
          }
        }
      } else {
        // This is a message from another user
        LoggerUtils.debug("👤 Message from another user");

        // Check if message already exists to prevent duplicates
        final existingIndex = messages.indexWhere(
          (m) => m.messageID == incomingMessage.messageID,
        );

        if (existingIndex == -1) {
          messages.add(incomingMessage);
          scrollToBottom();
          LoggerUtils.debug("✅ Added new message from other user");
        } else {
          LoggerUtils.debug(
            "⚠️ Message from other user already exists, skipping",
          );
        }
      }
    }
  }

  void sendMessage({String? message}) {
    // if (messageController.text.trim().isEmpty) return;

    final messageText = message ?? messageController.text.trim();
    final localId = DateTime.now().millisecondsSinceEpoch.toString();

    // Remove all spaces before checking
    String cleanedInput = messageText.replaceAll(' ', '');
    debugPrint(cleanedInput);
    // ✅ Allow dd-MM-yyyy or dd/MM/yyyy format
    final dateFormatRegExp = RegExp(r'^\d{1,2}[-/]\d{1,2}[-/]\d{2,4}$');

    // If it's not a valid date format and contains numbers → block it
    if (!dateFormatRegExp.hasMatch(cleanedInput) &&
        RegExp(r'[0-9]').hasMatch(cleanedInput)) {
      messageController.clear();
      return;
    }

    // ✅ Create local message for immediate UI update (NO messageID)
    final localMessage = Message(
      id: localId,
      text: messageText,
      isSentByMe: true,
      timestamp: DateTime.now(),
      senderID: currentUserID ?? 0,
      status: MessageStatus.sending,
      messageID: null, // ✅ Local message has no messageID
    );

    // ✅ Add local message immediately to show on screen
    messages.add(localMessage);
    messageController.clear();
    this.messageText.value = '';
    isTyping.value = false;
    scrollToBottom();

    LoggerUtils.debug(
      "✅ Added local message with status: sending - ID: $localId",
    );

    // Send via WebSocket
    final messageData = {
      "SenderID": currentUserID,
      "MessageType": "Text",
      "Content": messageText,
      "FileURL": null,
    };

    webSocketService?.sendMessage(messageData);

    // Update local message status to sent after sending
    Future.delayed(const Duration(milliseconds: 500), () {
      final index = messages.indexWhere((m) => m.id == localId);
      if (index != -1 && messages[index].status == MessageStatus.sending) {
        messages[index] = messages[index].copyWith(status: MessageStatus.sent);
        LoggerUtils.debug("✅ Updated local message status to: sent");
      }
    });
  }

  void clearChatHistory() {
    messages.clear();
    storage.remove(messagesKey);
    LoggerUtils.debug("✅ Chat history cleared");
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    // Cancel subscription

    _wsSubscription?.cancel();
    _wsSubscription = null;

    // Dispose controllers
    messageController.dispose();
    scrollController.dispose();
    animationController.dispose();

    super.onClose();
  }
}
