import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../controller/report_controller.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late ReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ReportController());
  }

  @override
  Widget build(BuildContext context) {
    ever(
      _controller.isLoading,
      (_) {
        if (_controller.isLoading.value) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: _controller.getAllTicket,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(),
                const SizedBox(height: 20),
                _buildTodayStats(),
                const SizedBox(height: 20),
                _buildBestSellingMovie(),
                const SizedBox(height: 20),
                _buildRevenueChart(),
                const SizedBox(height: 20),
                _buildMonthlyRevenueChart(),
                const SizedBox(height: 20),
                _buildRevenueTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      automaticallyImplyLeading: false,
      title: Text(
        'revenueReport'.tr,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        Row(
          children: [
            Obx(() => Text(
                  _controller.currentUser.value?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: const Icon(Icons.account_circle_sharp),
              onPressed: () => showAccountInfo(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Total Revenue'.tr,
          () => NumberFormat('#,###').format(_controller.revenue.value) + ' VND',
          Icons.attach_money,
          Colors.green,
        ),
        _buildSummaryCard(
          'Total Tickets'.tr,
          () => _controller.ticketCount.toString(),
          Icons.confirmation_number,
          AppColor.primary,
        ),
        _buildSummaryCard(
          'Average Ticket Price'.tr,
          () => NumberFormat('#,###').format(_controller.averageTicketPrice.value) + ' VND',
          Icons.analytics,
          Colors.orange,
        ),
        _buildSummaryCard(
          'Monthly Average'.tr,
          () {
            final monthlyAvg = _controller.monthlyRevenue.isEmpty
                ? 0.0
                : _controller.revenue.value / _controller.monthlyRevenue.length;
            return NumberFormat('#,###').format(monthlyAvg) + ' VND';
          },
          Icons.calendar_today,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
  String title,
  String Function() getValue,
  IconData icon,
  Color color,
) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12), // Giảm font size
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
                getValue(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    ),
  );
}

  Widget _buildTodayStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê thu nhập hôm nay '.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today Revenue'.tr),
                      Obx(() => Text(
                            NumberFormat('#,###').format(_controller.todayRevenue.value) +
                                ' VND',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today Tickets'.tr),
                      Obx(() => Text(
                            _controller.todayTicketCount.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellingMovie() {
    return Obx(() {
      if (_controller.bestSellingMovie.value.isEmpty) return const SizedBox.shrink();
      
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phim được xem nhiềunhiều'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.bestSellingMovie.value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.primary,
                ),
              ),
              Text(
                '${'Tickets'.tr}: ${_controller.bestSellingMovieCount}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Revenue'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_controller.revenueData.isEmpty) {
                return Center(child: Text("noRevenueDataAvailable".tr));
              }
              return PieChartWidget(data: _controller.revenueData);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Revenue'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_controller.monthlyRevenue.isEmpty) {
                return Center(child: Text("Không có doanh thu".tr));
              }
              return PieChartWidget(data: _controller.monthlyRevenue);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Revenue'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_controller.revenueData.isEmpty) {
                return Center(child: Text("noRevenueDataAvailable".tr));
              }
              return MovieRevenueTable(data: _controller.revenueData);
            }),
          ],
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: data,
      chartType: ChartType.ring,
      ringStrokeWidth: 40,
      chartRadius: MediaQuery.of(context).size.width / 2.5,
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
        showChartValueBackground: true,
      ),
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        legendTextStyle: TextStyle(fontSize: 12),
      ),
    );
  }
}

class MovieRevenueTable extends StatelessWidget {
  final Map<String, double> data;

  const MovieRevenueTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('movie'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('totalAmount'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: data.entries.map((entry) {
          return DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text(
              '${NumberFormat('#,###').format(entry.value)} VND',
            )),
          ]);
        }).toList(),
      ),
    );
  }
}

void showAccountInfo(BuildContext context) {
  final ReportController controller = Get.find<ReportController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "accountInfo".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${'name'.tr}: ${controller.currentUser.value?.name ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              "${'email'.tr}: ${controller.currentUser.value?.email ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRouterName.login);
                    },
                    child: Text(
                      "logOut".tr,
                      style: const TextStyle(color: AppColor.primary),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "close".tr,
                      style: const TextStyle(color: AppColor.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}