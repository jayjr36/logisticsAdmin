// ignore_for_file: library_private_types_in_public_api, must_be_immutable, duplicate_ignore, use_build_context_synchronously, depend_on_referenced_packages
import 'package:bcladmin/models/CargoDetailsScreen.dart';
import 'package:bcladmin/models/containerDetails.dart';
import 'package:bcladmin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DeliveredOrder extends StatefulWidget {
  const DeliveredOrder({
    super.key,
  });

  @override
  State<DeliveredOrder> createState() => _DeliveredOrderState();
}

class _DeliveredOrderState extends State<DeliveredOrder> {
  bool isUploading = false;
  Map<String, int> items = {};
  String selectedClass = 'Container';
  void setSelectedClass(String className) {
    setState(() {
      selectedClass = className;
    });
  }

  Color getButtonColor(String className) {
    return className == selectedClass
        ? const Color.fromARGB(255, 4, 28, 104)
        : const Color.fromARGB(255, 240, 235, 235);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text('DELIVERED SHIPMENTS'),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(h * 0.05),
              child: Wrap(
                children: [
                  // items=widget.count.itemCounts;
                  TextButton(
                    onPressed: () {
                      setSelectedClass('Container');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: getButtonColor('Container'),
                    ),
                    child: const Text("Container"),
                  ),
                  SizedBox(width: w * 0.01),
                  TextButton(
                    onPressed: () {
                      setSelectedClass('Loose cargo');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: getButtonColor('Loose cargo'),
                    ),
                    child: const Text("Loose cargo"),
                  ),
                  SizedBox(width: w * 0.01),
                  TextButton(
                    onPressed: () {
                      setSelectedClass('Abnormal');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: getButtonColor('Abnormal'),
                    ),
                    child: const Text("Abnormal"),
                  ),
                  SizedBox(width: w * 0.01),
                  TextButton(
                    onPressed: () {
                      setSelectedClass('Fuel');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: getButtonColor('Fuel'),
                    ),
                    child: const Text("Fuel"),
                  ),
                ],
              ))),
      body: _buildBody(selectedClass),
    );
  }
}

Widget _buildBody(String selectedClass) {
  switch (selectedClass) {
    case 'Container':
      return ContainerC(
        dataScreen: _DeliveredOrderState(),
      );
    case 'Loose cargo':
      return LooseCargo(dataScreen: _DeliveredOrderState());
    case 'Abnormal':
      return Abnormal(dataScreen: _DeliveredOrderState());
    case 'Fuel':
      return Fuel(
        dataScreen: _DeliveredOrderState(),
      );
    default:
      return const Center(
        child: Text('Select the the type of shipment.'),
      );
  }
}

class ContainerC extends StatelessWidget {
  final _DeliveredOrderState dataScreen;
  bool isloading = false;

  ContainerC({super.key, required this.dataScreen});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('myorders')
            .where('containerSelected', isEqualTo: true)
            .where('status', isEqualTo: 'delivered')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Image(
                image: const AssetImage('assets/nothing.gif'),
                height: h * 0.35,
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              final documentId = doc.id;
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDateTime =
                  DateFormat('yyyy-MM-dd     HH:mm').format(timestamp.toDate());

              final List<String> route = (data['route'] as String).split(', ');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContainerDetails(
                        formattedDateTime: formattedDateTime,
                        selectedDestination: data['selectedDestination'],
                        selectedDestinationPrice:
                            data['selectedDestinationPrice'],
                        selectedRate: data['selectedRate'],
                        carDetails: data['carDetails'],
                        models: Models(),
                        documentId: documentId,
                        route: route,
                        selectedType: 'selectedtype',
                        numberContainer: 'numberContainer',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Container'),
                        Text('Date: $formattedDateTime'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LooseCargo extends StatelessWidget {
  final _DeliveredOrderState dataScreen;

  bool isloading = false;

  LooseCargo({super.key, required this.dataScreen});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('myorders')
            .where('loosecargoSelected', isEqualTo: true)
            .where('status', isEqualTo: 'delivered')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Image(
                image: const AssetImage('assets/nothing.gif'),
                height: h * 0.35,
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              final documentId = doc.id;
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDateTime =
                  DateFormat('yyyy-MM-dd     HH:mm').format(timestamp.toDate());
              final List<String> route = (data['route'] as String).split(', ');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CargoDetailsScreen(
                        formattedDateTime: formattedDateTime,
                        selectedDestination: data['selectedDestination'],
                        selectedDestinationPrice:
                            data['selectedDestinationPrice'],
                        selectedRate: data['selectedRate'],
                        carDetails: data['carDetails'],
                        models: Models(),
                        documentId: documentId,
                        route: route,
                        transitType: data["transitType"],
                        payment: data["payment"],
                        doc: doc,
                        username: data['username'], 
                        phone: data['phone'], 
                        
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Loose cargo'),
                        Text('Date: $formattedDateTime'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Abnormal extends StatelessWidget {
  final _DeliveredOrderState dataScreen;

  bool isloading = false;

  Abnormal({super.key, required this.dataScreen});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('myorders')
            .where('abnormalSelected', isEqualTo: true)
            .where('status', isEqualTo: 'delivered')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Image(
                image: const AssetImage('assets/nothing.gif'),
                height: h * 0.35,
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              final documentId = doc.id;
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDateTime =
                  DateFormat('yyyy-MM-dd     HH:mm').format(timestamp.toDate());
              final List<String> route = (data['route'] as String).split(', ');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CargoDetailsScreen(
                        formattedDateTime: formattedDateTime,
                        selectedDestination: data['selectedDestination'],
                        selectedDestinationPrice:
                            data['selectedDestinationPrice'],
                        selectedRate: data['selectedRate'],
                        carDetails: data['carDetails'],
                        models: Models(),
                        documentId: documentId,
                        route: route,
                        transitType: data["transitType"],
                        payment: data["payment"],
                        doc: doc,
                        username: data['username'], 
                        phone: data['phone'], 
                        
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cargo details'),
                        Text('Date: $formattedDateTime'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Fuel extends StatelessWidget {
  final _DeliveredOrderState dataScreen;

  const Fuel({Key? key, required this.dataScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('myorders')
            .where('fuelSelected', isEqualTo: true)
            .where('status', isEqualTo: 'delivered')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Image(
                image: const AssetImage('assets/nothing.gif'),
                height: h * 0.35,
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              final documentId = doc.id;
              final timestamp = data['timestamp'] as Timestamp;
              final formattedDateTime =
                  DateFormat('yyyy-MM-dd     HH:mm').format(timestamp.toDate());
              final List<String> route = (data['route'] as String).split(', ');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CargoDetailsScreen(
                        formattedDateTime: formattedDateTime,
                        selectedDestination: data['selectedDestination'],
                        selectedDestinationPrice:
                            data['selectedDestinationPrice'],
                        selectedRate: data['selectedRate'],
                        carDetails: data['carDetails'],
                        models: Models(),
                        documentId: documentId,
                        route: route,
                        username: data['username'], 
                        phone: data['phone'],
                        transitType: data["transitType"],
                        payment: data["payment"],
                        doc: doc, 
                        
                      
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cargo details'),
                        Text('Date: $formattedDateTime'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
