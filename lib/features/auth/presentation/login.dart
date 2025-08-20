import 'package:flutter/material.dart';
import 'package:pocaudiolearn/gen/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/login.png'),
              const Text(
                'Se connecter à votre compte',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Champ Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Option "Se souvenir de moi"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Se souvenir de moi'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Redirection vers la page de réinitialisation de mot de passe
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
              ElevatedButton(
                onPressed: () {
                  // Logique de connexion ici
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connexion...')),
                  );
                },
                child: const Center(
                  child: Text('Se connecter', style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),

              // Connexion via Réseaux sociaux
              const Text('Ou connectez-vous via'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.login, size: 40),
                    onPressed: () {
                      // Logique de connexion avec Google
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connexion via Google...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 40, color: Colors.blue),
                    onPressed: () {
                      // Logique de connexion avec Facebook
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connexion via Facebook...')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
