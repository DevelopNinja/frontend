import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/Utilities/Branch_List.dart';
import 'package:frontend/Utilities/College.dart';
import 'package:frontend/Utilities/constants.dart';
import 'package:http/http.dart' as http;

class MHTCET extends StatefulWidget {
  const MHTCET({super.key});

  @override
  State<MHTCET> createState() => _MHTCETState();
}

class _MHTCETState extends State<MHTCET> {
  // All variables
  String? mark,
      rank = '',
      gender = " ",
      cast = " ",
      uni = " ",
      branch = " ",
      st,
      college = " ",
      r = ' ';
  String g = " ", city = " ";
  List MHTCET_Data = [];
  var Data = [], Data1 = [];
  List<String> round = ['1', '2', '3', ' '];
  // List of items in our dropdown menu
  var Cast_list = [
    " ",
    "OPEN",
    "SC",
    "ST",
    "VJ",
    "NT1",
    "NT2",
    "NT3",
    "OBC",
    // "DEFOPENS",
    // "TFWS",
    // "DEFROBCS",
    // "EWS",
  ];
  var Gender_list = ["General", "Female", " "];
  List<String> State_list =
      ["Home_State", "Other_State", "Home_University", " "].toList();

  void fetchData() async {
    if (city.isNotEmpty) {
      city = city[0].toUpperCase() + city.substring(1);
    }
    if (gender == "General") {
      g = "G";
    } else {
      g = "L";
    }
    if (uni == 'Other_State') {
      st = "O";
    } else if (uni == 'Home_State') {
      st = "S";
    } else {
      st = "H";
    }
    String uri =
        'http://college-recommendation.onrender.com/Huni/Info?Percentage_$g$cast$st[lte]=$mark&Rank_$g$cast$st[gte]=$rank&Category=$g$cast$st&Round=$r';
    if (rank == null || rank == '') {
      uri =
          'http://college-recommendation.onrender.com/Huni/Info?Percentage_$g$cast$st[lte]=$mark&Rank_$g$cast$st[gte]=&Category=$g$cast$st';
    } else if (mark == null || mark == '') {
      uri =
          'http://college-recommendation.onrender.com/Huni/Info?Percentage_$g$cast$st[lte]=&Rank_$g$cast$st[gte]=$rank&Category=$g$cast$st';
    }
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      setState(() {
        MHTCET_Data = jsonDecode(response.body);
        Data = MHTCET_Data;
        print(Data[0]['Round']);
      });

      if (college != " " && college != null) {
        Data = Data.map((e) {
          if (e['College_Name'].contains(college)) {
            return e;
          } else {
            return null;
          }
        }).where((element) => element != null).toList();
      }

      if (branch != " " && branch != null) {
        Data = Data.map((e) {
          if (e['Course'].contains(branch)) {
            return e;
          } else {
            return null;
          }
        }).where((element) => element != null).toList();
      }

      if (city != " " && city.isNotEmpty) {
        Data = Data.map((e) {
          if (e['City'] != null) {
            if (e['City'].contains(city)) {
              return e;
            } else {
              return null;
            }
          }
        }).where((element) => element != null).toList();
      }

      if (Data.length > 20) {
        Data.removeRange(20, Data.length);
      }
    }

    if (((rank == null || rank == '') && (mark == null || mark == '')) ||
        cast == " " ||
        gender == " " ||
        (st == null || st == '')) {
      Fluttertoast.showToast(
          msg: "Enter Details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.blue,
          fontSize: 16.0);
    } else {
      if (Data.isEmpty) {
        Fluttertoast.showToast(
            msg: "Details not exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Data Fetched",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            fontSize: 16.0);
      }
    }
  }

  Widget _buildMarksTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Marks',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width) / 3,
          child: TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'Marks',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => mark = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Round",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) / 3,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding:
                const EdgeInsetsDirectional.only(start: 20, top: 5, bottom: 5),
            child: DropdownButton(
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF6CA8F1),
              value: r,
              items: round.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 5),
                    child: Text(e),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  r = value.toString();
                });
              },
              isExpanded: true,
              iconSize: 36,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
        ]);
  }

  Widget _buildCityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'City',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width),
          child: TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'City',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => city = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRankTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Rank',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width) / 3,
          child: TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'Rank',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => rank = value,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Gender",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) / 3,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: DropdownButton(
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF6CA8F1),
              value: gender,
              items: Gender_list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  gender = value;
                });
              },
              isExpanded: true,
              iconSize: 36,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
        ]);
  }

  Widget _buildCategoryList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Category",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) / 3,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: DropdownButton(
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF6CA8F1),
              value: cast,
              items: Cast_list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  cast = value;
                });
              },
              isExpanded: true,
              iconSize: 36,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
        ]);
  }

  Widget _buildStateList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "State",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) / 3,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: DropdownButton(
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF6CA8F1),
              value: uni,
              items: State_list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  uni = value;
                });
              },
              isExpanded: true,
              iconSize: 36,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
        ]);
  }

  Widget _buildCollegeList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "College",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
                child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              },
              popupProps: PopupProps.menu(
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
                print(college);
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            )),
          ),
        ]);
  }

  Widget _buildBranchList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Branch",
            style: kLabelStyle,
          ),
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
                child: DropdownSearch<String>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              },
              popupProps: PopupProps.menu(
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
                print(branch);
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none),
              ),
            )),
          ),
        ]);
  }

  Widget _buildFilterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          fetchData();
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Filter',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
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
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'MHTCET Cutoff',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildMarksTF(),
                          const SizedBox(width: 30.0),
                          _buildRankTF()
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildGenderList(),
                          const SizedBox(width: 30),
                          _buildCategoryList()
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildStateList(),
                          const SizedBox(width: 30.0),
                          _buildRoundList(),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      _buildCityTF(),
                      const SizedBox(height: 20),
                      _buildCollegeList(),
                      const SizedBox(height: 20),
                      _buildBranchList(),
                      const SizedBox(height: 10),
                      _buildFilterBtn(),
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: Data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final entry = Data[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: kBoxDecorationStyle,
                                        child: ListTile(
                                          title: Text(
                                            'College:- ${entry['College_Name']}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(height: 10),
                                              Text(
                                                'Branch:- ${entry['Course']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                'Rank_$cast:- ${entry['Rank_$g$cast$st']}'
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                'Percentile_$cast:- ${entry['Percentage_$g$cast$st']}'
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }))),
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
