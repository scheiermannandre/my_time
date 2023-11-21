## Getting Started

1. register new project at `https://console.firebase.google.com/`
2. install firebase CLI see `https://firebase.google.com/docs/cli?hl=de&authuser=0&_gl=1*1raknr8*_ga*NDkyMDMxMjQxLjE2OTcwOTUyNDY.*_ga_CW55HF8NVT*MTY5OTY5NjIyNC4yLjEuMTY5OTY5NzU1NC42MC4wLjA.#install_the_firebase_cli`
3. login to firebase  `firebase login`
4. install the flutterFire CLI `dart pub global activate flutterfire_cli`
5. configure firebase for the project by running `flutterfire configure --project=mighty-time-tracker` in the project root
6. add dependency for `firebase_core`
7. add following to the main.dart file:
```
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; -> this should be the file that was just generated

// this should go to the main method
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
```

