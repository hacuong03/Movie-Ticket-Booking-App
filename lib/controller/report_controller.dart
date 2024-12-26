import 'package:get/get.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/firebase/firebase_ticket.dart';
import 'package:movie_ticket/utils/firebase/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportController extends GetxController {
  final TicketService _ticketService = TicketService();
  final UserService _useService = UserService();
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  List<TicketModel> tickets = <TicketModel>[].obs;
  RxBool isLoading = true.obs;
  RxDouble revenue = 0.0.obs;
  var revenueData = <String, double>{}.obs;
  RxInt ticketCount = 0.obs;
  RxString loadingMessage = ''.obs;

  // Thêm các biến mới cho phân tích
  var monthlyRevenue = <String, double>{}.obs;
  var dailyRevenue = <String, double>{}.obs;
  RxDouble averageTicketPrice = 0.0.obs;
  RxInt todayTicketCount = 0.obs;
  RxDouble todayRevenue = 0.0.obs;
  RxString bestSellingMovie = ''.obs;
  RxInt bestSellingMovieCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
    getUserByUserId();
    getAllTicket();
  }

  Future<void> getUserByUserId() async {
    try {
      isLoading.value = true;
      loadingMessage.value = 'Đang tải thông tin người dùng...';
      final userId = Get.find<FirebaseAuth>().currentUser?.uid;
      currentUser.value = await _useService.getUserByUserId(userId ?? "");
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông tin người dùng.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllTicket() async {
    try {
      isLoading.value = true;
      loadingMessage.value = 'Đang tải danh sách vé...';
      final result = await _ticketService.getAllTicket();

      tickets.assignAll(result);
      ticketCount.value = tickets.length;

      // Tính tổng doanh thu
      revenue.value = tickets.fold(0.0, (sum, ticket) => sum + (ticket.amount ?? 0));

      // Tạo bản đồ doanh thu theo từng phim
      Map<String, double> tempRevenueData = {};
      for (var ticket in tickets) {
        final movieTitle = ticket.movieTitle ?? 'Unknown';
        final ticketAmount = ticket.amount ?? 0.0;

        tempRevenueData[movieTitle] = (tempRevenueData[movieTitle] ?? 0) + ticketAmount;
      }
      revenueData.assignAll(tempRevenueData);

      // Phân tích thêm
      _analyzeTicketData(result);

      loadingMessage.value = 'Tải xong!';
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách vé.');
    } finally {
      isLoading.value = false;
    }
  }

  void _analyzeTicketData(List<TicketModel> tickets) {
    // Phân tích doanh thu theo tháng
    Map<String, double> tempMonthlyRevenue = {};
    Map<String, double> tempDailyRevenue = {};
    Map<String, int> movieTicketCount = {};
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    double todayRev = 0.0;
    int todayCount = 0;

    for (var ticket in tickets) {
      if (ticket.createdAt == null) continue;

      // Định dạng tháng
      final monthKey = '${ticket.createdAt!.month}/${ticket.createdAt!.year}';
      tempMonthlyRevenue[monthKey] = (tempMonthlyRevenue[monthKey] ?? 0) + (ticket.amount ?? 0);

      // Định dạng ngày
      final dayKey = '${ticket.createdAt!.day}/${ticket.createdAt!.month}';
      tempDailyRevenue[dayKey] = (tempDailyRevenue[dayKey] ?? 0) + (ticket.amount ?? 0);

      // Đếm vé theo phim
      final movieTitle = ticket.movieTitle ?? 'Unknown';
      movieTicketCount[movieTitle] = (movieTicketCount[movieTitle] ?? 0) + 1;

      // Tính doanh thu và số vé hôm nay
      final ticketDate = DateTime(
        ticket.createdAt!.year,
        ticket.createdAt!.month,
        ticket.createdAt!.day,
      );
      
      if (ticketDate.isAtSameMomentAs(today)) {
        todayRev += ticket.amount ?? 0;
        todayCount++;
      }
    }

    // Cập nhật các giá trị
    monthlyRevenue.assignAll(tempMonthlyRevenue);
    dailyRevenue.assignAll(tempDailyRevenue);
    averageTicketPrice.value = tickets.isEmpty ? 0 : revenue.value / tickets.length;
    todayRevenue.value = todayRev;
    todayTicketCount.value = todayCount;

    // Tìm phim bán chạy nhất
    if (movieTicketCount.isNotEmpty) {
      var maxEntry = movieTicketCount.entries.reduce(
        (a, b) => a.value > b.value ? a : b
      );
      bestSellingMovie.value = maxEntry.key;
      bestSellingMovieCount.value = maxEntry.value;
    }
  }

  // Hàm tiện ích để lấy doanh thu trong khoảng thời gian
  double getRevenueInRange(DateTime start, DateTime end) {
    return tickets.where((ticket) {
      if (ticket.createdAt == null) return false;
      return ticket.createdAt!.isAfter(start) && 
             ticket.createdAt!.isBefore(end);
    }).fold(0.0, (sum, ticket) => sum + (ticket.amount ?? 0));
  }

  // Hàm lấy số vé trong khoảng thời gian
  int getTicketCountInRange(DateTime start, DateTime end) {
    return tickets.where((ticket) {
      if (ticket.createdAt == null) return false;
      return ticket.createdAt!.isAfter(start) && 
             ticket.createdAt!.isBefore(end);
    }).length;
  }

  // Hàm lấy top phim theo doanh thu
  List<MapEntry<String, double>> getTopMoviesByRevenue(int limit) {
    return revenueData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(limit);
  }
}