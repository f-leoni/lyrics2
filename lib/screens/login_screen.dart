import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/models/models.dart';

class LoginScreen extends StatefulWidget {
  // LoginScreen MaterialPage Helper
  static MaterialPage page() {
    return MaterialPage(
      name: LyricsPages.loginPath,
      key: ValueKey(LyricsPages.loginPath),
      child: const LoginScreen(),
    );
  }

  final String? username;

  const LoginScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final Color rwColorRegistration = const Color.fromRGBO(143, 64, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Provider.of<FirebaseUserRepository>(context, listen: false).darkMode;
    final logoImg = isDark
        ? const AssetImage('assets/lyrics_assets/logo_dark.png')
        : const AssetImage('assets/lyrics_assets/logo.png');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image(image: logoImg),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildEmailField(
                        context,
                        widget.username ??
                            AppLocalizations.of(context)!.username,
                        TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    buildPasswordField(
                        context,
                        AppLocalizations.of(context)!.password,
                        TextInputType.visiblePassword),
                    const SizedBox(height: 16),
                    buildButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField(
      BuildContext context, String hintText, TextInputType keyboardType) {
    //final userDao = Provider.of<FirebaseUserRepository>(context, listen: false);

    return TextFormField(
      cursorColor: rwColor,
      controller: _emailController,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.errEmailRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(height: 0.5),
      ),
    );
  }

  Widget buildPasswordField(
      BuildContext context, String hintText, TextInputType keyboardType) {
    //final userDao = Provider.of<FirebaseUserRepository>(context, listen: false);

    return TextFormField(
      cursorColor: rwColor,
      controller: _passwordController,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.errPwdRequired;
        }
        if (value.length < 6) {
          return AppLocalizations.of(context)!.errWeakPassword;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(height: 0.5),
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    if (!_isRegistering) {
      return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              color: rwColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AppLocalizations.of(context)!.msgLogin,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  UserCredential? uc;
                  var users = Provider.of<FirebaseUserRepository>(context,
                      listen: false);
                  // Login -> Navigate to home
                  try {
                    uc = await users.login(
                        _emailController.text, _passwordController.text);
                    if (uc == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, users.lastErrorCode)}'),
                      ));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, e.code)}'),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${AppLocalizations.of(context)!.msgError}: ${e.toString()}'),
                    ));
                  }
                }
              },
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.msgRegisterExtended,
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegistering = true;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.msgRegister,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: rwColorRegistration,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AppLocalizations.of(context)!.msgRegister,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  UserCredential? uc;
                  var users = Provider.of<FirebaseUserRepository>(context,
                      listen: false);
                  // Register -> Sign-up then Navigate to home
                  try {
                    uc = await users.signup(
                        _emailController.text, _passwordController.text);
                    if (uc == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, users.lastErrorCode)}'),
                      ));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, e.code)}'),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${AppLocalizations.of(context)!.msgError}: ${e.toString()}'),
                    ));
                  }
                }
              },
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.msgLoginExtended,
                    style: const TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegistering = false;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.msgLogin,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      ;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
