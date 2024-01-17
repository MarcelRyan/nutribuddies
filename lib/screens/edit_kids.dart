import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutribuddies/models/kids.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/services/general.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../widgets/wrapper.dart';
import 'package:intl/intl.dart';
import 'package:nutribuddies/services/debouncer.dart';

class EditKids extends StatefulWidget {
  Kids kid;

  EditKids({
    super.key,
    required this.kid,
  });

  @override
  State<EditKids> createState() => _EditKidsState();
}

class _EditKidsState extends State<EditKids> {
  final AuthService _auth = AuthService();
  final GeneralService _general = GeneralService();
  final _formkey = GlobalKey<FormState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    String currentHeightUnit = 'cm';
    String currentWeightUnit = 'kg';
    String bornWeightUnit = 'kg';
    final Users? users = Provider.of<Users?>(context);
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(widget.kid.dateOfBirth);

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(alignment: AlignmentDirectional.centerStart, children: [
                    Image.asset('assets/Login/Group2(2).png'),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.05,
                        MediaQuery.of(context).size.height * 0.01,
                        MediaQuery.of(context).size.width * 0,
                        MediaQuery.of(context).size.height * 0,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: black,
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ]),
                  ClipRect(
                    child: Transform.translate(
                      offset: const Offset(0, -0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.08,
                            MediaQuery.of(context).size.height * 0,
                            MediaQuery.of(context).size.width * 0.08,
                            MediaQuery.of(context).size.height * 0.07),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Edit Kid's Profile",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: black,
                                  fontSize: 32,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400),
                            ),
                            Form(
                              key: _formkey,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.68,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      TextFormField(
                                        maxLength: 15,
                                        initialValue: widget.kid.displayName,
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: "Kid's Name"),
                                        validator: (val) => val!.isEmpty
                                            ? "Enter a kid's name"
                                            : null,
                                        onChanged: (val) {
                                          setState(() =>
                                              widget.kid.displayName = val);
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: formattedDate),
                                        decoration:
                                            textInputDecoration.copyWith(
                                          hintText: 'Select Date of Birth',
                                          suffixIcon: GestureDetector(
                                            onTap: () => _general.selectDate(
                                                context, widget.kid.dateOfBirth,
                                                (picked) {
                                              setState(() {
                                                widget.kid.dateOfBirth = picked;
                                              });
                                            }),
                                            child: const Icon(
                                                Icons.calendar_today),
                                          ),
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Select Date of Birth'
                                            : null,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      const Text(
                                        'Gender',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          Radio(
                                            value: 'Boy',
                                            groupValue: widget.kid.gender,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.kid.gender =
                                                    value as String;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Boy',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                          ),
                                          Radio(
                                            value: 'Girl',
                                            groupValue: widget.kid.gender,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.kid.gender =
                                                    value as String;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Girl',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Current height',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              textAlign: TextAlign.center,
                                              controller: TextEditingController(
                                                  text: widget.kid.currentHeight
                                                      .toString()),
                                              onChanged: (value) {
                                                _debouncer.run(() {
                                                  setState(() {
                                                    widget.kid.currentHeight =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;
                                                  });
                                                });
                                              },
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                hintText: 'Height',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                prefixIcon: IconButton(
                                                  icon: Transform.rotate(
                                                    angle: 3.1416,
                                                    child: const Icon(Icons
                                                        .arrow_drop_down_circle_outlined),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid
                                                          .currentHeight += 1.0;
                                                    });
                                                  },
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down_circle_outlined),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid
                                                          .currentHeight -= 1.0;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          DropdownButton<String>(
                                            value: currentHeightUnit,
                                            elevation: 0,
                                            underline: Container(
                                              height: 0,
                                              color: Colors.transparent,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                currentHeightUnit = newValue!;
                                              });
                                            },
                                            items: <String>['cm', 'm']
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Current weight',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              textAlign: TextAlign.center,
                                              controller: TextEditingController(
                                                  text: widget.kid.currentWeight
                                                      .toString()),
                                              onChanged: (value) {
                                                _debouncer.run(() {
                                                  setState(() {
                                                    widget.kid.currentWeight =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;
                                                  });
                                                });
                                              },
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                hintText: 'Weight',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                prefixIcon: IconButton(
                                                  icon: Transform.rotate(
                                                    angle: 3.1416,
                                                    child: const Icon(Icons
                                                        .arrow_drop_down_circle_outlined),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid
                                                          .currentWeight += 1.0;
                                                    });
                                                  },
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down_circle_outlined),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid
                                                          .currentWeight -= 1.0;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          DropdownButton<String>(
                                            value: currentWeightUnit,
                                            elevation: 0,
                                            underline: Container(
                                              height: 0,
                                              color: Colors.transparent,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                currentWeightUnit = newValue!;
                                              });
                                            },
                                            items: <String>['lb', 'oz', 'kg']
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Born weight',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              textAlign: TextAlign.center,
                                              controller: TextEditingController(
                                                  text: widget.kid.bornWeight
                                                      .toString()),
                                              onChanged: (value) {
                                                _debouncer.run(() {
                                                  setState(() {
                                                    widget.kid.bornWeight =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;
                                                  });
                                                });
                                              },
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                hintText: 'Weight',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                prefixIcon: IconButton(
                                                  icon: Transform.rotate(
                                                    angle: 3.1416,
                                                    child: const Icon(Icons
                                                        .arrow_drop_down_circle_outlined),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid.bornWeight +=
                                                          1.0;
                                                    });
                                                  },
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down_circle_outlined),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.kid.bornWeight -=
                                                          1.0;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          DropdownButton<String>(
                                            value: bornWeightUnit,
                                            elevation: 0,
                                            underline: Container(
                                              height: 0,
                                              color: Colors.transparent,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                bornWeightUnit = newValue!;
                                              });
                                            },
                                            items: <String>['lb', 'oz', 'kg']
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            if (currentHeightUnit == 'm') {
                                              widget.kid.currentHeight *= 100;
                                            }
                                            if (currentWeightUnit == 'oz') {
                                              widget.kid.currentWeight *=
                                                  0.0283495;
                                            }
                                            if (bornWeightUnit == 'oz') {
                                              widget.kid.bornWeight *=
                                                  0.0283495;
                                            }
                                            if (currentWeightUnit == 'lb') {
                                              widget.kid.currentWeight *=
                                                  0.453592;
                                            }
                                            if (bornWeightUnit == 'lb') {
                                              widget.kid.bornWeight *= 0.453592;
                                            }
                                            setState(() => loading = true);
                                            dynamic result = await DatabaseService(
                                                    uid: users!.uid)
                                                .updateKidData(
                                                    kidsUid: widget.kid.uid,
                                                    displayName: widget
                                                            .kid.displayName ??
                                                        '',
                                                    dateOfBirth:
                                                        widget.kid.dateOfBirth,
                                                    gender: widget.kid.gender,
                                                    currentHeight: widget
                                                        .kid.currentHeight,
                                                    currentWeight: widget
                                                        .kid.currentWeight,
                                                    bornWeight:
                                                        widget.kid.bornWeight,
                                                    profilePictureUrl: widget
                                                        .kid.profilePictureUrl);
                                            if (result == false) {
                                              setState(() => loading = false);
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Wrapper(
                                                            result: true,
                                                            goToHome: true,
                                                            goToProfile: true,
                                                          )));
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          minimumSize: Size(
                                              double.infinity,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06),
                                          backgroundColor: primary,
                                          foregroundColor: onPrimary,
                                        ),
                                        child: const Text(
                                          'Save',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
