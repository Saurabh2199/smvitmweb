import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smvitm_web/models/category.dart';
import 'package:smvitm_web/models/faculty.dart';
import 'package:smvitm_web/providers/categories.dart';
import 'package:smvitm_web/providers/faculties.dart';

class CollectData {
  Future<void> allData(Categories categories, Faculties faculties) async {
    categories.deleteItem();
    faculties.deleteItem();

    final response = await http
        .post('http://smvitmapp.xtoinfinity.tech/php/getAll.php', body: {});
    final userResponse = json.decode(response.body);
    final allData = userResponse['allData'];
    List facultyData = allData['faculty'];
    List categoryData = allData['category'];

    facultyData.map((e) {
      faculties.addFaculty(Faculty(
        id: e['faculty_id'].toString(),
        branch: e['faculty_branch'].toString(),
        designation: e['faculty_designation'].toString(),
        email: e['faculty_email'].toString(),
        name: e['faculty_name'].toString(),
        phone: e['faculty_phone'].toString(),
        photo: e['faculty_photo'].toString(),
        password: e['password'].toString(),
      ));
    }).toList();

    categoryData.map((e) {
      categories.addCategory(
        Category(
          id: e['category_id'].toString(),
          image: e['category_image'].toString(),
          name: e['category_name'].toString(),
          isSelect: false,
        ),
      );
    }).toList();

    return;
  }
}
