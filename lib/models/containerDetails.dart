// ignore_for_file: file_names

import 'package:bcladmin/models/models.dart';
import 'package:flutter/material.dart';

class ContainerDetails extends StatelessWidget {
  final Models models;
  final String formattedDateTime;
  final String selectedDestination;
  final String selectedDestinationPrice;
  final String selectedRate;
  final String carDetails;
  final String documentId;
  final String selectedType;
  final String numberContainer;
  final List<String> route;

  const ContainerDetails({
    super.key,
    required this.formattedDateTime,
    required this.selectedDestination,
    required this.selectedDestinationPrice,
    required this.selectedRate,
    required this.carDetails,
    required this.models,
    required this.documentId,
    required this.route,
    required this.selectedType,
    required this.numberContainer,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargo Details'),
      ),
      body: Builder(builder: (context) {
        return Card(
          elevation: 5,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Date: $formattedDateTime'),
              Text('Destination: $selectedDestination'),
              Text('Price: $selectedDestinationPrice'),
              Text('Payment rate: $selectedRate'),
              Text('Details: $carDetails'),
              Text('Container type: + $selectedType'),
              Text('Total containers: + $numberContainer'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                child: ElevatedButton(
                    onPressed: () {
                      //models.uploadDocument(context, documentId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 28, 104),
                    ),
                    child: const Text(
                      "UPLOAD RELEASE ORDER",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Text('Route: ${route.isNotEmpty ? route[0] : "N/A"}'),
            ],
          ),
        );
      }),
    );
  }
}
