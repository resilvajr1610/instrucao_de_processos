
import 'package:cloud_firestore/cloud_firestore.dart';

String BadStateString(item, type) {
  String text = '';
  try {
    if (item != null) {
      dynamic data = item.get(FieldPath([type])) ?? '';
      text = data;
    } else {
      text = '';
    }
  } on StateError {
    text = '';
  }
  return text;
}
