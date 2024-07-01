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
  List _allResults = [];
  List _resultsList = [];
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    readGuru();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var _showResults = [];
    if (_searchController.text != "") {
      for (var guru in _allResults) {
        var nama = guru['nama'].toLowerCase();
        var nip = guru['nip'].toLowerCase();
        if (nama.contains(_searchController.text.toLowerCase()) ||
            nip.contains(_searchController.text.toLowerCase())) {
          _showResults.add(guru);
        }
      }
    } else {
      _showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = _showResults;
    });
  }

  readGuru() async {
    var _data = await FirebaseFirestore.instance
        .collection('guru')
        .orderBy('nama')
        .get();

    setState(() {
      _allResults = _data.docs;
    });
    searchResultsList();
    return "complete";
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
                child: ListView.builder(
                  itemCount: _resultsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        _resultsList[index]['nama'],
                      ),
                      subtitle: Text("NIP. " + _resultsList[index]['nip']),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdminDetailGuruPage(
                                nip: _resultsList[index]['nip'])));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
