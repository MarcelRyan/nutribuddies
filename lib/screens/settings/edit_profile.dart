import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/general.dart';
import 'package:nutribuddies/widgets/wrapper.dart';
import 'package:nutribuddies/widgets/loading.dart';

class EditProfile extends StatefulWidget {
  final Users user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  final GeneralService _general = GeneralService();
  bool loading = false;
  PlatformFile? pickedFile;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.displayName ?? '';
    _emailController.text = widget.user.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: background,
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.1,
                      MediaQuery.of(context).size.height * 0.02,
                      MediaQuery.of(context).size.width * 0.1,
                      0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.06,
                        backgroundImage: pickedFile != null
                            ? FileImage(File(pickedFile!.path!))
                                as ImageProvider<Object>
                            : NetworkImage(widget.user.profilePictureUrl ?? ''),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Profile Picture",
                            style: TextStyle(
                                color: primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                              onPressed: () async {
                                PlatformFile result =
                                    await _general.selectFIle();
                                setState(() {
                                  pickedFile = result;
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: primary,
                              )),
                        ],
                      ),
                      buildEditableField('Username', _usernameController),
                      buildEditableField('Email', _emailController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            onPressed: () async {
                              // ntr ganti
                              String displayName = _usernameController.text;
                              String email = _emailController.text;
                              String profilePictureUrl =
                                  widget.user.profilePictureUrl!;

                              if (pickedFile != null) {
                                String newPhotoUrl =
                                    await DatabaseService(uid: widget.user.uid)
                                        .uploadFile(pickedFile);
                                profilePictureUrl = newPhotoUrl;
                              }

                              dynamic result =
                                  await DatabaseService(uid: widget.user.uid)
                                      .updateUserData(
                                          uid: widget.user.uid,
                                          displayName: displayName,
                                          email: email,
                                          profilePictureUrl: profilePictureUrl,
                                          topicInterest:
                                              widget.user.topicsInterest);
                              if (result == false) {
                                setState(() => loading = false);
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper(
                                              result: true,
                                              goToHome: true,
                                              goToProfile: true,
                                            )));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(double.infinity,
                                  MediaQuery.of(context).size.height * 0.055),
                              backgroundColor: primary,
                              foregroundColor: onPrimary,
                              side: const BorderSide(color: outline, width: 1),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          label,
          style: const TextStyle(
            color: outline,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}
