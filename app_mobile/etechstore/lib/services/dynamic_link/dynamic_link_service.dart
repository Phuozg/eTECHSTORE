import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  static final DynamicLinkService _service = DynamicLinkService._internal();
  DynamicLinkService._internal();

  static DynamicLinkService get instance => _service;

  void createDynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://etechstore.page.link.com'),
        uriPrefix: 'https://etechstore.page.link/',
        androidParameters:
            const AndroidParameters(packageName: 'com.example.etechstore'),
        iosParameters: const IOSParameters(bundleId: 'com.example.etechstore'));

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
  }
}
