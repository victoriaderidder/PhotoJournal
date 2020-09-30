import 'package:intl/intl.dart';

class Post {
  DateTime date;
  String imageURL;
  double latitude;
  double longitude;
  int quantity;

  Post() {
    this.quantity = 0;
  }

  String formatDate(DateTime dateToFormat) {
    return DateFormat('EEEE, MMM d, y').format(dateToFormat);
  }
}
