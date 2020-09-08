import 'package:smvitm_web/models/category.dart';

class Categories {
  List<Category> _categories = [];

  void addCategory(Category _category) {
    _categories.add(_category);
  }

  List<Category> getCategory() {
    return _categories;
  }

  deleteItem() {
    _categories.clear();
  }
}