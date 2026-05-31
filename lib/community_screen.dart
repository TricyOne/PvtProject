import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'new_post_screen.dart';
import 'post_card.dart';
import 'profile_screen.dart';

const String apiBaseUrl = 'http://194.104.94.159:8080';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _storage = const FlutterSecureStorage();
  int? _myUserId;
  String _myUserName = '';
  String? _profilePictureUrl;

  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
    _loadMyName();
  }

  Future<void> _loadMyName() async {
    final id = await _storage.read(key: 'user_id');
    final name = await _storage.read(key: 'user_name');
    final picUrl = await _storage.read(key: 'profile_picture_url');
    if (id != null && name != null && mounted) {
      setState(() {
        _myUserId = int.tryParse(id);
        _myUserName = name;
        _profilePictureUrl = picUrl;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/api/social/posts'));
    if (response.statusCode != 200) {
      throw Exception('Kunde inte hämta inlägg (${response.statusCode})');
    }
    final data = json.decode(response.body) as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _fetchPosts();
    });
    await _postsFuture;
  }

  String _displayName(int userId) {
    if (_myUserId != null && userId == _myUserId) return _myUserName;
    return 'User #$userId';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildTopRow(context),
          const SizedBox(height: 11),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 29),
            child: Divider(height: 1, color: Colors.black),
          ),
          const SizedBox(height: 6),
          const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Explore'),
            ],
          ),
          // Båda flikar visar samma feed. Finns ingen filtreringsendpoint från backend.
          Expanded(
            child: TabBarView(
              children: [
                const Center(
                  child: Text(
                    '[in development]',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6E6E6E),
                    ),
                  ),
                ),
                _buildFeed(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Stack(
                    children: [
                      const ProfileScreen(),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 22,
              backgroundImage:
                  (_profilePictureUrl != null && _profilePictureUrl!.isNotEmpty)
                  ? NetworkImage(_profilePictureUrl!)
                  : const AssetImage('assets/icon_sample_user.png')
                        as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPostScreen()),
                );
                _refresh();
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F2FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'What are you up to?', //"Vad gör du just nu?"
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Kunde inte ladda inlägg'),
                TextButton(
                  onPressed: _refresh,
                  child: const Text('Försök igen'),
                ),
              ],
            ),
          );
        }
        final posts = snapshot.data ?? const [];
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 7.5, 12, 12),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8.5),
              child: Divider(height: 1, color: Colors.black87),
            ),
            itemBuilder: (context, index) {
              final post = posts[index];
              final userId = post['userId'] as int;
              final feeling = post['feeling'] as String?;

              return PostCard(
                username: _displayName(userId),
                userId: userId,
                date: _formatDate(post['createdAt'] as String),
                text: post['body'] as String? ?? '',
                imageUrl: post['imageUrl'] as String?,
                locationId: post['locationId'] as int?,
                feeling: feeling,
                profilePictureUrl: userId == _myUserId
                    ? _profilePictureUrl
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}

String _formatDate(String iso) {
  final normalized = iso.endsWith('Z') ? iso : '${iso}Z';
  final dt = DateTime.parse(normalized).toLocal();
  final d =
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  final t =
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';
  return '$d [$t]';
}
