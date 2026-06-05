// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
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
      appBar: AppBar(
        title: const Text("Seller Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<SellerBloc, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const LoadingIndicator(message: 'Loading your stats...');
          } else if (state is SellerStatsLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(stats),
                  const SizedBox(height: 24),
                  _buildProfitSection(stats),
                  const SizedBox(height: 24),
                  const Text(
                    "Sales Overview (Weekly)",
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
                  _buildBestSellers(stats.bestSellingProducts),
                  const SizedBox(height: 40),
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

  Widget _buildSummaryCards(SellerStats stats) {
    return Row(
      children: [
        _buildStatCard("Total Sales", "\$${stats.totalSales}", Colors.green, Icons.attach_money),
        const SizedBox(width: 16),
        _buildStatCard("Orders", "${stats.totalOrders}", Colors.blue, Icons.shopping_basket),
      ],
    );
  }

  Widget _buildProfitSection(SellerStats stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Profit", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            "\$${stats.totalProfit}",
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorStats(CustomerBehavior behavior) {
    return Row(
      children: [
        _buildStatCard("Visits", "${behavior.visits}", Colors.orange, Icons.people),
        const SizedBox(width: 16),
        _buildStatCard(
          "Conv. Rate",
          "${((behavior.conversions / behavior.visits) * 100).toStringAsFixed(1)}%",
          Colors.purple,
          Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(List<double> dailySales) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
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
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellers(List bestSellingProducts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bestSellingProducts.length,
      itemBuilder: (context, index) {
        final product = bestSellingProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text("\$${product.price}"),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
