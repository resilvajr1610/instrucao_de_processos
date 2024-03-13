
import 'package:cloud_firestore/cloud_firestore.dart';

List BadStateList(item, type) {
  List lista = [];
  try {
    if (item != null) {
      dynamic data = item.get(FieldPath([type])) ?? '';
      lista = data;
    } else {
      lista = [];
    }
  } on StateError {
    lista = [];
  }
  return lista;
}
