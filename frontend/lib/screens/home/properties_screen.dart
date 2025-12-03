import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../models/property.dart';
import '../../utils/theme.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heaven\'s Door'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<PropertyProvider>(
                      context,
                      listen: false,
                    ).fetchProperties();
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Provider.of<PropertyProvider>(
                    context,
                    listen: false,
                  ).searchProperties(value);
                }
              },
            ),
          ),
          // Properties list
          Expanded(
            child: Consumer<PropertyProvider>(
              builder: (context, propertyProvider, child) {
                if (propertyProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (propertyProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 64,
                          color: JoJoTheme.menacing,
                        ),
                        const SizedBox(height: 16),
                        Text(propertyProvider.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            propertyProvider.fetchProperties();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (propertyProvider.properties.isEmpty) {
                  return const Center(child: Text('No properties found'));
                }

                return RefreshIndicator(
                  onRefresh: () => propertyProvider.fetchProperties(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: propertyProvider.properties.length,
                    itemBuilder: (context, index) {
                      final property = propertyProvider.properties[index];
                      return PropertyCard(property: property);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create property screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to property details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: property.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: property.images.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.home, size: 64),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 64),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          final isFav = favoriteProvider.isFavorite(
                            property.id,
                          );
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? JoJoTheme.menacing : null,
                            ),
                            onPressed: () {
                              favoriteProvider.toggleFavorite(
                                property.id,
                                isFav,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.priceFormatted,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: JoJoTheme.standPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: JoJoTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.city}, ${property.country}',
                          style: const TextStyle(
                            color: JoJoTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (property.bedrooms != null) ...[
                        const Icon(Icons.bed, size: 16),
                        const SizedBox(width: 4),
                        Text('${property.bedrooms} beds'),
                        const SizedBox(width: 16),
                      ],
                      if (property.bathrooms != null) ...[
                        const Icon(Icons.bathroom, size: 16),
                        const SizedBox(width: 4),
                        Text('${property.bathrooms} baths'),
                        const SizedBox(width: 16),
                      ],
                      if (property.areaSqft != null) ...[
                        const Icon(Icons.square_foot, size: 16),
                        const SizedBox(width: 4),
                        Text('${property.areaSqft} sqft'),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(property.listingType.toUpperCase()),
                    backgroundColor: property.listingType == 'sale'
                        ? JoJoTheme.emeraldGreen.withOpacity(0.2)
                        : JoJoTheme.starPlatinum.withOpacity(0.2),
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
