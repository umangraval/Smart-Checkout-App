import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory/screens/qr_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class buildEmailSignIn extends StatefulWidget {
  final primaryText;

  const buildEmailSignIn({Key key, this.primaryText}) : super(key: key);
  @override
  _buildEmailSignInState createState() => _buildEmailSignInState();
}

class _buildEmailSignInState extends State<buildEmailSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    _isLoading = true;
    if (widget.primaryText == 'Sign Up') {
      Map data = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'mobile': _mobileController.text,
      };
      Map<String, dynamic> jsonData;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response = await http.post(
          "http://ec2-13-233-229-19.ap-south-1.compute.amazonaws.com/api/buyer/add",
          body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        var token = jsonData['token'];
        sharedPreferences.setString("token", token);
//        sP.setToken(token);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => QRCodeScanner()));
      } else {
        print(response.body);
      }
    } else if (widget.primaryText == 'Sign in') {
      Map data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      Map<String, dynamic> jsonData;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response = await http.post(
          "http://ec2-13-233-229-19.ap-south-1.compute.amazonaws.com/api/buyer/login",
          body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        var token = jsonData['token'];
        sharedPreferences.setString("token", token);
//        sP.setToken(token);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => QRCodeScanner()));
      } else {
        print(response.body);
      }
    }
    print(
        'email: ${_emailController.text}  , password: ${_passwordController.text}');
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _passwordController.clear();
      _emailController.clear();
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'test@test.com',
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => widget.primaryText == 'Sign Up'
                  ? FocusScope.of(context).requestFocus(_nameFocusNode)
                  : FocusScope.of(context).requestFocus(_passwordFocusNode),
            ),
            SizedBox(
              height: 8.0,
            ),
            widget.primaryText == 'Sign Up'
                ? TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Aashray',
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_mobileFocusNode),
                  )
                : SizedBox(
                    height: 4.0,
                  ),
            SizedBox(
              height: 8.0,
            ),
            widget.primaryText == 'Sign Up'
                ? TextField(
                    controller: _mobileController,
                    focusNode: _mobileFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      hintText: '9876543210',
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                  )
                : SizedBox(
                    height: 4.0,
                  ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: _submit,
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
        SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.4,
          child: RaisedButton(
            child: Text(
              widget.primaryText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            color: Colors.black87,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            )),
            onPressed: !_isLoading ? _submit : null,
          ),
        ),
        SizedBox(
          height: 60.0,
        )
      ],
    );
  }
}
