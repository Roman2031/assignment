import 'dart:io';

import 'package:assignment/post/post_list.dart';
import 'package:assignment/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment/model/model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  var collection = FirebaseFirestore.instance.collection("post");
  List<File> images = [];
  TextEditingController postTextController = TextEditingController();
  TextEditingController? selectedMonthDateController;
  //double width = MediaQuery.of(context).size.width - 16.0;
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();
  final TextEditingController airlineController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  DepartureAirport? selectedDepartureAirport;
  ArrivalAirport? selectedArrivalAirport;
  Airline? selectedAirline;
  Classes? selectedClass;
  DateTime? _selected;

  double rating = 0;
  int starCount = 5;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 16.0;
    selectedMonthDateController = TextEditingController(
      text: _selected == null ? '' : DateFormat().add_yM().format(_selected!),
    );
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Share"),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                label: "Share List",
                onPressed: () => goToShareList(context),
                            ),
              ),
        ],
      )),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [              
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  getMultipImage();
                },
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 50),
                        Text("Select Your Image Here"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                //width: Get.width,
                height: 150,
                child: images.length == 0
                    ? Center(child: Text("No Images found"))
                    : Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.file(images[i], fit: BoxFit.cover),
                            );
                          },
                          itemCount: images.length,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<DepartureAirport>(
                width: width,
                initialSelection: departureAirportItems.first,
                controller: departureController,
                requestFocusOnTap: true,
                enableFilter: true,
                trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                label: const Text('Departure Airport'),
                onSelected: (DepartureAirport? menu) {
                  selectedDepartureAirport = menu;
                },
                dropdownMenuEntries: departureAirportItems
                    .map<DropdownMenuEntry<DepartureAirport>>((
                      DepartureAirport menu,
                    ) {
                      return DropdownMenuEntry<DepartureAirport>(
                        value: menu,
                        labelWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.departureAirportName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              menu.departureAirportAddress,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        trailingIcon: Text(menu.departureAirportShortCode),
                        label: menu.departureAirportName,
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownMenu<ArrivalAirport>(
                width: width,
                initialSelection: arrivalAirportItems.first,
                controller: arrivalController,
                requestFocusOnTap: true,
                enableFilter: true,
                trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                label: const Text('Arrival Airport'),
                onSelected: (ArrivalAirport? menu) {
                  selectedArrivalAirport = menu;
                },
                dropdownMenuEntries: arrivalAirportItems
                    .map<DropdownMenuEntry<ArrivalAirport>>((
                      ArrivalAirport menu,
                    ) {
                      return DropdownMenuEntry<ArrivalAirport>(
                        value: menu,
                        labelWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.arrivalAirportName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              menu.arrivalAirportAddress,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        trailingIcon: Text(menu.arrivalAirportShortCode),
                        label: menu.arrivalAirportName,
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownMenu<Airline>(
                width: width,
                initialSelection: airlineItems.first,
                controller: airlineController,
                requestFocusOnTap: true,
                enableFilter: true,
                trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                label: const Text('Airline'),
                onSelected: (Airline? menu) {
                  selectedAirline = menu;
                },
                dropdownMenuEntries: airlineItems
                    .map<DropdownMenuEntry<Airline>>((Airline menu) {
                      return DropdownMenuEntry<Airline>(
                        value: menu,
                        labelWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.airlineName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              menu.airlineCountry,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        trailingIcon: Text(menu.airlineShortCode),
                        label: menu.airlineName,
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              DropdownMenu<Classes>(
                width: width,
                initialSelection: classItems.first,
                controller: classController,
                requestFocusOnTap: true,
                enableFilter: true,
                trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                label: const Text('Classes'),
                onSelected: (Classes? menu) {
                  selectedClass = menu;
                },
                dropdownMenuEntries: classItems.map<DropdownMenuEntry<Classes>>(
                  (Classes menu) {
                    return DropdownMenuEntry<Classes>(
                      value: menu,
                      label: menu.classType,
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                width: width,
                child: TextField(
                  controller: postTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your message',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                child: TextField(
                  //initialValue: DateFormat().add_yM().format(_selected!),
                  readOnly: true,
                  controller: selectedMonthDateController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async => _onPressed(context: context),
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Travel Date',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rating', style: TextStyle(color: Colors.grey)),
                    StarRating(
                      size: 25.0,
                      rating: rating,
                      color: Colors.orange,
                      borderColor: Colors.grey,
                      allowHalfRating: false,
                      starCount: starCount,
                      onRatingChanged: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    width: 175,
                    child: MaterialButton(
                      color: Colors.black,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 50,
                      onPressed: () async {
                        for (int i = 0; i < images.length; i++) {
                          String url = await uploadFile(images[i]);
                          downloadUrls.add(url);
                          String documentId = await getDocumentId();
                          if (i == images.length - 1) {
                            storeEntry(
                              documentId,
                              downloadUrls,
                              postTextController.text,
                              selectedDepartureAirport!.departureAirportName,
                              selectedDepartureAirport!.departureAirportAddress,
                              selectedDepartureAirport!
                                  .departureAirportShortCode,
                              selectedArrivalAirport!.arrivalAirportName,
                              selectedArrivalAirport!.arrivalAirportAddress,
                              selectedArrivalAirport!.arrivalAirportShortCode,
                              selectedAirline!.airlineName,
                              selectedAirline!.airlineCountry,
                              selectedAirline!.airlineShortCode,
                              selectedClass!.classType,
                              selectedMonthDateController!.text,
                              rating.toString(),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Share Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),                    
                  ),
                ],
              ),                    
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  List<String> downloadUrls = [];

  final ImagePicker _picker = ImagePicker();

  

    goToShareList(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostListScreen()),
      );  

  getMultipImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
      });

      setState(() {});
    }
  }

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      locale: localeObj,
    );
    if (selected != null) {
      setState(() {
        _selected = selected;
      });
    }
  }

   Future<String> getDocumentId() async {
        AggregateQuerySnapshot query = await collection.count().get();
        if(query.count != null || query.count != 0)
        return (query.count! + 1).toString();
        else
        return '1';
      }

Future<String> uploadFile(File file) async {
  final metaData = SettableMetadata(contentType: 'image/jpeg');
  final storageRef = FirebaseStorage.instance.ref();
  Reference ref = storageRef.child(
    'pictures/${DateTime.now().microsecondsSinceEpoch}.jpg',
  );
  final uploadTask = ref.putFile(file, metaData);

  final taskSnapshot = await uploadTask.whenComplete(() => null);
  String url = await taskSnapshot.ref.getDownloadURL();
  return url;
}

storeEntry(
  String documentId,
  List<String> imageUrls,
  String postText,
  String departureAirportName,
  String departureAirportAddress,
  String departureAirportShortCode,
  String arrivalAirportName,
  String arrivalAirportAddress,
  String arrivalAirportShortCode,
  String airlineName,
  String airlineCountry,
  String airlineShortCode,
  String className,
  String travelDate,
  String rating,
) {
print('document id '+ documentId);
  FirebaseFirestore.instance
      .collection('post').doc(documentId)
      .set({
        'createdOn': DateTime.now(),
        'image': imageUrls,
        'post': postText,
        'departureAirportName': departureAirportName,
        'departureAirportAddress': departureAirportAddress,
        'departureAirportShortCode': departureAirportShortCode,
        'arrivalAirportName': arrivalAirportName,
        'arrivalAirportAddress': arrivalAirportAddress,
        'arrivalAirportShortCode': arrivalAirportShortCode,
        'airlineName': airlineName,
        'airlineCountry': airlineCountry,
        'airlineShortCode': airlineShortCode,
        'className': className,
        'travelDate': travelDate,
        'rating': rating,
        'totalUpvote': 0,
        'comment': '',
        'Totalcomment': 0,
        'reply': '',
      })
      .then((value) {
        Get.snackbar('Success', 'Data is stored successfully');
      });
}

List<DepartureAirport> departureAirportItems = [
  DepartureAirport('', '', ''),
  DepartureAirport(
    'Chittagong, Bangladesh',
    'Shah Amanat International Airport',
    'CGP',
  ),
  DepartureAirport('Ishurdi Bangladesh', 'Ishurdi Airport', 'IRDF'),
  DepartureAirport('Jessor, Bangladesh', 'Jessor Airport', 'JSR'),
  DepartureAirport('Rajshahi, Bangladesh', 'Rajshahi, Bangladesh', 'RJH'),
  DepartureAirport('Saidpur, Bangladesh', 'Saidpur Airport', 'SPD'),
  DepartureAirport(
    'Sylhet Osmani, Bangladesh',
    'Osmany International Airport',
    'ZYL',
  ),
  DepartureAirport(
    'Dhaka, Bangladesh',
    'Hazrat Shahjalal International Airport',
    'DAC',
  ),
  DepartureAirport(
    'Coxs Bazar, Bangladesh',
    'Cox'
        's Bazar Airport',
    'CXB',
  ),
  DepartureAirport('Barisal, Bangladesh', 'Barisal Airport', 'BZL'),
];

List<ArrivalAirport> arrivalAirportItems = [
  ArrivalAirport('', '', ''),
  ArrivalAirport(
    'Chittagong, Bangladesh',
    'Shah Amanat International Airport',
    'CGP',
  ),
  ArrivalAirport('Ishurdi Bangladesh', 'Ishurdi Airport', 'IRDF'),
  ArrivalAirport('Jessor, Bangladesh', 'Jessor Airport', 'JSR'),
  ArrivalAirport('Rajshahi, Bangladesh', 'Rajshahi, Bangladesh', 'RJH'),
  ArrivalAirport('Saidpur, Bangladesh', 'Saidpur Airport', 'SPD'),
  ArrivalAirport(
    'Sylhet Osmani, Bangladesh',
    'Osmany International Airport',
    'ZYL',
  ),
  ArrivalAirport(
    'Dhaka, Bangladesh',
    'Hazrat Shahjalal International Airport',
    'DAC',
  ),
  ArrivalAirport(
    'Coxs Bazar, Bangladesh',
    'Cox'
        's Bazar Airport',
    'CXB',
  ),
  ArrivalAirport('Barisal, Bangladesh', 'Barisal Airport', 'BZL'),
];

List<Airline> airlineItems = [
  Airline('', '', ''),
  Airline('Air Bangladesh', 'Bangladesh', 'B9'),
  Airline('Biman Bangladesh Airlines', 'Bangladesh', 'BG'),
  Airline('Bismillah Airlines', 'Bangladesh', '5Z'),
  Airline('United Airlines', 'Bangladesh', '4H'),
  Airline('Emirates', 'United Arab Emirates', 'EK'),
];

List<Classes> classItems = [
  Classes(''),
  Classes('Any'),
  Classes('Business'),
  Classes('first'),
  Classes('Premium Economy'),
  Classes('Economy'),
];
}