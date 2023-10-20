// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentItemCounter {

  Map<String, int> itemCounts = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };

Map<String, int> itemCounts2 = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };

Map<String, int> itemCounts3 = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };




Future<void> updateItemCounts() async {
  final snapshot = await FirebaseFirestore.instance
      .collectionGroup('myorders')
      .get();

  final classCounts = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };

  for (var doc in snapshot.docs) {
  var data = doc.data();
  
  if (data['containerSelected'] == true && data['status'] == 'pending') {
    classCounts['Container'] = (classCounts['Container'] ?? 0) + 1;
  } else if (data['loosecargoSelected'] == true && data['status'] == 'pending') {
    classCounts['Loose cargo'] = (classCounts['Loose cargo'] ?? 0) + 1;
  } else if (data['abnormalSelected'] == true && data['status'] == 'pending') {
    classCounts['Abnormal'] = (classCounts['Abnormal'] ?? 0) + 1;
  } else if (data['fuelSelected'] == true && data['status'] == 'pending') {
    classCounts['Fuel'] = (classCounts['Fuel'] ?? 0) + 1;
  }
}


  itemCounts = classCounts.map((key, value) => MapEntry(key, value));
}

Future<void> updateItemCounts2() async {
  final snapshot = await FirebaseFirestore.instance
      .collectionGroup('myorders')
      .get();

  final classCounts = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };

  for (var doc in snapshot.docs) {
  var data = doc.data();
  
  if (data['containerSelected'] == true && data['status'] == 'progressing') {
    classCounts['Container'] = (classCounts['Container'] ?? 0) + 1;
  } else if (data['loosecargoSelected'] == true && data['status'] == 'progressing') {
    classCounts['Loose cargo'] = (classCounts['Loose cargo'] ?? 0) + 1;
  } else if (data['abnormalSelected'] == true && data['status'] == 'progressing') {
    classCounts['Abnormal'] = (classCounts['Abnormal'] ?? 0) + 1;
  } else if (data['fuelSelected'] == true && data['status'] == 'progressing') {
    classCounts['Fuel'] = (classCounts['Fuel'] ?? 0) + 1;
  }
}


  itemCounts2 = classCounts.map((key, value) => MapEntry(key, value));
}

Future<void> updateItemCounts3() async {
  final snapshot = await FirebaseFirestore.instance
      .collectionGroup('myorders')
      .get();

  final classCounts = {
    'Container': 0,
    'Loose cargo': 0,
    'Abnormal': 0,
    'Fuel': 0,
  };

  for (var doc in snapshot.docs) {
  var data = doc.data();
  
  if (data['containerSelected'] == true && data['status'] == 'delivered') {
    classCounts['Container'] = (classCounts['Container'] ?? 0) + 1;
  } else if (data['loosecargoSelected'] == true && data['status'] == 'delivered') {
    classCounts['Loose cargo'] = (classCounts['Loose cargo'] ?? 0) + 1;
  } else if (data['abnormalSelected'] == true && data['status'] == 'delivered') {
    classCounts['Abnormal'] = (classCounts['Abnormal'] ?? 0) + 1;
  } else if (data['fuelSelected'] == true && data['status'] == 'delivered') {
    classCounts['Fuel'] = (classCounts['Fuel'] ?? 0) + 1;
  }
}


  itemCounts3 = classCounts.map((key, value) => MapEntry(key, value));
}

}
