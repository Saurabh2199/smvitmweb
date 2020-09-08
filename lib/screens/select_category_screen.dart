import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm_web/config/color_palette.dart';
import 'package:smvitm_web/models/category.dart';
import 'package:smvitm_web/providers/categories.dart';
import 'package:smvitm_web/screens/add_feed_screen.dart';
import 'package:smvitm_web/widgets/loading.dart';

class SelectCategoryScreen extends StatefulWidget {
  static const routeName = '/selectCategory';

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String _categoryId = '';

  Categories _categories = Categories();

  bool isGet = false;

  bool isLoad = true;

  _collectdata() async {
    final response = await http
        .post('http://smvitmapp.xtoinfinity.tech/php/getAll.php', body: {});
    final userResponse = json.decode(response.body);
    final allData = userResponse['allData'];
    List categoryData = allData['category'];
    print(categoryData.toString());

    categoryData.map((e) {
      _categories.addCategory(
        Category(
          id: e['category_id'].toString(),
          image: e['category_image'].toString(),
          name: e['category_name'].toString(),
          isSelect: false,
        ),
      );
    }).toList();
    setState(() {
      isLoad=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGet) {
      isGet = true;
      _collectdata();
    }
    return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  'Select Category',
                  style: TextStyle(
                      letterSpacing: 0.2,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              titleSpacing: 0.0,
            ),
            body:  isLoad
                ? Loading()
                : GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50.0,
                crossAxisSpacing: 50.0,
              ),
              itemCount: _categories.getCategory().length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _categoryId = _categories.getCategory()[index].id;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: 100.0,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _Card(
                                  icon: MdiIcons.text,
                                  title: 'Text',
                                  categoryId: _categoryId,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: _Card(
                                  icon: MdiIcons.image,
                                  title: 'Image',
                                  categoryId: _categoryId,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: _Card(
                                  icon: MdiIcons.fileDocument,
                                  title: 'Document',
                                  categoryId: _categoryId,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              NetworkImage(_categories.getCategory()[index].image),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          _categories.getCategory()[index].name,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final String categoryId;

  _Card({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.categoryId,
  }) : super(key: key);

  String _getID() {
    final box = GetStorage();
    return box.read('id');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddFeedScreen(
                categoryId: categoryId, type: title, fid: _getID()),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: ColorPalette.primaryColor,
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: TextStyle(
                color: ColorPalette.primaryColor,
                fontSize: 14.0,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
