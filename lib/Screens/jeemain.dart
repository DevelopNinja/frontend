import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Utilities/Branch_List.dart';
import '../Utilities/College.dart';
import '../Utilities/constants.dart';
import 'package:http/http.dart' as http;

class JeeMains extends StatefulWidget {
  const JeeMains({super.key});

  @override
  State<JeeMains> createState() => _JeeMainsState();
}

class _JeeMainsState extends State<JeeMains> {
  // Variables
  bool errorrank = false, errorper = false;
  String? currRound = '', college = '', branch = '', r;
  String city = " ";
  int? rank;
  double? percentile;
  List<String> round = ['1st Round', '2nd Round', '3rd Round'];
  List fetchedData = [];
  var data = [];
  //Function
  Future<void> fetchData() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    if (college == "Clear Selection") {
      college = '';
    }
    if (branch == "Clear Selection") {
      branch = '';
    }
    if (currRound == '1st Round') {
      r = '1';
    } else if (currRound == '2st Round') {
      r = '2';
    } else {
      r = '3';
    }
    if (city.isNotEmpty) {
      city = city[0].toUpperCase() + city.substring(1);
    }

    String uri =
        'http://backend-mqqg.onrender.com/AI/Info?Rank[gte]=$rank&Score[lte]=$percentile&Round=$r';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      setState(() {
        fetchedData = jsonDecode(response.body);
        data = fetchedData;
      });

      if (college != " " && college != null) {
        data = data
            .map((e) {
              if (e['Institute'].contains(college)) {
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
              if (e['Course Name'].contains(branch)) {
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
                      percentile = double.parse(value);
                      errorper = false;
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
                    if ((int.parse(value) > 0 && int.parse(value) < 300000)) {
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

  Widget _buildCityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: (MediaQuery.of(context).size.width) * (0.435),
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
                hintText: 'Enter City',
                hintStyle: kHintTextStyle,
              ),
              onChanged: ((value) => setState(() {
                    city = value;
                  }))),
        ),
      ],
    );
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
        onPressed: () => {fetchData()},
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
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildPercentileTF(),
                          const SizedBox(width: 20.0),
                          _buildRankTF()
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildCityTF(),
                          const SizedBox(width: 20.0),
                          _buildRoundList(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildCollegeList(),
                      const SizedBox(height: 20),
                      _buildBranchList(),
                      const SizedBox(height: 20),
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
                                          '${entry['Institute']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 10),
                                            Text(
                                              '${entry['Course Name']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rank: ${entry['Rank']}'
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  '% : ${entry['Score']}'
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
