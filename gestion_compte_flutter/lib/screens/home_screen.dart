import 'package:flutter/material.dart';

import '../src/generated/compte.pb.dart';
import '../src/services/compte_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CompteService _compteService = CompteService();
  late Future<List<Compte>> _comptes;

  @override
  void initState() {
    super.initState();
    _comptes = _compteService.getComptes();
  }

  @override
  void dispose() {
    _compteService.close();
    super.dispose();
  }

  // Fonction pour supprimer un compte
  void _deleteCompte(String id) async {
    try {
      await _compteService.deleteCompte(id.toString());
      setState(() {
        _comptes = _compteService.getComptes(); // Mettre à jour la liste après suppression
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compte supprimé')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Comptes'),
      ),
      body: FutureBuilder<List<Compte>>(
        future: _comptes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun compte trouvé.'));
          } else {
            final comptes = snapshot.data!;
            return ListView.builder(
              itemCount: comptes.length,
              itemBuilder: (context, index) {
                final compte = comptes[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('Type de compte: ${compte.type}'),
                    subtitle: Text('Solde: ${compte.solde}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCompte(compte.id);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
