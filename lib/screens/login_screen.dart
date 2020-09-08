import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smvitm_web/models/faculty.dart';
import 'package:smvitm_web/screens/select_category_screen.dart';
import 'package:smvitm_web/utility/collect_data.dart';
import 'package:smvitm_web/widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool code = false;
  bool isLoad = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _idCon = TextEditingController();
  TextEditingController _passCon = TextEditingController();


  Widget _getTextField(double width, bool obscure, String label,
      TextEditingController controller) {
    return Container(
      width: width * 0.7,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Invalid Credentials",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  checkLogin() async {
    String id = _idCon.text, password = _passCon.text;

    if (id.length < 2 || password.length < 3) {
      _showSnackBar();
    } else {
      print("$id  $password");
      setState(() {
        isLoad = true;
      });
      final response = await http.post(
          'http://smvitmapp.xtoinfinity.tech/php/facultyLogin.php',
          body: {'faculty_id': id, 'password': password});
      setState(() {
        isLoad = false;
      });
      if (response.body == 'yes') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SelectCategoryScreen.routeName, (route) => false);
      } else {
        _showSnackBar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: _mediaQuery.width,
        padding: EdgeInsets.symmetric(horizontal: _mediaQuery.width * 0.15),
        child:isLoad
            ? Loading()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logo_color.png',
              height: _mediaQuery.width * 0.2,
              width: _mediaQuery.width * 0.2,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Faculty Login",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            _getTextField(_mediaQuery.width, false, 'Faculty ID', _idCon),
            SizedBox(
              height: 10,
            ),
            _getTextField(_mediaQuery.width, true, 'Password', _passCon),
            SizedBox(
              height: 20,
            ),
            Container(
              width: _mediaQuery.width * 0.7,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  checkLogin();
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}