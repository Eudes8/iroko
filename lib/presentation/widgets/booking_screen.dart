import 'package:flutter/material.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String? providerId;
  final String serviceType;
  final String title;

  const BookingScreen({
    Key? key,
    this.providerId,
    required this.serviceType,
    required this.title,
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

  void _updateDuration() {
    if (_endTime.hour > _startTime.hour ||
        (_endTime.hour == _startTime.hour &&
            _endTime.minute >= _startTime.minute)) {
      final duration = (_endTime.hour - _startTime.hour) * 60 +
          (_endTime.minute - _startTime.minute);
      setState(() {
        _durationHours = (duration / 60).ceil();
      });
      _updateTotalPrice();
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectTime(bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(
        () {
          if (isStartTime) {
            _startTime = picked;
          } else {
            _endTime = picked;
          }
        },
      );
      _updateDuration();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver une mission'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      widget.serviceType,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Date Selection
            Text(
              'Date et heure',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            ListTile(
              onTap: _selectDate,
              title: const Text('Date'),
              subtitle: Text(dateFormat.format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              tileColor: AppTheme.grey100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () => _selectTime(true),
                    title: const Text('Début'),
                    subtitle: Text(_startTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    tileColor: AppTheme.grey100,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: ListTile(
                    onTap: () => _selectTime(false),
                    title: const Text('Fin'),
                    subtitle: Text(_endTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    tileColor: AppTheme.grey100,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Duration Info
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.grey300),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Durée',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '$_durationHours heure${_durationHours > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tarif/heure',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${_hourlyRate.toStringAsFixed(0)} FCFA',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Description
            Text(
              'Description (optionnel)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Expliquez les détails de votre demande...',
                border: OutlineInputBorder(),
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
                        const Text('Sous-total'),
                        Text('${_totalPrice.toStringAsFixed(0)} FCFA'),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Commission IROKO (15%)'),
                        Text(
                          '${(_totalPrice * 0.15).toStringAsFixed(0)} FCFA',
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
                          '${(_totalPrice + (_totalPrice * 0.15)).toStringAsFixed(0)} FCFA',
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
                  // TODO: Implement booking logic
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
      ),
    );
  }
}
