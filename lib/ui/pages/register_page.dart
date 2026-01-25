import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().register(
        _nameController.text,
        _emailController.text,
        _passController.text,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Ad Soyad / Takma Ad",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Bu alan zorunludur" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Bu alan zorunludur" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    v!.length < 4 ? "Şifre en az 4 karakter olmalı" : null,
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "KAYIT OL VE OYNA",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
