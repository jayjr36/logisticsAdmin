import 'package:bcladmin/delivered.dart';
import 'package:bcladmin/inprogress.dart';
import 'package:bcladmin/models/counter.dart';
import 'package:bcladmin/pending.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required Map itemCounts,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final shipmentItemCounter = ShipmentItemCounter();
  final shipmentItemCounter2 = ShipmentItemCounter();
  final shipmentItemCounter3 = ShipmentItemCounter();
  @override
  void initState() {
    super.initState();
    shipmentItemCounter.updateItemCounts();
    shipmentItemCounter2.updateItemCounts2();
    shipmentItemCounter3.updateItemCounts3();
  }
   
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(onPressed: () {}, icon: Icon(Icons.person)),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: h * 0.18,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 4, 28, 104),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(h * 0.1),
              bottomRight: Radius.circular(h * 0.1),
            ),
          ),
          child: const Center(
            child: Image(image: AssetImage('assets/bcl.png')),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            
              sectionWithTitle(title: "PENDING ORDERS", counter: shipmentItemCounter, onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: ((context) => const FirestoreDataScreen())));
               }, ),
              SizedBox(height: h * 0.02),
              sectionWithTitle(title: "PROGRESSING ORDERS", counter: shipmentItemCounter2, onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: ((context) => const ProgressingOrders())));
               }),
              SizedBox(height: h * 0.02),
              sectionWithTitle(title: "COMPLETE ORDERS", counter: shipmentItemCounter3, onPressed: () {  
                Navigator.push(context, MaterialPageRoute(builder: ((context) => const DeliveredOrder())));
              }),
            ],
          ),
        ),
      ),
    );
  }

   Widget sectionWithTitle({required String title, required ShipmentItemCounter counter, required VoidCallback onPressed }) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: counter.itemCounts.length,
          itemBuilder: (context, index) {
            final itemName = counter.itemCounts.keys.elementAt(index);
            final itemCount = counter.itemCounts[itemName];

            return Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                border: Border.all(
                  color: const Color.fromARGB(255, 4, 28, 104),
                  width: 10,
                ),
                borderRadius: BorderRadius.all(Radius.circular(h * 0.05)),
              ),
              child: ListTile(
                title: Text(itemName, style:const TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text('Total: $itemCount'),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: w * 0.1,
            mainAxisSpacing: h * 0.01,
            mainAxisExtent: h * 0.1,
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("CHECK OUT ORDERS"),
        ),
      ],
    );
  }
}