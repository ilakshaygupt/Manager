import 'package:flutter_dotenv/flutter_dotenv.dart';

String? apiUrl;

Future<void> loadEnv() async {
  await dotenv.load(fileName: ".env");
  apiUrl = dotenv.env['API_URL'];
}
