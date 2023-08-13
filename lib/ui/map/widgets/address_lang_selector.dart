import 'package:flutter/material.dart';
import 'package:map/providers/address_call_provider.dart';
import 'package:map/utils/constants/constants.dart';
import 'package:provider/provider.dart';


class AddressLangSelector extends StatefulWidget {
  const AddressLangSelector({Key? key}) : super(key: key);



  @override
  State<AddressLangSelector> createState() => _AddressLangSelectorState();
}

class _AddressLangSelectorState extends State<AddressLangSelector> {
  String dropdownValue = langList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });

        context.read<AddressCallProvider>().updateLang(dropdownValue);
      },
      items: langList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: Colors.green,
              ),
              child: Text(value,style: const TextStyle(
                color: Colors.black
              ),)),
        );
      }).toList(),
    );
  }
}