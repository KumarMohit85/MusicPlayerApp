// ignore_for_file: public_member_api_docs, sort_constructors_first
class Failure {
  final String message;

  Failure([this.message = 'Sorry an unexpected error occured']);

  @override
  String toString() => 'Failure(message: $message)';
}
