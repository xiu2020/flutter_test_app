import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _showDialog(String text) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> login(String username, String password) async {
    var url = Uri.parse('http://localhost:2000/client/test');
    Map<String, String> headers = {'content-type': 'application/json'};
    Map<String, String> body = {'username': username, 'password': password};
    var encodedBody = jsonEncode(body);
    var response = await http.post(url, headers: headers, body: encodedBody);
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      var message = decodedJson['msg'];
      if (message == 'success') {
        await _showDialog('登录成功');
      } else {
        await _showDialog('登录失败，请检查用户名和密码是否正确');
      }
    } else {
      await _showDialog('网络错误，请稍后再试！');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '用户名',
              hintText: '请输入用户名',
              icon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.text,
            controller: userController,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: '密码',
              hintText: '请输入密码',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            keyboardType: TextInputType.text,
            controller: passwordController,
          ),
          ElevatedButton(
            child: Text('登录'),
            onPressed: () {
              var username = userController.text;
              var password = passwordController.text;
              login(username, password);
            },
          ),
        ],
      ),
    );
  }
}