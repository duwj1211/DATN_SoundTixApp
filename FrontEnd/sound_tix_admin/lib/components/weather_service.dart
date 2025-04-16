import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _location = '';
  String _temperature = '';
  String _conditionIcon = '';
  DateTime _dateTime = DateTime.now();
  bool _isLoading = false;

  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _location = "Hanoi";
    _getWeather();
  }

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherData = await _weatherService.getWeather(_location);
      setState(() {
        _temperature = '${weatherData['current']['temp_c']}°';
        _conditionIcon = 'https:${weatherData['current']['condition']['icon']}';
        _dateTime = DateTime.now();
      });
    } catch (e) {
      setState(() {
        _temperature = 'Lỗi khi lấy dữ liệu.';
        _dateTime = DateTime.now();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _location.toUpperCase(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEE d MMMM, yyyy').format(_dateTime),
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Image.network(_conditionIcon, width: 42, height: 42),
                      const SizedBox(width: 5),
                      Text(
                        _temperature,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class WeatherService {
  final String apiKey = 'cb888a2a533a4f1eab433904241211';
  final String baseUrl = 'https://api.weatherapi.com/v1/current.json';

  Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?key=$apiKey&q=$city'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Không thể lấy dữ liệu thời tiết. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối hoặc dữ liệu không hợp lệ.');
    }
  }
}
