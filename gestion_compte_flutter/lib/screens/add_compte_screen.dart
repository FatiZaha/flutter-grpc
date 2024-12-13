import 'package:flutter/material.dart';

import '../src/generated/compte.pb.dart';
import '../src/services/compte_service.dart';

class AddCompteScreen extends StatefulWidget {
  @override
  _AddCompteScreenState createState() => _AddCompteScreenState();
}

class _AddCompteScreenState extends State<AddCompteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _soldeController = TextEditingController();
  final CompteService _compteService = CompteService();

  // Liste des types de compte disponibles
  final List<TypeCompte> _typesCompte = TypeCompte.values;

  TypeCompte? _selectedTypeCompte; // Type de compte sélectionné

  @override
  void dispose() {
    _soldeController.dispose();
    _compteService.close();
    super.dispose();
  }

  void _addCompte() async {
    if (_formKey.currentState!.validate() && _selectedTypeCompte != null) {
      final compte = Compte(
        type: _selectedTypeCompte!, 
        dateCreation: DateTime.now().toString(), // Utilise le type sélectionné
        solde: double.parse(_soldeController.text),
      );
      await _compteService.addCompte(compte);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compte ajouté')));
      Navigator.pushNamed(context, '/add');
    } else {
      // Afficher un message d'erreur si aucun type n'est sélectionné
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un type de compte.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown pour sélectionner le type de compte
              DropdownButtonFormField<TypeCompte>(
                value: _selectedTypeCompte,
                decoration: InputDecoration(labelText: 'Type de compte'),
                items: _typesCompte.map((type) {
                  return DropdownMenuItem<TypeCompte>(
                    value: type,
                    child: Text(type.toString().split('.').last), // Afficher le nom de l'énumération
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTypeCompte = value;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner un type.' : null,
              ),

              TextFormField(
                controller: _soldeController,
                decoration: InputDecoration(labelText: 'Solde'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un solde.' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addCompte,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
