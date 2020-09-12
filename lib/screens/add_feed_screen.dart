import 'dart:convert';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm_web/widgets/loading.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class AddFeedScreen extends StatefulWidget {
  static const routeName = '/addfeed';
  final String categoryId, type, fid;

  const AddFeedScreen({
    Key key,
    @required this.categoryId,
    @required this.type,
    @required this.fid,
  }) : super(key: key);

  @override
  _AddFeedScreenState createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  List<File> _files = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> _listOfMap = [];
  List<Map<String, String>> _fp1 = [];
  bool isLoad = false;

  List<FilePickerCross> fp;
  FilePickerCross filePickerCross;

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {

        _error = true;
      });
    }
  }

  CollectionReference notification = FirebaseFirestore.instance.collection('notification');

  @override
  void initState() {
    super.initState();
  }

  void _selectFilepdf() async {
    //fp = await FilePickerCross.importMultipleFromStorage(type: FileTypeCross.custom,fileExtension: '.pdf');
    filePickerCross = await FilePickerCross.importFromStorage(
        type: FileTypeCross.custom, fileExtension: '.pdf');
    print(filePickerCross.fileName);

    setState(() {
      _fp1.add({
        'name': filePickerCross.fileName,
        'base64': filePickerCross.toBase64()
      });
    });
  }

  void _selectFileimg() async {
    filePickerCross =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    print(filePickerCross.fileName);

    setState(() {
      _fp1.add({
        'name': filePickerCross.fileName,
        'base64': filePickerCross.toBase64()
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Feed',
          style: TextStyle(
              letterSpacing: 0.2,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleSpacing: 0.0,
        actions: [
          if (widget.type != 'Text')
            IconButton(
              onPressed:
                  (widget.type == 'Image') ? _selectFileimg : _selectFilepdf,
              icon: Icon(
                MdiIcons.attachment,
                color: Theme.of(context).primaryColor,
              ),
            )
        ],
      ),
      body: isLoad
          ? Loading()
          : Container(
              height: _mediaQuery.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 6.0),
                  _InputField(controller: _title, label: 'Title'),
                  const SizedBox(height: 10.0),
                  _InputField(
                    controller: _description,
                    label: 'Description',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 20.0),
                  if (_fp1 != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _fp1.length,
                        itemBuilder: (context, index) {
                          String fileName = _fp1[index]['name'];
                          return ListTile(
                            title: Text(
                              '$fileName',
                              maxLines: 2,
                              style: TextStyle(),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _fp1.removeAt(index);
                                });
                              },
                              icon: Icon(MdiIcons.fileRemove),
                            ),
                          );
                        },
                      ),
                    ),
                  _Button(
                    title: 'SUBMIT',
                    onTap: () {
                      _submit();
                    },
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
    );
  }

  _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade900,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _submit() async {
    if (_title.text == null || _title.text.length <= 0) {
      _showSnackBar('Please enter the title');
    } else if (_description.text == null || _description.text.length <= 0) {
      _showSnackBar('Please enter the description');
    } else if (widget.type != 'Text' && _files == null) {
      _showSnackBar('Please attach a file');
    } else {
      if (widget.type != 'Text') {
        _fp1
            .map((e) => {
                  _listOfMap.add({'res': e['base64']}),
                })
            .toList();
      }

      setState(() {
        isLoad = true;
      });
      http.Response response = await http
          .post('http://smvitmapp.xtoinfinity.tech/php/addFeed.php', body: {
        'category_id': widget.categoryId,
        'feed_title': _title.text,
        'feed_description': _description.text,
        'feed_type': widget.type,
        'faculty_id': widget.fid,
        'feed_res':
            widget.type == 'Text' ? '' : JsonEncoder().convert(_listOfMap),
        'type': widget.type,
        'feed_time': DateTime.now().toString(),
      });
      initializeFlutterFire();
      await notification.add({'tittle': _title.text, 'body': _description.text, 'to' : widget.categoryId});
      setState(() {
        isLoad = false;
      });
      print(response.body.toString());

      if (response.body.toString() == 'yes') {
        _showSnackBar('Uploaded successfully');
      } else {
        _showSnackBar('Something went wrong... Please try again');
      }
    }
  }
}

class _Button extends StatelessWidget {
  final String title;
  final Function onTap;

  const _Button({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.0,
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2.0)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const _InputField({
    Key key,
    @required this.controller,
    @required this.label,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        maxLines: maxLines,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          alignLabelWithHint: true,
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            letterSpacing: 1,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
