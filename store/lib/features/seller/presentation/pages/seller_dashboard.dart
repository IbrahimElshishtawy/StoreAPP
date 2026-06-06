// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<SellerBloc>().add(GetSellerStatsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Dashboard")),
      body: BlocBuilder<SellerBloc, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SellerStatsLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(stats),
                  const SizedBox(height: 24),
                  const Text(
                    "Sales Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSalesChart(stats.dailySales),
                  const SizedBox(height: 24),
                  const Text(
                    "Customer Behavior",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBehaviorStats(stats.behavior),
                  const SizedBox(height: 24),
                  const Text(
                    "Best Selling Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBestSellingProducts(stats.bestSellingProducts),
                ],
              ),
            );
          } else if (state is SellerError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No stats available"));
        },
      ),
    );
  }

  Widget _buildSummaryCards(SellerStats stats) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard("Total Sales", "\$${stats.totalSales}", Colors.green),
            const SizedBox(width: 16),
            _buildStatCard("Total Profit", "\$${stats.totalProfit}", Colors.teal),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard("Orders", "${stats.totalOrders}", Colors.blue),
            const SizedBox(width: 16),
            _buildStatCard(
              "Conversion",
              "${((stats.behavior.conversions / stats.behavior.visits) * 100).toStringAsFixed(1)}%",
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBehaviorStats(CustomerBehavior behavior) {
    return Row(
      children: [
        _buildStatCard("Visits", "${behavior.visits}", Colors.orange),
        const SizedBox(width: 16),
        _buildStatCard(
          "Purchases",
          "${behavior.conversions}",
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellingProducts(List<ProductEntity> products) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalesChart(List<double> dailySales) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: dailySales
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
