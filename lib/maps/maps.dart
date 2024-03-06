import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  //latitude longitude
  static Future<void> openMapWithPosition(double lat, double lng) async {
    String googleMapURL =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    Uri mapURL = Uri.parse((googleMapURL));

    if (await canLaunchUrl(mapURL)) {
      await launchUrl(mapURL);
    } else {
      throw "can't open Maps";
    }
  }

  //text address
  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeComponent(fullAddress);
    String googleMapURL =
        "https://www.google.com/maps/search/?api=1&query=$query";
    Uri mapURL = Uri.parse((googleMapURL));

    if (await canLaunchUrl(mapURL)) {
      await launchUrl(mapURL);
    } else {
      throw "can't open Maps";
    }
  }
}
