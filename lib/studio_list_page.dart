import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studio_provider.dart'; // Import the StudioProvider
import 'studio_info_page.dart'; // Import the StudioInfoPage

class StudioListPage extends StatefulWidget {
  const StudioListPage({Key? key}) : super(key: key);

  @override
  _StudioListPageState createState() => _StudioListPageState();
}

class _StudioListPageState extends State<StudioListPage> {
  String searchQuery = '';
  String selectedStyle = 'All';

  @override
  Widget build(BuildContext context) {
    final studioProvider = Provider.of<StudioProvider>(context);

    if (studioProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredStudios = studioProvider.studios.where((studio) {
      final nameMatch = studio.name.toLowerCase().contains(searchQuery.toLowerCase());
      final styleMatch = selectedStyle == 'All' || studio.style == selectedStyle;
      return nameMatch && styleMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dance Studios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter studio name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedStyle,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Styles')),
                DropdownMenuItem(value: 'Ballet', child: Text('Ballet')),
                DropdownMenuItem(value: 'Hip-Hop', child: Text('Hip-Hop')),
                DropdownMenuItem(value: 'Salsa', child: Text('Salsa')),
                DropdownMenuItem(value: 'Contemporary', child: Text('Contemporary')),
                DropdownMenuItem(value: 'Jazz', child: Text('Jazz')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStyle = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudios.length,
              itemBuilder: (context, index) {
                final studio = filteredStudios[index];
                return ListTile(
                  title: Text(studio.name),
                  subtitle: Text(studio.address),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudioInfoPage(
                          name: studio.name,
                          address: studio.address,
                          description: studio.description,
                          style: studio.style,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}