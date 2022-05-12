import 'dart:convert';
import 'package:http/http.dart';


class WorldTime {

  String? location; // location name of the UI
  String? time; // the time in that location
  String? flag; // url to an asset flag icon
  String? url; // location url for api endpoint

 // create a constructor with the location name and the url
  WorldTime({this.location, this.flag, this.url});



  Future<void> getTime() async{
    Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
    Map data = jsonDecode(response.body);
    //print(data);

    // get properties from data
    String datetime = data['datetime'];

    // get the offset and convert to duration
    Duration offset = Duration(hours: int.parse(data['utc_offset'].substring(1,3)));

    DateTime now = (DateTime.parse(datetime)).add(offset);

    // set the time property
    time = now.toString();
  }

}