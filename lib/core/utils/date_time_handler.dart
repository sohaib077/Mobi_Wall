import 'package:intl/intl.dart';


class DateTimeHandler {
  static String toDay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }

  static String toMonth(DateTime dateTime) {
    return DateFormat('MMM').format(dateTime);
  }

  static String toYear(DateTime dateTime) {
    return DateFormat('yyyy').format(dateTime);
  }

  static String toDate(DateTime dateTime) {
    return DateFormat('d').format(dateTime);
  }

  static String toDateMonth(DateTime dateTime) {
    return DateFormat('d MMM').format(dateTime);
  }

  static String toDayDateMonth(DateTime dateTime) {
    return DateFormat('EEEE, d MMM ').format(dateTime);
  }

  static String toDateFormat(DateTime dateTime) {
    return DateFormat('EEEE, d MMM, yyyy ').format(dateTime);
  }

  static String toDateTimeFormat(DateTime dateTime) {
    return DateFormat('EEEE,d MMM  h : mm a')
        .format(dateTime);
    // return DateFormat('EEEE,d MMM,yyyy ...  mm : h a')
    //     .format(dateTime);
  }

  // prints in this format: yyyy/mm/dd
  static String toDateFormat2(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  // prints in this format: hh:mm:ss
  static String toTimeFormat(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  static String toTimeFormat2(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }
}

/*
print(date.toString()); 						// prints something like 2019-12-10 10:02:22.287949
print(DateFormat('EEEE').format(date)); 				// prints Tuesday
print(DateFormat('EEEE, d MMM, yyyy').format(date)); 		// prints Tuesday, 10 Dec, 2019
print(DateFormat('h:mm a').format(date)); 			// prints 10:02 AM
 */
