import 'package:flutter/material.dart';
import 'package:iroko/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IROKO'),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Soutien Scolaire'),
              Tab(text: 'Recrutement'),
              Tab(text: 'Entretien'),
            ],
            onTap: (index) {
              // Tab switching is handled by TabController
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTutoringTab(),
            _buildRecruitmentTab(),
            _buildMaintenanceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Chercher un tuteur...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.tune),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Mathématiques'),
                const SizedBox(width: AppTheme.spacingSmall),
                _buildFilterChip('3ème'),
                const SizedBox(width: AppTheme.spacingSmall),
                _buildFilterChip('Abidjan'),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          // Tutors List
          Text(
            'Tuteurs disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          ...[1, 2, 3].map((i) => _buildTutorCard(context, i)),
        ],
      ),
    );
  }

  Widget _buildRecruitmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Chercher une offre d\'emploi...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          Text(
            'Offres d\'emploi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          ...[1, 2, 3].map((i) => _buildJobCard(context, i)),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Chercher un service d\'entretien...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          Text(
            'Services disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          ...[1, 2, 3].map((i) => _buildServiceCard(context, i)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      onDeleted: () {},
      backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
      labelStyle: const TextStyle(color: AppTheme.primaryColor),
    );
  }

  Widget _buildTutorCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    'T$index',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tuteur IROKO $index',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Mathématiques • 3ème',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                const Text('4.5'),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Tarif: 5000 FCFA/heure',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to tutor detail
                },
                child: const Text('Voir les disponibilités'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recherche Ménagère • Daloa',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Expérience: Cuisine Ivoirienne, Discrétion',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to job detail
                },
                child: const Text('Postuler'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor,
                  child: Icon(Icons.cleaning_services, color: Colors.white),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Ménage $index',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '3 heures • Disponible',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Tarif: 15000 FCFA',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to service detail
                },
                child: const Text('Réserver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
