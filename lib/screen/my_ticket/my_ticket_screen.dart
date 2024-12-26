import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controller/my_ticket_controller.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  late MyTicketController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(MyTicketController());
    _controller.getTicketsByUserId();

    // Observe loading state
    _controller.isLoading.listen((isLoading) {
      if (isLoading) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text('myTicket'.tr, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return _controller.tickets.isEmpty
              ? Center(
                  child: Text(
                    'noTicketsAvailable'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _controller.tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _controller.tickets[index];
                    return TicketCard(ticket: ticket);
                  },
                );
        }),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRouterName.ticket, arguments: ticket);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // QR Code
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[200]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QrImageView(
                  data: ticket.id.toString(),
                  version: QrVersions.auto,
                  size: 80,
                ),
              ),
              const SizedBox(width: 16),

              // Ticket Detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.movieTitle ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'cinemaLocation'.tr}: ${ticket.cinemaLocation}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'showtime'.tr}: ${ticket.showtime}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${'seatNumber'.tr}: ${ticket.seatNumbers}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(ticket.purchaseDate!.toDate()),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
