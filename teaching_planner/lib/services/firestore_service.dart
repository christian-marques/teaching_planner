import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String collectionPath;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService(this.collectionPath);

  // 🔹 Criar ou atualizar um documento
  Future<void> setData(String id, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).doc(id).set(data, SetOptions(merge: true));
  }

  // 🔹 Buscar um único documento pelo ID
  Future<T?> getData(String id, T Function(Map<String, dynamic>) fromJson) async {
    DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
    if (doc.exists) {
      return fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // 🔹 Obter todos os documentos de uma coleção
  Stream<List<T>> getCollection(T Function(Map<String, dynamic>) fromJson) {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // 🔹 Atualizar um documento existente
  Future<void> updateData(String id, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).doc(id).update(data);
  }

  // 🔹 Deletar um documento pelo ID
  Future<void> deleteData(String id) async {
    await _db.collection(collectionPath).doc(id).delete();
  }
}
