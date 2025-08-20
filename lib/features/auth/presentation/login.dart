import 'package:flutter/material.dart';
import 'package:pocaudiolearn/gen/main.dart'; // ton HomeScreen
import 'package:pocaudiolearn/core/network/graphql_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // init du client réseau (charge le token si déjà stocké)
    await GraphQLCore.I.init();

    // Pré-remplir l’email si "remember me" avait été activé
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('remember_me') ?? false;
    if (_rememberMe) {
      _emailCtrl.text = prefs.getString('remembered_email') ?? '';
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    setState(() => _loading = true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    try {
      final res = await AuthService.I.login(
        email: _emailCtrl.text,
        password: _pwCtrl.text,
      );

      // Mémoriser l’email si demandé
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
      if (_rememberMe) {
        await prefs.setString('remembered_email', _emailCtrl.text.trim());
      } else {
        await prefs.remove('remembered_email');
      }

      // Navigation succès
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenue ${res.user.email}')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      // Message d’erreur user-friendly
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de connexion : $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitEnabled = !_loading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/login.png'),
                  const SizedBox(height: 8),
                  const Text(
                    'Se connecter à votre compte',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Email requis';
                      final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                      if (!ok) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Mot de passe
                  TextFormField(
                    controller: _pwCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if ((v ?? '').isEmpty) return 'Mot de passe requis';
                      if ((v ?? '').length < 6) return '6 caractères minimum';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Remember me + Forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: _loading
                                ? null
                                : (val) => setState(() => _rememberMe = val ?? false),
                          ),
                          const Text('Se souvenir de moi'),
                        ],
                      ),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Redirection vers la réinitialisation...')),
                          );
                        },
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bouton Connexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitEnabled ? _onLogin : null,
                      child: _loading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Se connecter', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text('Ou connectez-vous via'),
                  const SizedBox(height: 10),

                  // Boutons sociaux (placeholders)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.login, size: 40),
                        onPressed: _loading
                            ? null
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connexion via Google...')),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.facebook, size: 40, color: Colors.blue),
                        onPressed: _loading
                            ? null
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connexion via Facebook...')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}