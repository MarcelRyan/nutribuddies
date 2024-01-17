import 'package:url_launcher/url_launcher.dart';

class SettingsService {
  void redirectEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nutribuddies@support.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Contact Us - User Inquiry',
        'body':
            'Hello NutriBuddies Support Team,\n\nI would like to inquire about the following:\n\n[Your message here. Provide details such as your account information, issue description, or any other relevant information.]\n\nThank you!',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }
}
