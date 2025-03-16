import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:provider/provider.dart';
import 'package:lyrics2/models/models.dart';

import 'package:lyrics2/components/logger.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Provider.of<FirebaseUserRepository>(context, listen: false).darkMode;
    final logoImg = isDark
        ? const AssetImage('assets/lyrics_assets/splash_dark.png')
        : const AssetImage('assets/lyrics_assets/splash.png');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
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
    final theme =
        Provider.of<FirebaseUserRepository>(context, listen: false).themeData;

    return TextFormField(
      cursorColor: theme.colorScheme.secondary,
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
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColorDark,
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
          ),
        ),
        hintText: hintText,
        hintStyle: theme.textTheme.headlineMedium,
      ),
    );
  }

  Widget buildPasswordField(
      BuildContext context, String hintText, TextInputType keyboardType) {
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    var theme = users.themeData;
    return TextFormField(
        cursorColor: theme.colorScheme.secondary,
        controller: _passwordController,
        keyboardType: keyboardType,
        obscureText: !_passwordVisible,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        enableSuggestions: false,
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
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.primaryColorDark,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
              ),
            ),
            hintText: hintText,
            hintStyle: theme.textTheme.headlineMedium,
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: users.themeData.primaryColorDark),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )));
  }

  Widget buildButtons(BuildContext context) {
    var theme =
        Provider.of<FirebaseUserRepository>(context, listen: false).themeData;
    var locale = AppLocalizations.of(context)!;
    if (!_isRegistering) {
      return SizedBox(
        height: 145,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              color: theme.indicatorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AppLocalizations.of(context)!.msgLogin,
                style: theme.textTheme.labelLarge,
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
                      if (!mounted) {
                        logger.e("Login error: not mounted");
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${locale.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, users.lastErrorCode)}',
                            style: theme.textTheme.labelLarge),
                      ));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${locale.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, e.code)}',
                            style: theme.textTheme.labelLarge),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        '${locale.msgError}: ${e.toString()}',
                        style: theme.textTheme.labelLarge,
                      ),
                    ));
                  }
                }
              },
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale.msgRegisterExtended,
                  style: theme.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegistering = true;
                    });
                  },
                  child: Text(
                    locale.msgRegister,
                    //style: theme.textTheme.bodyText1
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: theme.colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AppLocalizations.of(context)!.msgRegister,
                style: theme.textTheme.labelLarge,
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
                      if (!mounted) {
                        logger.e("Login error: not mounted 2");
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(AppLocalizations.of(context)!, users.lastErrorCode)}',
                          style: theme.textTheme.labelLarge,
                        ),
                      ));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        '${AppLocalizations.of(context)!.msgError}: ${users.codeToLocalizedString(
                          AppLocalizations.of(context)!,
                          e.code,
                        )}',
                        style: theme.textTheme.labelLarge,
                      ),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        '${AppLocalizations.of(context)!.msgError}: ${e.toString()}',
                        style: theme.textTheme.labelLarge,
                      ),
                    ));
                  }
                }
              },
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.msgLoginExtended,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegistering = false;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.msgLogin,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
