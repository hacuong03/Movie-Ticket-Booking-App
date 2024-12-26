import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_movie.dart';
import 'package:movie_ticket/utils/firebase/firebase_user.dart';

class MovieController extends GetxController {
  final MovieService _movieService = MovieService();
  final UserService _useService = UserService();
  List<MovieModel> movieData = <MovieModel>[].obs;
  RxList<String> imageCarousels =
      <String>["https://i.ytimg.com/vi/ITlQ0oU7tDA/maxresdefault.jpg","https://www.teatrozancanaro.it/wp-content/uploads/2024/10/venom.jpg","https://www.themoviedb.org/t/p/w600_and_h900_bestv2/7wDamUqLh6WIZ5XeOaeN58c7Esf.jpg","https://www.themoviedb.org/t/p/w600_and_h900_bestv2/12WjXqJp9LFrXdyScDLkT5BMBcn.jpg","https://www.themoviedb.org/t/p/w600_and_h900_bestv2/sjMN7DRi4sGiledsmllEw5HJjPy.jpg","https://www.themoviedb.org/t/p/w600_and_h900_bestv2/8fAo9UwsmQPTqJyi9vpQZsJ2XOh.jpg"].obs;
  RxBool isLoading = false.obs;
  RxInt index = 1.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  get hotMovies => null;

  get nowShowingMovies => null;

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
    //   id: "GMx1kMlfVX4kJscJfIDF",
    //   title: "Sonic 3",
    //   description:
    //       "Sau khi Ông già Noel bị bắt cóc, Trưởng An ninh Bắc Cực (Dwayne Johnson) phải hợp tác với thợ săn tiền thưởng khét tiếng nhất thế giới (Chris Evans) trong một nhiệm vụ kịch tính xuyên lục địa để giải cứu Giáng Sinh.",
    //   imageUrl:
    //       "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/zRgxYzRu4s8smKMskdfMA2hOzyN.jpg",
    //   premiereDate: Timestamp(100, 20),
    //   genre: "Hành động, Kịch tính",
    //   country: "Mỹ",
    //   trailerUrl:
    //       "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/zRgxYzRu4s8smKMskdfMA2hOzyN.jpg",
    //   rating: 4.2,
    //   imageGallery: [
    //     'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/zRgxYzRu4s8smKMskdfMA2hOzyN.jpg'
    //   ],
    //   durationMinutes: 100,
    //   price: 66000.0,
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

  void signOut() {}
}
