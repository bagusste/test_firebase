import 'package:flutter/material.dart';
import 'package:test_firebase/admin_detail_guru.dart';
import 'admin_add_guru.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminGuruPage extends StatefulWidget {
  const AdminGuruPage({super.key});

  @override
  State<AdminGuruPage> createState() => _AdminGuruPageState();
}

class _AdminGuruPageState extends State<AdminGuruPage> {
  TextEditingController _searchController = TextEditingController();
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    print(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Data Guru'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AdminAddGuruPage();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Cari",
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: db.collection("guru").snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 8,
                        ));
                      }
                      var data = snapshots.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              data[index]['nama'],
                            ),
                            subtitle: Text("NIP. " + data[index]['nip']),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminDetailGuruPage(
                                      nip: data[index]['nip'])));
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
