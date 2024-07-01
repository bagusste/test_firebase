import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddGuruPage extends StatefulWidget {
  const AdminAddGuruPage({super.key});

  @override
  State<AdminAddGuruPage> createState() => _AdminAddGuruPageState();
}

class _AdminAddGuruPageState extends State<AdminAddGuruPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nipController = TextEditingController();
  var db = FirebaseFirestore.instance;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Guru'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Guru',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Guru';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nipController,
                decoration: InputDecoration(
                  labelText: 'NIP',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan NIP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih Jenis Kelamin';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedGender,
                items: ['Wanita', 'Pria'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 8,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            // Handle saving data logic here
                            final guru = <String, dynamic>{
                              "nama": _nameController.text,
                              "nip": _nipController.text,
                              "gender": _selectedGender,
                              "password": "password",
                            };
                            db
                                .collection("guru")
                                .doc(_nipController.text)
                                .set(guru);
                          }
                          _isLoading = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Data Guru Berhasil Ditambahkan'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        });
                      },
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color

                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
