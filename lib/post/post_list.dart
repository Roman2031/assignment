import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_rating/flutter_rating.dart';
import 'package:share_plus/share_plus.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  var collection = FirebaseFirestore.instance.collection("post");
  late List<Map<String, dynamic>> allPosts;
  bool isloaded = false;
  bool likeButtonTaggle = false;
  String commentStr = '';


  double rating = 0;
  int starCount = 5;
  int totalLike = 0;
  int totalComment = 0;
 final TextEditingController _commentTextEditorController = TextEditingController();
  FocusNode inputNode = FocusNode();
// to open keyboard call this function;
void openKeyboard(){
FocusScope.of(context).requestFocus(inputNode);
}

  @override
  void initState() {
    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("Posts")),
      body: loadPage()
    );
  }

  Widget loadPage(){
    return Center(
        child: isloaded
            ? ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.transparent),
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      title: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.account_circle_rounded,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Person " +
                                                          (index + 1)
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      (index + 1).toString() +
                                                          ' second ago',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 80
                                            ),
                                            child: Column(
                                              children: [
                                                //Icon(Icons.more_horiz_rounded,size: 30,color: Colors.black),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      StarRating(
                                                        size: 20.0,
                                                        rating: double.parse(
                                                          allPosts[index]["rating"],
                                                        ),
                                                        color: Colors.orange,
                                                        borderColor:
                                                            Colors.grey,
                                                        allowHalfRating: false,
                                                        starCount: starCount,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 3,
                                                            ),
                                                        child: Text(
                                                          allPosts[index]["rating"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Card(
                                    color: Colors.grey.shade200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        allPosts[index]["departureAirportShortCode"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),                                
                                Card(
                                    color: Colors.grey.shade200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        allPosts[index]["arrivalAirportShortCode"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),                                
                                Flexible(
                                    child: Card(
                                      color: Colors.grey.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          getMonthAndYearFormate(
                                            allPosts[index]["travelDate"],
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),                                  
                                ),                               
                              ],
                            ),
                            Row(children: [
                               Flexible(
                                    child: Card(
                                      color: Colors.grey.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          allPosts[index]["airlineName"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),                                      
                                    ),
                                  ),
                                ),    
                            ]),

                            Row(
                              children: [
                                Flexible(
                                    child: Card(
                                      color: Colors.grey.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          allPosts[index]["className"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          softWrap: true,
                                        ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getMonthAndYearFormate(
                                        allPosts[index]["post"],
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < allPosts[index]["image"].length;
                                      i++
                                    )
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
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [allPosts[index]["like"] == 0  || allPosts[index]["like"] == null
                                        ? Text("0 Like"): Text(allPosts[index]["like"].toString() + " Like"),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "|",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {clickCommentIcon();},
                                            child: allPosts[index]["Totalcomment"] == 0  || allPosts[index]["Totalcomment"] == null
                                        ? Text("0 Comment"): Text(allPosts[index]["Totalcomment"].toString() + " Comment"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: ()async{clicklikeIcon(index+1);},
                                          icon: allPosts[index]["like"] == 0  || allPosts[index]["like"] == null
                                              ? Icon(
                                                  Icons
                                                      .thumb_up_off_alt_outlined,
                                                )
                                              : Icon(Icons.thumb_up_alt_sharp),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            clicklikeIcon(index+1);
                                          },
                                          child: Text("Like"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: clickshareIcon,
                                      icon: Icon(Icons.screen_share_outlined),
                                    ),
                                    GestureDetector(onTap: (){clickshareIcon();}, child: Text("Share")),
                                  ],
                                ),
                              ],
                            ),
                            allPosts[index]["comment"] != '' ? Row(children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: MediaQuery.of(context).size.width - 60,
                                 decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.grey.shade200
  ),
                                child: Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.account_circle_rounded,
                                            size: 50,
                                            color: Colors.grey,
                                          ), Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 25,
                                                top: 8,
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                allPosts[index]["comment"],
                                                softWrap: true,                                              
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ) 
                            ],) : Container(),
                            Row(
                              children: [    
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_circle_rounded,
                                          size: 50,
                                          color: Colors.grey,
                                        ),  
                                        Container(width: (MediaQuery.of(context).size.width - 220),height: 50, child: TextField(
                  controller: _commentTextEditorController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),),                    
                    hintText: 'Write your comment',
                    hintStyle: TextStyle()
                  )
                )),
                Padding(padding: EdgeInsetsGeometry.all(8),
                child: IconButton(onPressed: (){
                 addComment(_commentTextEditorController.text,index+1);
                }, icon: Icon(Icons.send_sharp),iconSize: 30))                                     
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : getProgressBar(),
      );
  }

  getPostList() async {
    late List<Map<String, dynamic>> tempList = [];
    // Get docs from collection reference
    var data = await collection.get();

    data.docs.forEach((element) {
      tempList.add(element.data());
    });

    setState(() {
      allPosts = tempList;
      isloaded = true;
    });

    print(allPosts);
  }

  Future<void> clicklikeIcon(int index) async {    
collection.doc(index.toString()).update({'like' : totalLike});
    setState(() {      
      loadPage();
      if (!likeButtonTaggle) {
        likeButtonTaggle = true;
        totalLike = 1;
        return;
      }
      if (likeButtonTaggle) {
        likeButtonTaggle = false;
        totalLike = 0;
      }
    });    
  }
  Future<void>clickCommentIcon() async {
    print('comment clicked');
   openKeyboard();
  }

  clickshareIcon() async {
    SharePlus.instance.share(
  ShareParams(text: ' ')
);
}

  
addComment(String comment,int index){
  if (comment != null || comment != '') {
    collection.doc(index.toString()).update({'comment' : comment,'Totalcomment' : 1});
   setState(() {
    commentStr = comment;
    _commentTextEditorController.text = '';
    print('index: '+ index.toString());
  }); 
  }  
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


String getMonthAndYearFormate(String monthAndYear) {
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

  Post({
    required this.departureAirportName,
    required this.departureAirportAddress,
  });

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