import 'dart:io';
import 'package:FFinance/Controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:FFinance/Database/chart_data.dart';
import 'package:FFinance/Database/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:FFinance/Models/stock_data.dart';
import 'package:FFinance/View/navigator.dart';

class HalamanUtama extends StatelessWidget {
  final MainController controller = Get.put(MainController());
  final DatabaseHelper databaseHelper = DatabaseHelper();

  HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigator(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Portofolio', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    'Rp${controller.portfolioValue.value}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    'Imbal Hasil +Rp${controller.returnValue.value} (${controller.returnPercentage.value}%)',
                    style: const TextStyle(color: Colors.green),
                  )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuButton(
                          icon: Icons.card_giftcard, text: 'Academy', onTap: () {}),
                      _buildMenuButton(
                          icon: Icons.compare_arrows,
                          text: 'Share Send\nAnd Receive',
                          onTap: () {}),
                      _buildMenuButton(icon: Icons.wifi, text: 'Signals', onTap: () {}),
                      _buildMenuButton(icon: Icons.more_horiz_sharp, text: 'Lainnya', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBreakingNewsCarousel(context),
                  const SizedBox(height: 16),
                  _buildCashbackBanner(),
                  const SizedBox(height: 16),
                  _buildCategorySelector(),
                  const SizedBox(height: 16),
                  const Text('List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ...chartData.map((data) => _buildListCard(data)),

                  const SizedBox(height: 16),
                  _buildAddAssetButton(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }

  Widget _buildMenuButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBreakingNewsCarousel(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CardSwiper(
        cardsCount: 3,
        cardBuilder: (context, index, realIndex, direction) {
          return GestureDetector(
            onTap: () => _showFullTextDialog(context, 'This is breaking news detail for item $index.'),
            child: Card(
              child: Center(child: Text('Breaking News $index')),
            ),
          );
        },
      ),
    );
  }

  void _showFullTextDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Breaking News'),
        content: SingleChildScrollView(
          child: Text(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildCashbackBanner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Icon(Icons.card_giftcard, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Save Up to 50% off!!!',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['Kategori 1', 'Kategori 2', 'Kategori 3', 'Kategori 4', 'Kategori 5'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index < categories.length) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                label: Text(categories[index]),
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildListCard(ChartData data) {
    Color lineColor = data.change > 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                data.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.symbol,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${data.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data.change}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: lineColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              height: 60,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(isVisible: false),
                primaryYAxis: const NumericAxis(isVisible: false),
                series: [
                  LineSeries<StockData, String>(
                    dataSource: data.stockHistory,
                    xValueMapper: (StockData stockData, _) => stockData.time,
                    yValueMapper: (StockData stockData, _) => stockData.price,
                    color: lineColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAssetButton() {
    return GestureDetector(
      onTap: () {
        print("Add Asset tapped");
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_sharp, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Tambahkan Asset',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
