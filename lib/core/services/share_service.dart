import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text, {String? subject}) =>
      Share.share(text, subject: subject);
}
