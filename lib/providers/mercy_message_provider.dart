import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final mercyMessageProvider = Provider<String>((ref) {
  final now = DateTime.now();
  final todayStr = "${now.year}-${now.month}-${now.day}";
  
  final cachedDay = StorageService.getMercyMessageCachedDay();
  final cachedMsg = StorageService.getMercyMessageCachedMsg();
  
  final messages = [
    'أهدِ ثواب قراءتك لمن تحب.',
    'اللهم اجعل أعمالنا نورًا في قبور موتانا.',
    'يمكنك إضافة اسم متوفى وإهداء أعمالك له.',
    'اجعل أعمالك الجارية هديةً لمن تحب.',
    'اللهم تقبل أعمالنا واجعل ثوابها في ميزان حسناتهم.',
  ];

  if (cachedDay == todayStr && cachedMsg != null && messages.contains(cachedMsg)) {
    return cachedMsg;
  }
  
  // Pick random message, ensuring it's different if possible
  final random = Random();
  String selectedMsg;
  if (cachedMsg != null && messages.length > 1) {
    final otherMessages = messages.where((m) => m != cachedMsg).toList();
    selectedMsg = otherMessages[random.nextInt(otherMessages.length)];
  } else {
    selectedMsg = messages[random.nextInt(messages.length)];
  }
  
  // Save cache
  StorageService.saveMercyMessageCache(selectedMsg, todayStr);
  
  return selectedMsg;
});
