import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter_rating/flutter_rating.dart';


class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>  {

var collection =  FirebaseFirestore.instance.collection("post");
late List<Map<String, dynamic>> allPosts;
bool isloaded = false;

double rating = 0;
int starCount = 5;

 @override
  void initState() {

    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Posts"),
          ),
          body: Center(
            child: isloaded?ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context,index){
                print("0 image url: " + allPosts[index]["image"][0]);
                print("1 image url: " + allPosts[index]["image"][1]);
                print("total image: " + allPosts[index]["image"].length.toString());
                return Padding(padding: EdgeInsetsGeometry.all(8),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadiusGeometry.circular(20)
                  ),
                  title: Container(
                    child: Column(
                      children: [
                        Row(children: [
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_circle_rounded,size: 75,color: Colors.grey),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Column(
                                            children: [
                                              Text("Person " + (index + 1).toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text((index + 1).toString()+ ' second ago', style: TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        ),                                   
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80),
                                      child: Column(
                                        children: [
                                        //Icon(Icons.more_horiz_rounded,size: 30,color: Colors.black),
 Container(
               child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  StarRating(
                    size: 20.0,
                    rating: double.parse(allPosts[index]["rating"]),
                    color: Colors.orange,
                    borderColor: Colors.grey,
                    allowHalfRating: false,
                    starCount: starCount,
                    ),                    
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(allPosts[index]["rating"],style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),                     
                 ],
               ),
             ),
                                        ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.grey.shade200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                                child: Text(allPosts[index]["departureAirportShortCode"], style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.grey.shade200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                                child: Text(allPosts[index]["arrivalAirportShortCode"], style: TextStyle(fontWeight: FontWeight.bold),softWrap: true,),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  color: Colors.grey.shade200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                                    child: Text(allPosts[index]["airlineName"], style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),                        
                              ),
                            ),
                          ),
                        ],),

                      Row(children: [
                         Flexible(
                           child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                                  child: Text(allPosts[index]["className"], style: TextStyle(fontWeight: FontWeight.bold),softWrap: true,),
                                ),
                              ),
                            ),
                         ),
                          Flexible(
                           child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
                                  child: Text(getMonthAndYearFormate(allPosts[index]["travelDate"]), style: TextStyle(fontWeight: FontWeight.bold),softWrap: true,),
                                ),
                              ),
                            ),
                         ),                         
                      ],),
                      Row(children: [
                        Flexible(
                           child: Padding(
                              padding: const EdgeInsets.all(8.0),
                                child:Text(getMonthAndYearFormate(allPosts[index]["post"]),softWrap: true,),
                                ),                              
                            ),                      
                      ],),
                      Column(
                            children: [                              
                              Row(
                                children: <Widget>[   
                                  for(int i = 0; i < allPosts[index]["image"].length; i++)                      
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                          width: 100,
                                          height: 150,
                                          child: Image.network(
                                                          allPosts[index]["image"][i],
                                                        ),      
                                                        ),
                                  ),
                              ],)
                              
                            ],
                          ), 
                      ],
                    ),
                  ),
                ),
                );
                
            }): getProgressBar(),
          ),
        );
        
      }

      getPostList() async {
  late List<Map<String, dynamic>> tempList = [];
    // Get docs from collection reference
     var data = await collection.get();
    
    data.docs.forEach((element){
      tempList.add(element.data());

    });

    setState(() {
      allPosts = tempList;
      isloaded = true;
    });

    print(allPosts);
}
  }

  
  


  Widget getProgressBar() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }

  String getMonthAndYearFormate(String monthAndYear){
 final monthstr = monthAndYear.indexOf("/", 0);
 final yearstr = monthAndYear.substring(monthAndYear.lastIndexOf('/') + 1);
 
String month = '';

 if (monthstr == 1) {
   month = "Jan";
 }

 if (monthstr == 2) {
   month = "Feb";
 }
  if (monthstr == 3) {
   month = "Mar";
 }

 if (monthstr == 4) {
   month = "Apr";
 }
 if (monthstr == 5) {
   month = "May";
 }
 if (monthstr == 6) {
   month = "Jun";
 }

 if (monthstr == 7) {
   month = "Jul";
 }
  if (monthstr == 8) {
   month = "Aug";
 }
  if (monthstr == 9) {
   month = "Sep";
 }
 if (monthstr == 10) {
   month = "Oct";
 }
  if (monthstr == 11) {
   month = "Nov";
 }
 if (monthstr == 12) {
   month = "Dec";
 }

 return month + " " + yearstr;  
}

class Post {
  String departureAirportName;
  int departureAirportAddress;

  Post({required this.departureAirportName, required this.departureAirportAddress});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      departureAirportName: json['departureAirportName'],
      departureAirportAddress: json['departureAirportAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departureAirportName': departureAirportName,
      'departureAirportAddress': departureAirportAddress,
    };
  }
}