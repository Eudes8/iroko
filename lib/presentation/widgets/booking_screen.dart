import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:iroko/presentation/providers/mission_provider.dart';

class BookingScreen extends StatefulWidget {
  final String missionId;

  const BookingScreen({
    Key? key,
    required this.missionId,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  int _durationHours = 1;
  double _hourlyRate = 5000;
  double _totalPrice = 5000;
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _startTime = const TimeOfDay(hour: 9, minute: 0);
    _endTime = const TimeOfDay(hour: 10, minute: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissionProvider>().getMissionById(widget.missionId);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = _hourlyRate * _durationHours;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver une mission'),
        elevation: 0,
      ),
      body: Consumer<MissionProvider>(
        builder: (context, missionProvider, _) {
          if (missionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final mission = missionProvider.selectedMission;
          if (mission == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Mission non trouvée'),
                  const SizedBox(height: AppTheme.spacingMedium),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          mission.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                // Price Summary
                Card(
                  color: AppTheme.grey100,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Prix'),
                            Text('${mission.price.toStringAsFixed(0)} FCFA'),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Commission (15%)'),
                            Text(
                              '${(mission.price * 0.15).toStringAsFixed(0)} FCFA',
                            ),
                          ],
                        ),
                        const Divider(color: AppTheme.grey300, height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(mission.price + (mission.price * 0.15)).toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                // Booking Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Réservation en cours...')),
                      );
                    },
                    child: const Text('Procéder au paiement'),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
