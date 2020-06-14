import 'package:carros/model/carro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritoBloc{

  CollectionReference get _collection => Firestore.instance.collection('carros');
  Stream<QuerySnapshot> get snapshots => _collection.snapshots();

  Future<bool> favoritar(Carro c) async {
    DocumentReference docRef = _collection.document("${c.id}");
    DocumentSnapshot doc = await docRef.get();
    final exists = doc.exists;
    if(exists){
      docRef.delete();
      return false;
    } else {
      docRef.setData(c.toMap());
      return true;
    }
  }


  Future<bool> isFavorito(Carro c) async {
    DocumentReference docRef = _collection.document("${c.id}");
    DocumentSnapshot doc = await docRef.get();
    final exists = doc.exists;
    return exists;
  }

}