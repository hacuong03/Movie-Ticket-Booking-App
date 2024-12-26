import 'package:flutter/material.dart';
import '../consts.dart';

class Cinema {
  final String name;
  final String distance;
  final String imageUrl;
  final String address;
  final double rating;

  Cinema({
    required this.name,
    required this.distance,
    required this.imageUrl,
    required this.address,
    required this.rating,
  });
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String selectedLocation = 'Vị trí của bạn';
  List<String> locations = [
    'Vị trí của bạn',
    'Quận Đống Đa',
    'Quận Thanh Xuân',
    'Quận Hoàn Kiếm',
  ];

  Map<String, List<Cinema>> cinemasPerDistrict = {
    'Vị trí của bạn': [
      Cinema(
        name: 'CGV Hàng Bột',
        distance: '3 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '54 Hàng Bột, Quận Đống Đa',
        rating: 4.5,
      ),
      Cinema(
        name: 'Galaxy Quang Trung',
        distance: '5 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '193 Quang Trung, Quận Hà Đông',
        rating: 4.2,
      ),
      Cinema(
        name: 'Lotte Cinema Vincom Nguyễn Chí Thanh',
        distance: '8 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '54 Nguyễn Chí Thanh, Quận Đống Đa',
        rating: 4.7,
      ),
    ],
    'Quận Đống Đa': [
      Cinema(
        name: 'CGV Hàng Bột',
        distance: '3 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '54 Hàng Bột, Quận Đống Đa',
        rating: 4.5,
      ),
      Cinema(
        name: 'Lotte Cinema Vincom Nguyễn Chí Thanh',
        distance: '5 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '54 Nguyễn Chí Thanh, Quận Đống Đa',
        rating: 4.2,
      ),// Thêm Rạp ở đây
    ],
    'Quận Thanh Xuân': [
      Cinema(
        name: 'Galaxy Quang Trung',
        distance: '3 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '193 Quang Trung, Quận Thanh Xuân',
        rating: 4.5,
      ),
      Cinema(
        name: 'CGV Vincom Times City',
        distance: '5 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '458 Minh Khai, Quận Hai Bà Trưng',
        rating: 4.2,
      ),
      // Thêm các rạp phim khác ở District 2
    ],
    'Quận Hoàn Kiếm': [
      Cinema(
        name: 'Lotte Cinema Vincom Bà Triệu',
        distance: '3 km away',
        imageUrl: 'YOUR_IMAGE_URL_HERE',
        address: '191 Bà Triệu, Quận Hoàn Kiếm',
        rating: 4.7,
      ),
      Cinema(
  name: 'BHD Star Cineplex Vincom Bà Triệu',
  distance: '4 km away',
  imageUrl: 'YOUR_IMAGE_URL_HERE',
  address: '191 Bà Triệu, Quận Hoàn Kiếm',
  rating: 4.5,
      ),
      // Thêm các rạp phim khác ở District 3
    ],
  };

  List<Cinema> filteredCinemas = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredCinemas();
  }

  void _updateFilteredCinemas() {
    filteredCinemas = cinemasPerDistrict[selectedLocation] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedLocation,
                isExpanded: true,
                dropdownColor: Colors.black87,
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: Container(),
                items: locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedLocation = newValue;
                      _updateFilteredCinemas();
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Filtered Cinemas
            const Text(
              'Nearby Cinemas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCinemas.length,
                itemBuilder: (context, index) {
                  return _buildCinemaCard(filteredCinemas[index], false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCinemaCard(Cinema cinema, bool isSaved) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Cinema Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.network(
              cinema.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie,
                    size: 50,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),

          // Cinema Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cinema.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cinema.address,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            cinema.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cinema.distance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.delete : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Xử lý lưu/xóa rạp phim
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Xử lý chuyển đến trang chi tiết
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}