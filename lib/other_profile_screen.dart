import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'post_card.dart';

const String apiBaseUrl = 'http://194.104.94.159:8080';

class OtherProfileScreen extends StatefulWidget {
  final int userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  bool _isFollowRequested = false;
  int _selectedFilter = 0;
  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchUserPosts();
  }

  //Ingen ?userId-filter från Backend. så hela flödet hämtas och filtrerar klient-sidan. Fungerar men skalar inte.

  Future<List<Map<String, dynamic>>> _fetchUserPosts() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/api/social/posts'));
    if (response.statusCode != 200) {
      throw Exception('Kunde inte hämta inlägg (${response.statusCode})');
    }
    final all = (json.decode(response.body) as List)
        .cast<Map<String, dynamic>>();
    return all.where((p) => p['userId'] == widget.userId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final ovalWidth = screenWidth * 1.6;
    final ovalHeight = ovalWidth * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xFFC1E4FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -ovalHeight * 0.14,
                    left: (screenWidth - ovalWidth) / 2,
                    child: Container(
                      width: ovalWidth,
                      height: ovalHeight,
                      decoration: const ShapeDecoration(
                        color: Color(0x93658EAE),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/image_leaves.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon_sample_user.png', //riktig avatar väntar på backend + profile_screen.dart
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Användare #${widget.userId}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF6E6E6E),
                            ), //riktigt visningsnamn väntar på backend GET /api/users/{userId} / profile_screen.dart implementerar sätta namn
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(
                                Icons.people,
                                size: 18,
                                color: Color(0xFF6E6E6E),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '- Vänner',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF6E6E6E),
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.article_outlined,
                                size: 18,
                                color: Color(0xFF6E6E6E),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '- inlägg',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF6E6E6E),
                                ),
                              ),
                            ], //siffrorna kräver profil-endpoint från backend
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Bio... - väntar på profile-endpoint.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6E6E6E),
                    ),
                  ),
                ), // bio-texten ska komma från backends profil-endpoint + profile_screen.dart där andvändare sätter sin bio.
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: const Color(0xFF0090FF),
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            //finns ingen vänförfrågnings-endpoint från backend.
                            setState(() {
                              _isFollowRequested = !_isFollowRequested;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _isFollowRequested
                                      ? 'assets/icon_clock.png'
                                      : 'assets/icon_user_add.png',
                                  width: 20,
                                  height: 20,
                                  color: Colors.black,
                                ),

                                const SizedBox(width: 8),
                                Text(
                                  _isFollowRequested
                                      ? 'Förfrågan skickad'
                                      : 'Följ',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            //out of scope - kommer inte implementeras utav backend
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFF0090FF),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon_chat_line.png',
                                  width: 20,
                                  height: 29,
                                ),

                                SizedBox(width: 8),
                                Text(
                                  'Meddelande',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _filterButton('Alla', 0),
                  const SizedBox(width: 8),
                  _filterButton('Inlägg', 1),
                  const SizedBox(width: 8),
                  _filterButton('Rapporter', 2),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text('Kunde inte ladda inläggen.');
                  }
                  final posts = snapshot.data ?? const [];

                  //Filtrera "Rapporter" är blockerad - behöver Comment Service-data per användare
                  if (_selectedFilter == 2) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Finns ingen endpoint för att filtrera rapporter på användare',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF6E6E6E),
                          ), //comment service har bara GET /api/locations/{id}/comments - alltså per sjö, inte per användare
                        ),
                      ),
                    );
                  }
                  //Filter alla/inlägg visar samma data - finns ingen filtrering från backend
                  if (posts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text('Inga inlägg från denna användare'),
                      ),
                    );
                  }
                  return Column(
                    children: posts.map((post) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PostCard(
                          username: 'Användare #${widget.userId}',
                          userId: widget.userId,
                          date: _formatDate(post['createdAt'] as String),
                          text: post['body'] as String? ?? '',
                          imageUrl: post['imageUrl'] as String?,
                          disableUsernameTap: true,
                          replaceOnTap: true,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String label, int index) {
    final isActive = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE5F2FF) : Colors.white,
          border: Border.all(
            color: isActive ? const Color(0xFF0090FF) : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.parse(iso);
    final d =
        '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
    return '$d [$t]';
  }
}
