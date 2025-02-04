import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mimiqit/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(DanceStudioApp());
}


class DanceStudioApp extends StatelessWidget {
  const DanceStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dance Studio Finder',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const StudioListPage(),
    );
  }
}
class StudioListPage extends StatefulWidget {
  const StudioListPage({super.key});

  @override
  _StudioListPageState createState() => _StudioListPageState();
}

class _StudioListPageState extends State<StudioListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  String searchQuery = '';
  String selectedStyle = 'All';

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<QuerySnapshot>(
              // Fetch data from Firestore
              stream: _firestore.collection('studios').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No studios found.'));
                }

                // Filter studios based on search query and selected style
                final filteredStudios = snapshot.data!.docs.where((doc) {
                  final studio = doc.data() as Map<String, dynamic>;
                  final nameMatch = studio['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  final styleMatch =
                      selectedStyle == 'All' || studio['style'] == selectedStyle;
                  return nameMatch && styleMatch;
                }).toList();

                return ListView.builder(
                  itemCount: filteredStudios.length,
                  itemBuilder: (context, index) {
                    final studio = filteredStudios[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(studio['name']),
                      subtitle: Text(studio['address']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudioInfoPage(
                              name: studio['name'],
                              address: studio['address'],
                              description: studio['description'],
                              style: studio['style'],
                            ),
                          ),
                        );
                      },
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

class StudioInfoPage extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String style;

  const StudioInfoPage({
    super.key,
    required this.name,
    required this.address,
    required this.description,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Address: $address', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Description: $description', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Style: $style', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}