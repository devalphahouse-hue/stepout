import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCwNazfW2xXO4QAjuhwuXzkPdb_CD3FJ68",
            authDomain: "stepout-franqueado-3zcule.firebaseapp.com",
            projectId: "stepout-franqueado-3zcule",
            storageBucket: "stepout-franqueado-3zcule.firebasestorage.app",
            messagingSenderId: "956357823661",
            appId: "1:956357823661:web:9c3167ca7ca56075c64a24",
            measurementId: "G-D4YF8N67NW"));
  } else {
    await Firebase.initializeApp();
  }
}
