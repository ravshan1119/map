import 'package:flutter/cupertino.dart';
import 'package:map/data/local/local_db.dart';
import 'package:map/data/model/user_address.dart';

class UserLocationsProvider with ChangeNotifier {
  List<UserAddress> addresses = [];

  UserLocationsProvider() {
    getUserAddresses();
  }

  getUserAddresses() async {
    addresses = await LocalDatabase.getAllUserAddresses();
    print("CURRENT LENGTH:${addresses.length}");
    notifyListeners();
  }

  insertUserAddress(UserAddress userAddress) async {
    await LocalDatabase.insertUserAddress(userAddress);
    getUserAddresses();
  }

  deleteUserAddress(int id) async {
    await LocalDatabase.deleteUserAddress(id);
    getUserAddresses();
  }
  updateUserAddress(UserAddress userAddress) async {
    await LocalDatabase.updateAddresses(userAddress);
    getUserAddresses();
  }
}
