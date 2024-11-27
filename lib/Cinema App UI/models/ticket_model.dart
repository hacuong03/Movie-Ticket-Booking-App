// ticket_model.dart
class Ticket {
  final String movieTitle;
  final String cinemaName;
  final String date;
  final String time;
  final String seatNumber;
  final double price;
  final String bookingId;

  Ticket({
    required this.movieTitle,
    required this.cinemaName,
    required this.date,
    required this.time,
    required this.seatNumber,
    required this.price,
    required this.bookingId,
  });
}