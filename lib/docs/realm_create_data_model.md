# Generate Data Model for Realm

1. Define DataModel Class

    import 'package:realm/realm.dart'; // import realm package

    part 'data_model.g.dart'; // declare a part file.

    @RealmModel() // define a data model class.
    class $DataModel {
      late String id;
      late String property1;
    }

2. Run following command

`flutter pub run realm generate`
    