import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Functions/fetch_potdAPI.dart';
import 'package:spacenetic_flutter/Services/firebase_auth_methods.dart';
import 'package:spacenetic_flutter/UI/homepage.dart';

// void main() => runApp(
//       MaterialApp(
//         home: Navigator(
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (context) => const LoginPage(),
//             );
//           },
//         ),
//       ),
//     );

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    fetchAPOD();
  }

  void loginUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
  }

  // void navigateToHomePage(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => const HomePage(),
  //   ));
  // }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<String> fetchAPOD() async {
    final api = FetchPotdAPI();
    final response = await http.get(
        Uri.parse(
            'https://api.nasa.gov/planetary/apod?api_key=${api.nasaAPIKey}'),
        headers: {'X-API-key': api.nasaAPIKey});
    final jsonData = jsonDecode(response.body);
    final apodUrl = jsonData['url'] as String?;
    if (apodUrl != null) {
      return apodUrl;
    } else {
      throw Exception('Failed to load APOD url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: fetchAPOD(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final apodUrl = snapshot.data;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: apodUrl != null
                        ? DecorationImage(
                            image: NetworkImage(apodUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.orbitron(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address.';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _email = value.trim();
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _password = value.trim();
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton(
                              onPressed: loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 100.0),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseAuthMethods(FirebaseAuth.instance)
                                    .signInWithGoogle(context);
                              },
                              child: const Text('Sign In with Google'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
