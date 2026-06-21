// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';
import 'package:store/presentation/widgets/common_ui.dart';

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
            return const LoadingIndicator();
          } else if (state is SellerStatsLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryGrid(stats),
                  const SizedBox(height: 24),
                  const Text(
                    "Sales Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSalesChart(stats.dailySales),
                  const SizedBox(height: 24),
                  const Text(
                    "Best Selling Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBestSellingProducts(stats),
                  const SizedBox(height: 24),
                  const Text(
                    "Customer Behavior",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBehaviorStats(stats.behavior),
                ],
              ),
            );
          } else if (state is SellerError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<SellerBloc>().add(GetSellerStatsRequested()),
            );
          }
          return const EmptyState(message: "No stats available");
        },
      ),
    );
  }

  Widget _buildSummaryGrid(SellerStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard("Total Sales", "\$${stats.totalSales}", Colors.green),
        _buildStatCard("Total Profit", "\$${stats.totalProfit}", Colors.teal),
        _buildStatCard("Orders", "${stats.totalOrders}", Colors.blue),
        _buildStatCard("Visits", "${stats.behavior.visits}", Colors.orange),
      ],
    );
  }

  Widget _buildBestSellingProducts(SellerStats stats) {
    return Column(
      children: stats.bestSellingProducts.map((product) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(product.image)),
            title: Text(product.title),
            subtitle: Text('\$${product.price}'),
            trailing: const Icon(Icons.trending_up, color: Colors.green),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBehaviorStats(CustomerBehavior behavior) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBehaviorItem("Conversions", "${behavior.conversions}"),
          _buildBehaviorItem(
            "Conv. Rate",
            "${((behavior.conversions / behavior.visits) * 100).toStringAsFixed(1)}%",
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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
