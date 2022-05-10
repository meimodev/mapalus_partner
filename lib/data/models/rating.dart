import 'package:jiffy/jiffy.dart';
import 'package:mapalus_partner/shared/values.dart';

class Rating {
  int number;
  String message;
  final String _ratingTimeStamp;

  Rating(
    this.number,
    this.message,
    Jiffy ratingTimeStamp,
  ) : _ratingTimeStamp = ratingTimeStamp.format(Values.formatRawDate);

  Jiffy get ratingTimeStamp {
    return Jiffy(_ratingTimeStamp, Values.formatRawDate);
  }

  Rating.empty()
      : number = 0,
        message = '',
        _ratingTimeStamp = '';

  Rating.fromMap(Map<String, dynamic> data)
      : number = data["number"],
        message = data["message"],
        _ratingTimeStamp = data["rate_time_stamp"];

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "message": message,
      "rate_time_stamp": _ratingTimeStamp,
    };
  }
}