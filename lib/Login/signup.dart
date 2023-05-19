import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/Login/login.dart';
import 'package:http/http.dart' as http;

import '../Utilities/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Variables
  bool erroremail = false,
      errorroll = false,
      errorrank = false,
      errorper = false;
  String email = '', password = '', rollnumber = '';
  int? rank;
  double? percentile;
  var loginData;

  // Function
  Future<void> signup() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    email = email.trim();
    password = password.trim();
    rollnumber = rollnumber.trim();
    if (email == '' ||
        password == '' ||
        rollnumber == '' ||
        rank == null ||
        percentile == null) {
      Fluttertoast.showToast(
          msg: "Enter all details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.blue,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } else {
      final response = await http.get(Uri.parse(
          'https://backend-mqqg.onrender.com/Login/Save?password=$password&email=$email&rank=$rank&rollno=$rollnumber'));
      if (response.statusCode == 200) {
        setState(() {
          loginData = jsonDecode(response.body);
        });
      }
      Navigator.of(context).pop();
      if (email != '' &&
          password != '' &&
          rollnumber != '' &&
          rank != '' &&
          percentile != '') {
        if (loginData["msg"] == "account exists") {
          Fluttertoast.showToast(
              msg: "Account Already exist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: 16.0);
        } else if (loginData["msg"] == "account created") {
          Fluttertoast.showToast(
              msg: "Account Created",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: 16.0);
          // ignore: use_build_context_synchronously
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Login()));
        }
      }
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              errorText: erroremail ? 'Enter correct email ID' : null,
              // contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            onChanged: ((value) => setState(() {
                  if (EmailValidator.validate(value) || value == '') {
                    email = value;
                    erroremail = false;
                  } else {
                    erroremail = true;
                  }
                }))),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              // contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: kHintTextStyle,
            ),
            onChanged: ((value) => setState(() {
                  password = value;
                }))),
      ],
    );
  }

  Widget _buildRollNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Roll Number',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              errorText: errorroll ? 'Enter correct roll number' : null,
              // contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'Enter your Roll Number',
              hintStyle: kHintTextStyle,
            ),
            onChanged: ((value) => setState(() {
                  if (value.length == 9 || value.length == 12 || value == '') {
                    rollnumber = value;
                    errorroll = false;
                  } else {
                    errorroll = true;
                  }
                }))),
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
        TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
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
              hintText: 'Enter your rank',
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
      ],
    );
  }

  Widget _buildPercentileTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Percentile',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red, width: 2)),
              errorText:
                  errorper ? 'Percentile should be between 0 to 100' : null,
              // contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.numbers,
                color: Colors.white,
              ),
              hintText: 'Enter your percentile',
              hintStyle: kHintTextStyle,
            ),
            onChanged: ((value) => setState(() {
                  if ((double.parse(value) > 0 && double.parse(value) < 100) ||
                      value.isEmpty ||
                      value.length == 9) {
                    percentile = double.parse(value);
                    errorper = false;
                  } else {
                    errorper = true;
                  }
                }))),
      ],
    );
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

  Widget _buildSignUpBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: getColor(Colors.white, Colors.teal),
        ),
        onPressed: () => {
          if (EmailValidator.validate(email))
            {signup()}
          else
            {
              Fluttertoast.showToast(
                  msg: "Enter Correct Email ID",
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
            'SignUp',
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
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildEmailTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildRollNumberTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildRankTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildPercentileTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildSignUpBtn(),
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
