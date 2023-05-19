import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Utilities/Branch_List.dart';
import '../Utilities/College.dart';
import '../Utilities/constants.dart';
import 'package:http/http.dart' as http;

class CET extends StatefulWidget {
  const CET({super.key});

  @override
  State<CET> createState() => _CETState();
}

class _CETState extends State<CET> {
  // Variables
  bool errorrank = false, errorper = false;
  String? currRound = '',
      college = '',
      branch = '',
      currgender = 'Male',
      currcat = 'OPEN',
      currState = 'Home_State',
      g,
      st,
      r;
  String city = " ";
  int? rank;
  double? percentile;
  List<String> round = ['1st Round', '2nd Round', '3rd Round'],
      castList = [
        "OPEN",
        "SC",
        "ST",
        "VJ",
        "NT1",
        "NT2",
        "NT3",
        "OBC",
      ],
      genderList = ["Male", "Female"],
      stateList = ["Home_State", "Other_State", "Home_University"];
  List fetchedData = [];
  var data = [];
  List mhtcetData = [];

  //Function
  Future<void> fetchData() async {
    if (college == "Clear Selection") {
      college = " ";
    }
    if (branch == "Clear Selection") {
      branch = " ";
    }
    if (city.isNotEmpty) {
      city = city[0].toUpperCase() + city.substring(1);
    }
    if (currgender == "Male") {
      g = "G";
    } else {
      g = "L";
    }
    if (currState == 'Other_State') {
      st = "O";
    } else if (currState == 'Home_State') {
      st = "S";
    } else {
      st = "H";
    }
    if (currRound == '1st Round') {
      r = '1';
    } else if (currRound == '2st Round') {
      r = '2';
    } else {
      r = '3';
    }
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    String uri =
        'http://backend-mqqg.onrender.com/Huni/Info?Percentage_$g$currcat$st[lte]=$percentile&Rank_$g$currcat$st[gte]=$rank&Category=$g$currcat$st&Round=$r';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      setState(() {
        mhtcetData = jsonDecode(response.body);
        data = mhtcetData;
      });
      if (college != " " && college != null) {
        data = data
            .map((e) {
              if (e['College_Name'].contains(college)) {
                return e;
              } else {
                return null;
              }
            })
            .where((element) => element != null)
            .toList();
      }

      if (branch != " " && branch != null) {
        data = data
            .map((e) {
              if (e['Course'].contains(branch)) {
                return e;
              } else {
                return null;
              }
            })
            .where((element) => element != null)
            .toList();
      }

      if (city != " " && city.isNotEmpty) {
        data = data
            .map((e) {
              if (e['City'] != null) {
                if (e['City'].contains(city)) {
                  return e;
                } else {
                  return null;
                }
              }
            })
            .where((element) => element != null)
            .toList();
      }

      if (data.length > 20) {
        data.removeRange(20, data.length);
      }
    }
    Navigator.of(context).pop();
    if (r == ' ' ||
        (rank == null || rank == '') ||
        (percentile == null || percentile == '')) {
      Fluttertoast.showToast(
          msg: "Enter Details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.blue,
          fontSize: 16.0);
    } else {
      if (data.isEmpty) {
        Fluttertoast.showToast(
            msg: "For the given filters data not matched",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Data fetched",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            fontSize: 16.0);
      }
    }
  }

