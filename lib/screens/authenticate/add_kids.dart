import 'package:flutter/material.dart';
import 'package:nutribuddies/services/auth.dart';
import 'package:nutribuddies/constant/text_input_decoration.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/services/general.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../widgets/wrapper.dart';
import 'package:intl/intl.dart';
import 'package:nutribuddies/services/debouncer.dart';

class AddKids extends StatefulWidget {
  const AddKids({super.key});

  @override
  State<AddKids> createState() => _AddKidsState();
}

class _AddKidsState extends State<AddKids> {
  final AuthService _auth = AuthService();
  final GeneralService _general = GeneralService();
  final _formkey = GlobalKey<FormState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  bool loading = false;

  String kidName = '';
  DateTime dateOfBirth = DateTime.now();
  String gender = '';
  String currentHeightUnit = 'cm';
  double currentHeight = 0.0;
  String currentWeightUnit = 'kg';
  double currentWeight = 0.0;
  String bornWeightUnit = 'kg';
  double bornWeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final Users? users = Provider.of<Users?>(context);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateOfBirth);

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            body: Column(
              children: [
                Image.asset('assets/Login/Group2(2).png'),
                ClipRect(
                  child: Transform.translate(
                    offset: const Offset(0, -0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 52),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add Kid's Profile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: black,
                                fontSize: 32,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                          Form(
                            key: _formkey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        hintText: "Kid's Name"),
                                    validator: (val) => val!.isEmpty
                                        ? "Enter a kid's name"
                                        : null,
                                    onChanged: (val) {
                                      setState(() => kidName = val);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: formattedDate),
                                    decoration: textInputDecoration.copyWith(
                                      hintText: 'Select Date of Birth',
                                      suffixIcon: GestureDetector(
                                        onTap: () => _general.selectDate(
                                            context, dateOfBirth, (picked) {
                                          setState(() {
                                            dateOfBirth = picked;
                                          });
                                        }),
                                        child: const Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    validator: (val) => val!.isEmpty
                                        ? 'Select Date of Birth'
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Gender',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Radio(
                                        value: 'Boy',
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value as String;
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
                                      const SizedBox(
                                        width: 80,
                                      ),
                                      Radio(
                                        value: 'Girl',
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value as String;
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
                                      const SizedBox(width: 13),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          textAlign: TextAlign.center,
                                          controller: TextEditingController(
                                              text: currentHeight.toString()),
                                          onChanged: (value) {
                                            _debouncer.run(() {
                                              setState(() {
                                                currentHeight =
                                                    double.tryParse(value) ??
                                                        0.0;
                                              });
                                            });
                                          },
                                          decoration:
                                              textInputDecoration.copyWith(
                                            hintText: 'Height',
                                            prefixIcon: IconButton(
                                              icon: Transform.rotate(
                                                angle: 3.1416,
                                                child: const Icon(Icons
                                                    .arrow_drop_down_circle_outlined),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  currentHeight += 1.0;
                                                });
                                              },
                                            ),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_circle_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  currentHeight -= 1.0;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
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
                                  const SizedBox(
                                    height: 15,
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
                                      const SizedBox(
                                          width:
                                              10), // Add spacing between the text and the TextFormField
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          textAlign: TextAlign.center,
                                          controller: TextEditingController(
                                              text: currentWeight.toString()),
                                          onChanged: (value) {
                                            _debouncer.run(() {
                                              setState(() {
                                                currentWeight =
                                                    double.tryParse(value) ??
                                                        0.0;
                                              });
                                            });
                                          },
                                          decoration:
                                              textInputDecoration.copyWith(
                                            hintText: 'Weight',
                                            prefixIcon: IconButton(
                                              icon: Transform.rotate(
                                                angle: 3.1416,
                                                child: const Icon(Icons
                                                    .arrow_drop_down_circle_outlined),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  currentWeight += 1.0;
                                                });
                                              },
                                            ),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_circle_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  currentWeight -= 1.0;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
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
                                  const SizedBox(
                                    height: 15,
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
                                      const SizedBox(
                                          width:
                                              30), // Add spacing between the text and the TextFormField
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          textAlign: TextAlign.center,
                                          controller: TextEditingController(
                                              text: bornWeight.toString()),
                                          onChanged: (value) {
                                            _debouncer.run(() {
                                              setState(() {
                                                bornWeight =
                                                    double.tryParse(value) ??
                                                        0.0;
                                              });
                                            });
                                          },
                                          decoration:
                                              textInputDecoration.copyWith(
                                            hintText: 'Weight',
                                            prefixIcon: IconButton(
                                              icon: Transform.rotate(
                                                angle: 3.1416,
                                                child: const Icon(Icons
                                                    .arrow_drop_down_circle_outlined),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  bornWeight += 1.0;
                                                });
                                              },
                                            ),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_circle_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  bornWeight -= 1.0;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
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
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        if (currentHeightUnit == 'm') {
                                          currentHeight *= 100;
                                        }
                                        if (currentWeightUnit == 'oz') {
                                          currentWeight *= 0.0283495;
                                        }
                                        if (bornWeightUnit == 'oz') {
                                          bornWeight *= 0.0283495;
                                        }
                                        if (currentWeightUnit == 'lb') {
                                          currentWeight *= 0.453592;
                                        }
                                        if (bornWeightUnit == 'lb') {
                                          bornWeight *= 0.453592;
                                        }
                                        setState(() => loading = true);
                                        dynamic result =
                                            await _auth.registerKid(
                                                users!.uid,
                                                kidName,
                                                dateOfBirth,
                                                gender,
                                                currentHeight,
                                                currentWeight,
                                                bornWeight);
                                        if (result == false) {
                                          setState(() => loading = false);
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Wrapper(
                                                      result: true,
                                                      goToHome: true,
                                                    )),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 48),
                                      backgroundColor: primary,
                                      foregroundColor: onPrimary,
                                    ),
                                    child: const Text(
                                      'Save',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
