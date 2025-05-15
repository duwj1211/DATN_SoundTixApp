import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/entity/booking.dart';

class OverViewChartWidget extends StatefulWidget {
  const OverViewChartWidget({super.key});

  @override
  State<OverViewChartWidget> createState() => _OverViewChartWidgetState();
}

class _OverViewChartWidgetState extends State<OverViewChartWidget> {
  List<Booking> bookings = [];
  List<double> monthlyRevenue = List.generate(12, (_) => 0.0);
  double maxRevenue = 0;

  @override
  void initState() {
    getListBookings();
    super.initState();
  }

  getListBookings() async {
    var rawData = await httpPost(context, "http://localhost:8080/booking/search", {});

    setState(() {
      bookings = [];

      for (var element in rawData["body"]["content"]) {
        var booking = Booking.fromMap(element);
        bookings.add(booking);
      }
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final monthlyRevenue = List.generate(12, (_) => 0.0);
    for (var item in bookings) {
      if (item.bookingStatus == "Paid") {
        final createAt = item.createAt;
        final month = createAt.month - 1;
        final totalPrice = item.totalPrice;
        monthlyRevenue[month] += totalPrice;
      }
    }
    final totalRevenue = monthlyRevenue.reduce((a, b) => a + b);
    final averageRevenue = totalRevenue / 12;
    final maxRevenue = monthlyRevenue.reduce((a, b) => a > b ? a : b) * 1.25;
    return Stack(
      children: [
        SizedBox(
          height: 325,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxRevenue,
              gridData: FlGridData(
                show: true,
                horizontalInterval: maxRevenue > 0 ? maxRevenue / 5 : 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey[200], strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: Colors.grey[200], strokeWidth: 1);
                },
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'Tháng ${group.x.toInt() + 1}\n',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: '${NumberFormat("#,###").format(rod.toY.toInt())},000 VNĐ'),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Tháng ${(value + 1).toInt()}', style: const TextStyle(fontSize: 16)));
                      },
                      reservedSize: 35),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(12, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: monthlyRevenue[index],
                      color: Colors.blueAccent,
                      width: 25,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Avg per month", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text("${NumberFormat("#,###").format(averageRevenue)},000 VNĐ",
                  style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