  Widget _buildPercentileTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        SizedBox(
          width: (MediaQuery.of(context).size.width) * (0.435),
          child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red, width: 2)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red, width: 2)),
                errorText: errorper ? 'Enter complete percentile' : null,
                // contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
                hintText: 'percentile',
                hintStyle: kHintTextStyle,
              ),
              onChanged: ((value) => setState(() {
                    if ((double.parse(value) > 0 &&
                            double.parse(value) < 100 &&
                            value.length == 9) ||
                        value.isEmpty) {
                      errorper = false;
                      percentile = double.parse(value);
                    } else {
                      errorper = true;
                    }
                  }))),
        ),
      ],
    );
  }

  Widget _buildRankTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        SizedBox(
          width: (MediaQuery.of(context).size.width) * (0.435),
          child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red, width: 2)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red, width: 2)),
                errorText: errorrank ? 'Enter correct rank' : null,
                // contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
                hintText: 'rank',
                hintStyle: kHintTextStyle,
              ),
              onChanged: ((value) => setState(() {
                    if ((int.parse(value) > 0 && int.parse(value) < 300000) ||
                        value.isEmpty) {
                      rank = int.parse(value);
                      errorrank = false;
                    } else {
                      errorrank = true;
                    }
                  }))),
        ),
      ],
    );
  }

  Widget _buildGenderList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width) * (0.435),
            decoration: BoxDecoration(
                color: const Color(0xFF6CA8F1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white, width: 2)),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Select gender",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
              ),
              items: genderList,
              selectedItem: genderList[0],
              onChanged: (value) {
                currgender = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  Widget _buildCategoryList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width) * (0.435),
            decoration: BoxDecoration(
                color: const Color(0xFF6CA8F1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white, width: 2)),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Select Category",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
              ),
              items: castList,
              selectedItem: castList[0],
              onChanged: (value) {
                currcat = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  Widget _buildStateList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width) * (0.435),
            decoration: BoxDecoration(
                color: const Color(0xFF6CA8F1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white, width: 2)),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Select State",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
              ),
              items: stateList,
              selectedItem: stateList[0],
              onChanged: (value) {
                currState = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  Widget _buildRoundList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width) * (0.435),
            decoration: BoxDecoration(
                color: const Color(0xFF6CA8F1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white, width: 2)),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Select Round",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
              ),
              items: round,
              selectedItem: round[0],
              onChanged: (value) {
                currRound = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  Widget _buildCityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        SizedBox(
          width: (MediaQuery.of(context).size.width),
          child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2)),
                // contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
                hintText: 'city',
                hintStyle: kHintTextStyle,
              ),
              onChanged: ((value) => setState(() {
                    city = value;
                  }))),
        ),
      ],
    );
  }

  Widget _buildCollegeList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Search for college",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                isFilterOnline: true,
              ),
              items: College_Data,
              selectedItem: null,
              filterFn: (item, filter) =>
                  item.toLowerCase().contains(filter.toLowerCase()),
              onChanged: (value) {
                college = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  Widget _buildBranchList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7, bottom: 7),
                  child: Text(
                    selectedItem ?? "Search Branch",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                isFilterOnline: true,
              ),
              items: Branch_Data,
              selectedItem: null,
              filterFn: (item, filter) =>
                  item.toLowerCase().contains(filter.toLowerCase()),
              onChanged: (value) {
                branch = value;
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ]);
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  Widget _buildFilterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: getColor(Colors.white, Colors.teal),
        ),
        onPressed: () => {
          if (percentile != null && rank != null)
            {fetchData()}
          else
            {
              Fluttertoast.showToast(
                  msg: "Enter Details",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.blue,
                  fontSize: 16.0)
            }
        },
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Search',
            style: TextStyle(
              color: Colors.blue,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                )),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildPercentileTF(),
                          const SizedBox(width: 20),
                          _buildRankTF()
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildGenderList(),
                          const SizedBox(width: 20),
                          _buildCategoryList()
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildStateList(),
                          const SizedBox(width: 20.0),
                          _buildRoundList(),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      _buildCityTF(),
                      const SizedBox(height: 20),
                      _buildCollegeList(),
                      const SizedBox(height: 20),
                      _buildBranchList(),
                      _buildFilterBtn(),
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final entry = data[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: kBoxDecorationStyle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text(
                                          '${entry['College_Name']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 5),
                                            Text(
                                              '${entry['Course']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Rank:- ${entry['Rank_$g$currcat$st']}'
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '% :- ${entry['Percentage_$g$currcat$st']}'
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
