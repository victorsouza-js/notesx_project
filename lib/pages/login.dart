import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> _salvarLogin(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _carregarLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      _emailController.text = email;
      _passwordController.text = password;
    }
  }

  Future<bool> validarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString('password');
    final email = prefs.getString('email');

    return _passwordController.text == password &&
        _emailController.text == email;
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  bool _isPasswordVisible = false;

  void initState() {
    super.initState();
    _carregarLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(70)),
              Icon(Icons.notes, size: 100, color: Colors.black),

              Text(
                'Bem -vindo ao NotesX',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Padding(padding: EdgeInsets.all(15)),
              //SizedBox(height: 20,),//
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      color: Colors.black,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: Colors.black,
                    ),
                    hintText: 'Senha',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    } else if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(2.4)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/redefinir_senha');
                    },
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(padding: EdgeInsets.all(15)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (await validarLogin()) {
                      await _salvarLogin(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.pushNamed(context, '/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Email e senha incorretos'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 17),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('Entrar'),
              ),
              Padding(padding: EdgeInsets.all(15)),
            ],
          ),
        ),
      ),
    );
  }
}
