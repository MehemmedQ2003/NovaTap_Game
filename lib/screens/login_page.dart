import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<UserProfile> onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();

  void _submit() {
    final name = _username.text.trim();
    if (name.isEmpty) return;
    widget.onLogin(UserProfile(username: name, email: '$name@example.com'));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
