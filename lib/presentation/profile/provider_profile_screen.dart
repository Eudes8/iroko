import 'package:flutter/material.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:iroko/domain/entities/user.dart';

class ProviderProfileScreen extends StatelessWidget {
  final Provider provider;

  const ProviderProfileScreen({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil du prestataire'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: AppTheme.primaryColor,
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: provider.profileImage != null
                            ? NetworkImage(provider.profileImage!)
                            : null,
                        child: provider.profileImage == null
                            ? Text(
                                provider.name.isNotEmpty
                                    ? provider.name[0].toUpperCase()
                                    : 'P',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: AppTheme.spacingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${provider.averageRating?.toStringAsFixed(1) ?? 'N/A'} (${provider.reviewCount ?? 0} avis)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (provider.isVerified)
                              Row(
                                children: const [
                                  Icon(Icons.verified, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Vérifié par IROKO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About
                  if (provider.bio != null) ...[
                    Text(
                      'À propos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      provider.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  // Specialties
                  if (provider.specialties != null &&
                      provider.specialties!.isNotEmpty) ...[
                    Text(
                      'Spécialités',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: AppTheme.spacingSmall,
                      runSpacing: AppTheme.spacingSmall,
                      children: [
                        for (final specialty in provider.specialties!)
                          Chip(
                            label: Text(specialty),
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            labelStyle: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  // Hourly Rate
                  if (provider.hourlyRate != null) ...[
                    Text(
                      'Tarif horaire',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      '${provider.hourlyRate?.toStringAsFixed(0) ?? 'N/A'} FCFA/heure',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  // Location
                  if (provider.location != null) ...[
                    Text(
                      'Localisation',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(provider.location!),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  // Certifications
                  if (provider.certifications != null &&
                      provider.certifications!.isNotEmpty) ...[
                    Text(
                      'Certifications',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    for (final cert in provider.certifications!)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppTheme.spacingSmall,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(cert)),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement booking/contact logic
                      },
                      child: const Text('Contacter le prestataire'),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSmall),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement view calendar
                      },
                      child: const Text('Voir les disponibilités'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
