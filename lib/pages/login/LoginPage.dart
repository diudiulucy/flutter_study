import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unnameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _unnameController.addListener(() {
      print(_unnameController.text);
    });
  }

  String _nameValidator(dynamic v) {
    return v.trim().length > 0 ? null : "用户名不能为空";
  }

  String _pswValidator(dynamic v) {
    return v.trim().length > 5 ? null : "密码不能少于6位";
  }

  void _onLoginPress() {
    if ((_formKey.currentState as FormState).validate()) {
      print("验证通过");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
              icon: Icon(Icons.navigate_before, color: Colors.grey),
              onPressed: () {
                // Scaffold.of(context).openDrawer();
                Navigator.of(context).pop();
              });
        }),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 80,
                height: 94,
                child: Image.asset(
                  "lib/assets/images/myinfo/logo1.png",
                  fit: BoxFit.cover,
                ),
              ),
              // Image.asset(
              //   "lib/assets/images/myinfo/logo1.png",
              //   width: 60.0,
              // ),
              TextFormField(
                controller: _unnameController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "手机号或邮箱",
                    prefixIcon: Icon(Icons.person)),
                validator: _nameValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "您的登录密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: _pswValidator,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Text("确定"),
                      onPressed: _onLoginPress,
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
