
import 'package:grpc/grpc.dart';
import '../generated/compte.pbgrpc.dart';

class CompteService {
  late ClientChannel _channel;
  late CompteServiceClient _stub;

  CompteService() {
    _channel = ClientChannel(
      '10.0.2.2', // Adresse de votre backend
      port: 9090, // Port gRPC du backend
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = CompteServiceClient(_channel);
  }

  Future<List<Compte>> getComptes() async {
    try {
      final response = await _stub.allComptes(GetAllComptesRequest());
      return response.comptes;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCompte(Compte compte) async {
    try {
      await _stub.saveCompte(compte as SaveCompteRequest);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteCompte(String id) async {
    final request = DeleteCompteByIdRequest()..id = id; // Créez un objet et affectez l'ID
    try {
      await _stub.deleteCompteById(request);  // Appelez la méthode appropriée sur votre stub gRPC
    } catch (e) {
      throw Exception('Erreur lors de la suppression du compte: $e');
    }
  }


  Future<void> close() async {
    await _channel.shutdown();
  }
}
