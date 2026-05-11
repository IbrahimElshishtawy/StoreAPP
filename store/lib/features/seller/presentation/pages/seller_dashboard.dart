import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
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
      appBar: AppBar(title: const Text('Seller Dashboard')),
      body: BlocBuilder<SellerBloc, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SellerStatsLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard('Total Sales', '\$${stats['totalSales']}'),
                  _buildStatCard('Orders', '${stats['ordersCount']}'),
                  _buildStatCard('Top Product', stats['topProduct']),
                  const SizedBox(height: 24),
                  const Text('Sales Over Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: (stats['salesData'] as List<double>)
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SellerError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
