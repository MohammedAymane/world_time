import 'dart:convert';

import "package:flutter/material.dart";
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:http/http.dart';
import '../services/world_time.dart';


class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {



  late List<WorldTime> locationsList = [];
  late List<WorldTime> locationsToShow = [];

  @override
  void initState() {
    super.initState();
    get(Uri.parse('http://worldtimeapi.org/api/timezone/')).then((value) {
      dynamic data = json.decode(value.body);
      for(int i = 0; i < data.length; i++){
        if(data[i].contains("/")){
          setState(() {
            dynamic location = data[i].split("/");
            if(location.length > 2){
              print(location);
              locationsList.add(WorldTime(url: data[i], location: '${location.sublist(1,3)[0]}/${location.sublist(1,3)[1]}', flag: "uk.png"));
              locationsToShow.add(WorldTime(url: data[i], location: '${location.sublist(1,3)[0]}/${location.sublist(1,3)[1]}', flag: "uk.png"));

            }else{
              locationsList.add(WorldTime(url: data[i], location: (data[i].split("/")).sublist(1)[0], flag: "uk.png"));
              locationsToShow.add(WorldTime(url: data[i], location: (data[i].split("/")).sublist(1)[0], flag: "uk.png"));
            }

          });
        }
      }

    });

      }


          void updateTime(index) async{
        WorldTime instance = locationsToShow[index];

        await instance.getTime();
        //navigate to home screen
        Navigator.pop(context, {
          'location': instance.location,
          'flag': instance.flag,
          'time': instance.time,
          'isDayTime': instance.isDayTime,
        });
      }


      @override
      Widget build(BuildContext context) {



        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: EasySearchBar(
            title: Text('Choose a Location',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onSearch: (value) => setState(() {
              locationsToShow = locationsList.where((country) => country.location.toLowerCase().contains(value.toLowerCase())).toList();
            }),
            backgroundColor: Colors.blue[900],
            elevation: 0,
            searchBackgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListView.builder(
                itemCount: locationsToShow.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          updateTime(index);
                        },
                        title: Text(locationsToShow[index].location),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/${locationsToShow[index].flag}'),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      }
    }


