import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';


class WorldTime {

  String location; // location name of the UI
  late String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  late bool? isDayTime; // true or false if daytime or not

 // create a constructor with the location name and the url
  WorldTime({ required this.location, required this.flag, required this.url});


  Future<void> getTime() async{
    try {
      Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      //print(data);

      // get properties from data
      String datetime = data['datetime'];

      // convert to DateTime and add offset

      DateTime now = (DateTime.parse(datetime)).add(Duration(hours: int.parse(data['utc_offset'].substring(1,3))));

      // set the time property

      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } on Exception catch (e) {
      print("Error while getting data $e");
    }
  }


  static dynamic getCountries() async{
    try {
      Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/'));
      return json.decode(response.body);

    } on Exception catch (e) {
      print("Error while getting data $e");
      rethrow;
    }
  }

}