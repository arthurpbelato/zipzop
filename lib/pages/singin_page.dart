import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/chat_%20room_page.dart';
import 'package:zipzop/services/auth.dart';
import 'package:zipzop/services/database_methods.dart';
import 'package:zipzop/widgets/widget.dart';

class SingInPage extends StatefulWidget {
  final Function toggle;

  SingInPage(this.toggle);

  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  late QuerySnapshot snapshotUserInfo;

  void singIn() async {
    if (formKey.currentState!.validate()) {
      Util.saveEmailSharedPreference(emailController.text);
      Util.saveEmailSharedPreference(emailController.text);

      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByEmail(emailController.text).then((value) {
        snapshotUserInfo = value;
        Util.saveUsernameSharedPreference(snapshotUserInfo.docs[0]['username']);
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value != null) {
          Util.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoomPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.center,
              height: 250,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.contain,
                scale: 0.5,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: textFieldInputDecoration("email"),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Preencha o email corretamente";
                            },
                            controller: emailController,
                          ),
                          TextFormField(
                            decoration: textFieldInputDecoration("senha"),
                            validator: (val) {
                              return val!.length < 6
                                  ? "A senha deve ter pelo menos 6 caractéres"
                                  : null;
                            },
                            controller: passwordController,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Esqueci minha senha!",
                          style: linkTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        onPressed: () => singIn(),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text(
                          'Entrar com o Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xff4385F4)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Não possui uma conta? ",
                          style: mediumTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () => widget.toggle(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Registre-se agora!",
                              style: mediumTextStyle()
                                  .apply(decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
// alignment: Alignment.center,
// width: MediaQuery.of(context).size.width,
// padding: EdgeInsets.symmetric(vertical: 20),
// decoration: BoxDecoration(
// gradient: LinearGradient(colors: [
// Color(0xff009688),
// Color(0xff028d81),
// ]),
// borderRadius: BorderRadius.circular(30),
// ),
// child: Text(
// "Entrar",
// style: TextStyle(
// color: Colors.white,
// fontSize: 17,
// ),
// ),
// ),Color(0xff4385F4),
