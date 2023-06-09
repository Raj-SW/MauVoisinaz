// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, override_on_non_overriding_member, file_names, non_constant_identifier_names, annotate_overrides, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mauvoisinaz/UI/AuthenticationPages/WelcomePage.dart';
import '../../Services/Authentication/UserAuthentication.dart';
import '../../Services/DBConnection/UserDetails.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var list;
  @override
  void initState() {
    super.initState();
    setStateList();
    setState(() {});
  }

  @override
  UserAuthentication UserAuth = UserAuthentication();
  UserDetails userDetails = UserDetails();
  int counter = 0;

  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],
        body: SafeArea(
          child: Column(
            children: [
              Text('Your Contacts'),
              StreamBuilder(
                  stream: list,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> document =
                            snapshot.data.docs[index].data()
                                as Map<String, dynamic>;
                        return ListTile(
                          title: Text(document['Name']),
                          subtitle: Text(document['Number']),
                          leading: Icon(Icons.person),
                          trailing: IconButton(
                              onPressed: () {
                                userDetails.removeFriends(document['Name']);
                              },
                              icon: Icon(Icons.delete)),
                        );
                      },
                    );
                  }),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController nameController =
                            TextEditingController();
                        TextEditingController phoneController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Add Contacts'),
                          content: Column(children: [
                            // Text field for name
                            Text('Name'),
                            TextField(
                              controller: nameController,
                            ),
                            // Text field for phone
                            Text('Phone Number'),
                            TextField(
                              controller: phoneController,
                            ),
                            //Submit Button
                            ElevatedButton(
                                onPressed: () {
                                  userDetails.addFriends(nameController.text,
                                      phoneController.text);
                                  Navigator.pop(context);
                                },
                                child: Text('Submit'))
                          ]),
                        );
                      });
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text('Add Contacts'), Icon(Icons.plus_one)],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (await UserAuth.signOut()) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Welcome()),
                          (route) => false);
                    }
                  },
                  child: Text('Log out'))
            ],
          ),
        ));
  }

  Future<void> setStateList() async {
    list = userDetails.getFriends();
    setState(() {});
  }
}
