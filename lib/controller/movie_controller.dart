import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_movie.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/utils/firebase/firebase_user.dart';

class MovieController extends GetxController {
  final MovieService _movieService = MovieService();
  final UserService _useService = UserService();
  List<MovieModel> movieData = <MovieModel>[].obs;
  RxList<String> imageCarousels =
      <String>["https://i.ytimg.com/vi/ITlQ0oU7tDA/maxresdefault.jpg"].obs;
  RxBool isLoading = false.obs;
  RxInt index = 1.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
    getUserByUserId();
  }

  @override
  void onReady() async {
    await getData();
  }

  Future<void> getUserByUserId() async {
    isLoading.value = true;
    final userId = Get.find<FirebaseAuth>().currentUser?.uid;
    currentUser.value = await _useService.getUserByUserId(userId ?? "");
    isLoading.value = false;
  }

  Future<void> getData() async {
    isLoading.value = true;

    // addMovies(
    //   id: "9UZVs6m20chcpCKjeR0M",
    //   title: "Mắc biếc",
    //   description:
    //       "ĐaĐi qua những đau khổ và phản bội, mối tình đơn phương của Ngạn dành cho cô bạn thân thời thơ ấu Hà Lan kéo dài cả một thế hệ trong bộ phim siêu lãng mạn này.",
    //   imageUrl: "https://i.ytimg.com/vi/ITlQ0oU7tDA/maxresdefault.jpg",
    //   premiereDate: Timestamp(100, 20),
    //   genre: "tình cảm",
    //   country: "Viet Nam",
    //   trailerUrl:
    //       "https://i.ytimg.com/vi/ITlQ0oU7tDA/hq720.jpg?sqp=-oaymwEnCNAFEJQDSFryq4qpAxkIARUAAIhCGAHYAQHiAQoIGBACGAY4AUAB&rs=AOn4CLBmfGxTuPODmT4LVwqSha__BY91PQ",
    //   rating: 4.7,
    //   imageGallery: ['https://i.ytimg.com/vi/ITlQ0oU7tDA/maxresdefault.jpg'],
    //   durationMinutes: 120,
    //   price: 75000.0,
    // );
    final futures = [
      getImageCarousels(),
      getAndFilterMovies(""),
    ];

    await Future.wait(futures);

    isLoading.value = false;
  }

  Future<void> getImageCarousels() async {
    // final ListResult result =
    //     await FirebaseStorage.instance.ref('carousel').listAll();
    // imageCarousels.clear();

    // for (var ref in result.items) {
    //   String downloadURL = await ref.getDownloadURL();
    //   imageCarousels.add(downloadURL);
    // }
  }

  Future<void> getAndFilterMovies(String search) async {
    List<MovieModel> result = await _movieService.getAllMovies();

    movieData.assignAll(result);

    // Filter movie with search
    if (search.isNotEmpty) {
      List<MovieModel> filteredList = List.from(movieData.where((movie) =>
          movie.title?.toLowerCase().contains(search.toLowerCase()) ?? false));

      movieData.assignAll(filteredList);
    }
  }

  Future<void> addMovies({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required Timestamp premiereDate,
    required String genre,
    required String country,
    required String trailerUrl,
    required double rating,
    required List<String> imageGallery,
    required int durationMinutes,
    required double price,
  }) async {
    isLoading.value = true;

    final MovieModel movie = MovieModel(
        id,
        title,
        description,
        imageUrl,
        premiereDate,
        genre,
        country,
        trailerUrl,
        rating,
        imageGallery,
        durationMinutes,
        price);

    String resultAdd = await _movieService.addMovie(movie);
    if (resultAdd.isNotEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.error,
          message: resultAdd,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.success,
          message: CommonMessage.addMovieSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    isLoading.value = false;
  }
}
