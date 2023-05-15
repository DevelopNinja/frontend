import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/Utilities/Branch_List.dart';
import 'package:frontend/Utilities/College.dart';
import 'package:frontend/Utilities/constants.dart';
import 'package:http/http.dart' as http;

class AllIndia extends StatefulWidget {
  const AllIndia({super.key});

  @override
  State<AllIndia> createState() => _AllIndiaState();
}

class _AllIndiaState extends State<AllIndia> {
  // All variables
  String? mark, rank, branch = " ", college = " ", rnd = '1st Round', r = ' ';
  String city = " ";
  List AI_Data = [], round = ['1st Round', '2nd Round', '3rd Round', ' '];
  var Data = [];
  // List of items in our dropdown menu

  void fetchData() async {
    if (college == "Clear Selection") {
      college = " ";
    }
    if (branch == "Clear Selection") {
      branch = " ";
    }
    if (rnd == '1st Round') {
      r = '1';
    } else if (rnd == '2st Round') {
      r = '2';
    } else {
      r = '3';
    }
    if (city.isNotEmpty) {
      city = city[0].toUpperCase() + city.substring(1);
    }

    String uri =
        'http://192.168.10.13:8000/AI/Info?Rank[gte]=$rank&Score[lte]=$mark&Round=$r';

    final response = await http.get(Uri.parse(uri));
    print(r);
    print(mark);
    print(rank);
    print(uri);

    if (response.statusCode == 200) {
      setState(() {
        AI_Data = jsonDecode(response.body);
        Data = AI_Data;
      });

      if (college != " " && college != null) {
        Data = Data.map((e) {
          if (e['Institute'].contains(college)) {
            return e;
          } else {
            return null;
          }
        }).where((element) => element != null).toList();
      }

      if (branch != " " && branch != null) {
        Data = Data.map((e) {
          if (e['Course Name'].contains(branch)) {
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

    if (r == ' ' ||
        ((rank == null || rank == '') && (mark == null || mark == ''))) {
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
            msg: "For the given filters data is not present",
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

  Widget _buildMarksTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width) * (0.435),
          child: TextField(
            keyboardType: TextInputType.number,
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
              hintText: 'Percentile',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => setState(() {
              mark = value;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width) * (0.435),
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
            onChanged: (value) => setState(() {
              city = value;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildRankTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: (MediaQuery.of(context).size.width) * (0.435),
          child: TextField(
            keyboardType: TextInputType.number,
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
            onChanged: (value) => setState(() {
              rank = value;
            }),
          ),
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
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    selectedItem ?? "Search for college",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    selectedItem ?? "Search Branch",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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

  Widget _buildRoundList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: (MediaQuery.of(context).size.width) * (0.435),
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
            child: DropdownButton(
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF6CA8F1),
              value: rnd,
              items: round.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 5, left: 20),
                    child: Text(e),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  rnd = value.toString();
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

  Widget _buildFilterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
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

  List<DataColumn> _buildColumns() {
    // Define the columns for the table
    return [
      const DataColumn(
          label: Text('College Name', style: TextStyle(color: Colors.white))),
      const DataColumn(
          label: Text('Branch',
              style: TextStyle(
                color: Colors.white,
              ))),
      const DataColumn(
          label: Text('Rank',
              style: TextStyle(
                color: Colors.white,
              ))),
      const DataColumn(
          label: Text('Marks',
              style: TextStyle(
                color: Colors.white,
              ))),
      // Add more columns as needed
    ];
  }

  List<DataRow> _buildRows() {
    // Define the rows for the table
    return Data.map((row) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              row['Institute'].toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          DataCell(Text(
            row['Course Name'].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
          DataCell(Text(
            row['Rank'].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
          DataCell(Text(
            row['Score'].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
          // Add more cells as needed
        ],
      );
    }).toList();
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
                    horizontal: 15.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildMarksTF(),
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
                                                SizedBox(
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
                                                    SizedBox(
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
