abstract class AppException implements Exception {
  final String message;

  AppException({required this.message});
}

class BadRequestException extends AppException {
  BadRequestException() : super(message: 'Bad request');
}

class InternetException extends AppException {
  InternetException({super.message = 'No Internet connection available'});
}

class CustomException extends AppException {
  CustomException({required super.message});
}
