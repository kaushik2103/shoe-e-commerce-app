import 'package:flutter/material.dart';

class ProductNotifiers extends ChangeNotifier {
  int _activepage = 0;

  bool _isFav = true;
  bool _isCarted = false;

  List<dynamic> _shoesSize = [];
  void valSet(bool vale, List<dynamic> size) {
    _isFav = vale;
    _shoesSize = size;
  }

// getter method for activepage
  int get activepage => _activepage;

// setter method for activepage
  set activepage(int newIndex) {
    _activepage = newIndex;
    notifyListeners();
  }

// getter method for list varaibles
  List<dynamic> get shoeSizes => _shoesSize;

// set method for list varaibles
  set shoeSizes(List<dynamic> selectedSize) {
    _shoesSize = selectedSize;
    notifyListeners();
  }

  bool get isFav => _isFav;

  void favChang(bool fav) {
    _isFav = fav;
    notifyListeners();
  }

  void lFav(bool fav) {
    _isFav = fav;
  }

  void toggleChecked(int index) {
    for (var i = 0; i < _shoesSize.length; i++) {
      if (i == index) {
        _shoesSize[i]["isSelected"] = !_shoesSize[i]["isSelected"];
      }
    }

    notifyListeners();
  }

  bool get isCarted => _isCarted;

  void orderplaced(bool check) {
    _isCarted = check;
    notifyListeners();
  }

  List<String> sizeChecked() {
    List<String> size = [];

    for (var i = 0; i < _shoesSize.length; i++) {
      if (_shoesSize[i]["isSelected"] == true) {
        size.add(shoeSizes[i]["size"].toString());
      }
    }

    if (size.isEmpty) {
      size.add("Not Selected");
    }

    print(size);
    return size;
  }
}
