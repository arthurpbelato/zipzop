import 'package:flutter/material.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/chat_%20room_page.dart';
import 'package:zipzop/services/auth.dart';
import 'package:zipzop/services/database_methods.dart';
import 'package:zipzop/widgets/widget.dart';

class SingUpPage extends StatefulWidget {
  final Function toggle;

  SingUpPage(this.toggle);

  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  void singMeUp() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> userMap = {
        "username" : usernameController.text,
        "email" : emailController.text
      };

      Util.saveUsernameSharedPreference(usernameController.text);
      Util.saveEmailSharedPreference(emailController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .singUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        print(value.toString());


        databaseMethods.uploadUserInfo(userMap);
        Util.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoomPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
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
                              validator: (val) {
                                return val!.isEmpty || val.length < 4
                                    ? "Preencha o nome de usuário corretamente"
                                    : null;
                              },
                              controller: usernameController,
                              decoration:
                                  textFieldInputDecoration("nome de usuário"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Preencha o email corretamente";
                              },
                              controller: emailController,
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: textFieldInputDecoration("senha"),
                              validator: (val) {
                                return val!.length < 6
                                    ? "A senha deve ter pelo menos 6 caractéres"
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () => singMeUp(),
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff009688),
                              Color(0xff028d81),
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Registrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xff4385F4),
                            Color(0xff407fea),
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Registrar com Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
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
                            "Já possui uma conta? ",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () => widget.toggle(),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Entre agora!",
                                style: mediumTextStyle().apply(
                                    decoration: TextDecoration.underline),
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
            ),
    );
  }
}
