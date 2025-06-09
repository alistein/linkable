import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/view/shared/empty_boxes.dart';

class CustomLocationWidget extends StatelessWidget {
  final String postcode; // Current postcode value
  final List<Map<String, dynamic>> addresses; // List of addresses
  final Map<String, dynamic>? selectedAddress; // Selected address
  final bool isLoading; // Loading state
  final ValueChanged<String> onPostcodeChanged; // Callback for postcode input
  final ValueChanged<String> onPostcodeSubmitted; // Callback for postcode submission
  final ValueChanged<Map<String, dynamic>?> onAddressSelected; // Callback for address selection

  const CustomLocationWidget({
    super.key,
    required this.postcode,
    required this.addresses,
    required this.selectedAddress,
    required this.isLoading,
    required this.onPostcodeChanged,
    required this.onPostcodeSubmitted,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Please provide the property address",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        boxHeigth8,
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter postcode",
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.input,
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
          onChanged: onPostcodeChanged,
          onFieldSubmitted: onPostcodeSubmitted,
          initialValue: postcode, // Set initial value from parameter
        ),
        
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (addresses.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boxHeigth10,
              const Text(
                "Select an address:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              DropdownButton2<String>(
                underline: const SizedBox.shrink(),
                isDense: false,
                isExpanded: true,
                hint: Text(
                  selectedAddress?["line1"] != null
                      ? "${selectedAddress!["line1"]}, ${selectedAddress!["postalCode"]}"
                      : 'Select Address',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                value: selectedAddress?["address_key"],
                items: addresses.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["address_key"],
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.95,
                      ),
                      child: Text(
                        "${item["line1"]}, ${item["postalCode"]}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selected = addresses
                        .firstWhere((addr) => addr["address_key"] == value);
                    onAddressSelected(selected);
                  }
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: AppBorderRadius.input,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  elevation: 4,
                  offset: const Offset(0, -5),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                ),
              ),
            ],
          )
        else
          const SizedBox(),
      ],
    );
  }
}