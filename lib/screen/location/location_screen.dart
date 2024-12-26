import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/config/color/color.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String selectedDistrict = 'Địa điểm';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa điểm'.tr, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn địa điểm'.tr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dropdown to select district with search functionality
            DropdownButton<String>(
              value: selectedDistrict,
              onChanged: (String? newDistrict) {
                setState(() {
                  selectedDistrict = newDistrict!;
                });
              },
              items: locationGroups.keys.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Search Bar for filtering location names
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a cinema...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),

            // Expanded list with filtered locations
            Expanded(
              child: ListView(
                children: _getFilteredLocations().map((location) {
                  return _buildLocationGroup(location);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a location card
  Widget _buildLocationGroup(String location) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: AppColor.primary),
        title: Text(location),
        subtitle: const Text('Tap to select this location'),
        onTap: () {
          _showLocationDetails(location);
        },
      ),
    );
  }

  // Function to filter locations based on search query
  List<String> _getFilteredLocations() {
    String searchQuery = searchController.text.toLowerCase();
    List<String> locations = locationGroups[selectedDistrict]!;

    if (searchQuery.isEmpty) {
      return locations;
    } else {
      return locations.where((location) {
        return location.toLowerCase().contains(searchQuery);
      }).toList();
    }
  }

  // Function to show details of the selected location
  void _showLocationDetails(String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location),
          content: SingleChildScrollView( // Wrap in SingleChildScrollView to avoid overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLocationDetailField('Rạp Phim', location),
                _buildLocationDetailField('Địa chỉ', '123 Example St, Hanoi'),
                _buildLocationDetailField('Số điện thoại', '0123456789'),
                _buildLocationDetailField('Giờ mở cửa', '9:00 AM - 11:00 PM'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar('Location Selected', location,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColor.primary,
                        colorText: Colors.white);
                    Navigator.pop(context);
                  },
                  child: Text('Chọn địa điểm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to build each location detail field
  Widget _buildLocationDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// Sample grouped location data with real cinemas in Hanoi
final Map<String, List<String>> locationGroups = {
  "Địa điểm": [
    "CGV Vincom Bà Triệu",
    "Lotte Cinema Hanoi",
    "BHD Star Cineplex",
  ],
  "Quận Đống Đa": [
    "CineStar - Aeon Mall Long Biên",
    "Galaxy Nguyễn Du",
  ],
  "Quận Hà Đông": [
    "CGV Aeon Mall Hà Đông",
    "Lotte Cinema Thanh Xuân",
  ],
  "Quận Hoàn Kiếm": [
    "CineStar - Times City",
    "BHD Star Cineplex - Royal City",
  ],
  "Quận Long Biên": [
    "Galaxy Cinema - Trung Hòa",
    "CGV Láng Hạ",
  ],
  "Quận Cầu Giấy": [
    "CGV Láng Hạ",
    "Lotte Cinema Đống Đa",
    "BHD Star Cineplex",
  ],
};
