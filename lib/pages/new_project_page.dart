import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/logic/project.dart';

class NewProjectPage extends StatefulWidget {
  late List<String> groups = [];
  NewProjectPage({super.key, required this.groups});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage>
    with TickerProviderStateMixin {
  late AnimationController bottomSheetController;

  @override
  initState() {
    super.initState();
    bottomSheetController = BottomSheet.createAnimationController(this);
    bottomSheetController.duration = const Duration(milliseconds: 600);
    bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    super.dispose();
  }

  late String _projectName;
  late String _category;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildProjectName() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        cursorColor: GlobalProperties.SecondaryAccentColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          label: const Text(
            "Project Name",
            style: TextStyle(color: GlobalProperties.SecondaryAccentColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: GlobalProperties.SecondaryAccentColor),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: GlobalProperties.SecondaryAccentColor),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Project Name required!";
          }
          return null;
        }),
        onSaved: (newValue) {
          _projectName = newValue!;
        },
      ),
    );
  }

  bool expand = false;

  Widget _buildCategory() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Stack(
        children: [
          AnimatedContainer(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                  color: GlobalProperties.SecondaryAccentColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            duration: Duration(milliseconds: 200),
            height: !expand ? 0 : 250,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildDropDownItems(),
              ),
            ),
          ),
          TextFormField(
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
            readOnly: true,
            enableInteractiveSelection: false,
            focusNode: AlwaysDisabledFocusNode(),
            controller: categoryController,
            cursorColor: GlobalProperties.SecondaryAccentColor,
            decoration: InputDecoration(
              //contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 16),
              suffixIcon: IconButton(
                //iconSize: 24,
                onPressed: () {
                  setState(() {
                    expand = !expand;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              label: const Text(
                "Category",
                style: TextStyle(color: GlobalProperties.SecondaryAccentColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: GlobalProperties.SecondaryAccentColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: GlobalProperties.SecondaryAccentColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Category required!";
              }
              return null;
            }),
            onSaved: (newValue) {
              _category = newValue!;
            },
          ),
        ],
      ),
    );
  }

  TextEditingController controller = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  List<Widget> _buildDropDownItems() {
    List<Widget> items = [];
    items.add(const Padding(padding: EdgeInsets.only(top: 50)));

    for (var element in widget.groups) {
      items.add(
        ListTile(
          onTap: () {
            setState(() {
              categoryController.text = element;
              expand = !expand;
            });
          },
          contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          title: Text(
            element,
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
            backgroundColor: GlobalProperties.SecondaryAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
          ),
          onPressed: () {
            bool isDataValid = _formKey.currentState!.validate();
            if (isDataValid) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(Project(name: _projectName));
            }
          },
          child: const Text(
            "Create",
            style: TextStyle(
                fontSize: 16, color: GlobalProperties.TextAndIconColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalProperties.TextAndIconColor,
          ),
        ),
        backgroundColor: GlobalProperties.BackgroundColor,
      ),
      backgroundColor: GlobalProperties.BackgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProjectName(),
                    _buildCategory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // fluter 2.x
      floatingActionButton: _buildButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
