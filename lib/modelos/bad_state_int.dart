
import 'package:cloud_firestore/cloud_firestore.dart';

int BadStateInt(item, type) {
  int inteiro = 0;
  try {
    if (item != null) {
      dynamic data = item.get(FieldPath([type])) ?? '';
      inteiro = data;
    } else {
      inteiro = 0;
    }
  } on StateError {
    inteiro = 0;
  }
  return inteiro;
}
