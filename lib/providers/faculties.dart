import 'package:flutter/material.dart';
import 'package:smvitm_web/models/faculty.dart';


class Faculties {
  List<Faculty> _faculties = [];

  void addFaculty(Faculty _faculty) {
    _faculties.add(_faculty);
  }

  List<Faculty> getFaculties() {
    return _faculties;
  }

  String getFacultyName(String id) {
    String name = "";
    _faculties.map((e) {
      if (e.id == id) {
        name = e.name;
      }
    }).toList();
    return name;
  }

  String getFacultyImage(String id) {
    String url = "";
    _faculties.map((e) {
      if (e.id == id) {
        url = e.photo;
      }
    }).toList();
    return url;
  }

  List searchFaculty(String val) {
    List faculty = [];
    _faculties.map((e) {
      final searchValue = e.name.toString().toUpperCase();
      if (searchValue.contains(val.toUpperCase())) {
        faculty.add(e);
      }
    }).toList();
    return faculty;
  }

  Faculty getOneFaculty(String id) {
    Faculty _faculty;
    _faculties.map((e) {
      if (e.id == id) {
        _faculty = e;
      }
    }).toList();
    return _faculty;
  }

  deleteItem() {
    _faculties.clear();
  }
}