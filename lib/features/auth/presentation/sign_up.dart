import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _acceptMarketingEmails = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Créer un nouveau compte',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Champ Nom
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 20),

              // Champ Confirmation Mot de passe
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Autorisation d'envoyer des mails commerciaux
              Row(
                children: [
                  Checkbox(
                    value: _acceptMarketingEmails,
                    onChanged: (value) {
                      setState(() {
                        _acceptMarketingEmails = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('J\'accepte de recevoir des emails commerciaux.'),
                  ),
                ],
              ),

              // Accepter les Termes et Conditions
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                  ),
                  const Expanded(child: Text('J\'accepte les termes et conditions.')),
                ],
              ),

              const SizedBox(height: 20),

              // Bouton Inscription
              ElevatedButton(
                onPressed: _acceptTerms
                    ? () {
                  // Logique d'inscription ici
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inscription réussie.')),
                  );
                }
                    : null, // Désactivé si les termes ne sont pas acceptés
                child: const Center(
                  child: Text('S\'inscrire', style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),

              // Inscription via Réseaux sociaux
              const Text('Ou inscrivez-vous via'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.login, size: 40),
                    onPressed: () {
                      // Logique d'inscription avec Google
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inscription via Google...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 40, color: Colors.blue),
                    onPressed: () {
                      // Logique d'inscription avec Facebook
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inscription via Facebook...')),
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
