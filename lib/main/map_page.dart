import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:modu_tour/data/tour.dart';
import 'package:modu_tour/data/list_data.dart';
import 'package:sqflite/sqflite.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference databaseReference;
  final Future<Database>? db;
  final String? id;

  const MapPage({
    super.key,
    required this.databaseReference,
    this.db,
    required this.id,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<DropdownMenuItem> list = [];
  List<DropdownMenuItem> sublist = [];
  List<TourData> tourData = [];
  ScrollController? _scrollController;

  String authKey =
      'ZL0j0%2B1pIslVRHYPiheOQ9SNCDzuiYeYE8jnh5cA1BMBsgabwnn6N32nwEuvsnI80j%2BLBI3T0KVdY3mV8XlFAw%3D%3D';

  double? mapX, mapY;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;

    area = list[0].value;
    kind = sublist[0].value;

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(
          mapX: mapX,
          mapY: mapY,
          contentTypeId: kind!.value,
          page: page,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색하기'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                    items: list,
                    onChanged: (value) {
                      Item selectedItem = value!;
                      setState(() {
                        area = selectedItem;
                      });
                    },
                    value: area,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: sublist,
                    onChanged: (value) {
                      Item selectedItem = value!;
                      setState(() {
                        kind = selectedItem;
                      });
                    },
                    value: kind,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      page = 1;
                      tourData.clear();
                      getAreaList(
                          mapX: mapX,
                          contentTypeId: kind!.value,
                          page: page);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 4,
                    ),
                    child: const Text(
                      '검색하기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        child: Row(
                          children: [
                            Hero(
                              tag: 'tourinfo$index',
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: getImage(tourData[index].imagePath),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    tourData[index].title!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('주소 : ${tourData[index].address}'),
                                  tourData[index].tel != null
                                      ? Text('전화 번호 : ${tourData[index].tel}')
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                  itemCount: tourData.length,
                  controller: _scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null) {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('repo/images/map_location.png');
    }
  }

  void getAreaList({
    required double mapX,
    required double mapY,
    required int contentTypeId,
    required int page,
  }) async {
    var url =
        'https://apis.data.go.kr/B551011/KorService1/locationBasedList1?serviceKey=$authKey&numOfRows=10&pageNo=$page&MobileOS=ETC&MobileApp=AppTest&_type=json&listYN=Y&arrange=A&mapX=$mapX&mapY=$mapY&radius=1000&contentTypeId=$contentTypeId';
    if (contentTypeId != 0) {}
  }
}
