import 'package:test/test.dart';
import 'package:wasteagram/models/posts.dart';
import 'package:intl/intl.dart';

void main() {
  test('Post should be successfully created', () {
    DateTime testDate = DateTime.now();
    String testURL = "NOIMAGEHERE.jpg";
    double testLatitude = 1.0;
    double testLongitude = 2.0;
    int testQuantity = 5;

    Post post = Post();

    post.date = testDate;
    post.imageURL = testURL;
    post.latitude = testLatitude;
    post.longitude = testLongitude;
    post.quantity = testQuantity;

    expect(post.date, testDate);
    expect(post.imageURL, testURL);
    expect(post.latitude, testLatitude);
    expect(post.longitude, testLongitude);
    expect(post.quantity, testQuantity);
  });

  test('FormatDate function should format the date', () {
    Post post = Post();
    DateTime testDate = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d, y').format(testDate);

    expect(post.formatDate(testDate), formattedDate);
  });
}
