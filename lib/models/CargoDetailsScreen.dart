// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:io';

import 'package:bcladmin/models/models.dart';
import 'package:open_file/open_file.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CargoDetailsScreen extends StatefulWidget {
  
  final QueryDocumentSnapshot doc;
  final Models models;
  final String formattedDateTime;
  final String selectedDestination;
  final String selectedDestinationPrice;
  final String selectedRate;
  final String carDetails;
  final String documentId;
  final List<String> route;
  final String transitType;
  final String payment;
  final String username;
  final String phone;

  const CargoDetailsScreen({
    super.key,
    required this.formattedDateTime,
    required this.selectedDestination,
    required this.selectedDestinationPrice,
    required this.selectedRate,
    required this.carDetails,
    required this.models,
    required this.documentId,
    required this.route,
    required this.transitType,
    required this.payment,
    required this.doc,
    required this.username,
    required this.phone,
  
  });

  @override
  State<CargoDetailsScreen> createState() => _CargoDetailsScreenState();
}

class _CargoDetailsScreenState extends State<CargoDetailsScreen> {
   TextEditingController detailctrl = TextEditingController();
    TextEditingController pricectrl = TextEditingController();
    TextEditingController routectrl = TextEditingController();
    bool refresh = false;

    @override
      void dispose() {
    
    detailctrl.dispose();
    pricectrl.dispose();
    routectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargo Details'),
        actions: [
    ElevatedButton(
      onPressed: () {
        setState(() {
          refresh = !refresh; // Toggle the refresh state
        });
      },
      child: const Icon(Icons.refresh_rounded),
    ),
  ],
      ),
      body: Builder(builder: (context) {
        if(refresh){
        return Card(
          elevation: 5,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                widget.transitType,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Date: ${widget.formattedDateTime}'),
              Text('Name: ${widget.username}'),
              Text('Phone:  ${widget.phone}'),
              Text('Destination: ${widget.selectedDestination}'),
              Text('Price: Tshs ${widget.selectedDestinationPrice}'),
              Text('Payment rate: ${widget.selectedRate}'),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Payment status: ${widget.payment}'),
                  SizedBox(width: w * 0.019),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                    child: ElevatedButton(
                        onPressed: () {
                          widget.doc.reference.update(
                              {"payment": 'PAID', 'status': 'progressing'});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 4, 28, 104),
                        ),
                        child: const Text(
                          "PAID",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
              Text('Details: ${widget.carDetails}'),
              Text(
                  'Route: ${widget.route.isNotEmpty ? widget.route[0] : "N/A"}'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: TextFormField(
                  controller: detailctrl,
                  decoration: const InputDecoration(
                    labelText: "Car details",
                    hintMaxLines: 3,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter car details");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    detailctrl.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: TextFormField(
                  controller: pricectrl,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    hintMaxLines: 3,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter courier phone");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    pricectrl.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                child: ElevatedButton(
                    onPressed: () {
                      try {
                        widget.doc.reference.update({
                          'carDetails': detailctrl.text,
                          'selectedDestinationPrice': pricectrl.text
                        });

                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 28, 104),
                    ),
                    child: const Text(
                      "SUBMIT DETAILS",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                child: ElevatedButton(
                    onPressed: () {
                      downloadDoc();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 28, 104),
                    ),
                    child: const Text(
                      "DOWNLOAD",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: TextFormField(
                  controller: routectrl,
                  decoration: const InputDecoration(
                    labelText: "Update route",
                    hintMaxLines: 3,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter current location");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    routectrl.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                child: ElevatedButton(
                    onPressed: () {
                   
                        widget.doc.reference.update({'route': routectrl.text});
                      
                   
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 28, 104),
                    ),
                    child: const Text(
                      "UPDATE ROUTE",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        );
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Future<void> downloadDoc() async {
    try {
      if (widget.doc.exists) {
        final Map<String, dynamic> data =
            widget.doc.data() as Map<String, dynamic>;
        if (data.containsKey('passDoc')) {
          final String downloadUrl = data["passDoc"];

          final Directory appDirectory =
              await getApplicationSupportDirectory();
          const String downloadsFolderName = 'downloads'; // Name of the folder
          final Directory downloadsDirectory =
              Directory('${appDirectory.path}/$downloadsFolderName');
          if (!downloadsDirectory.existsSync()) {
            // Create the downloads folder if it doesn't exist
            downloadsDirectory.createSync(recursive: true);
          }

          const String fileName = 'downloaded_document.pdf';
          final String filePath = join(downloadsDirectory.path, fileName);

          final Reference storageRef =
              FirebaseStorage.instance.refFromURL(downloadUrl);
          final File downloadFile = File(filePath);

          await storageRef.writeToFile(downloadFile);

          if (await downloadFile.exists()) {
            Fluttertoast.showToast(
                msg: "File downloaded successfully",
                backgroundColor: Colors.green);
            // Open the file location (downloads folder) using a file manager
            OpenFile.open(filePath);
          } else {
            Fluttertoast.showToast(
                msg: "File not found after download",
                backgroundColor: Colors.red);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Download URL does not exist", backgroundColor: Colors.red);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Document does not exist", backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red);
    }
  }
}
