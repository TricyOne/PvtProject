import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'post_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiBaseUrl = 'http://194.104.94.159:8080';

class OtherProfileScreen extends StatefulWidget {
  final int userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  final _storage = const FlutterSecureStorage();
  int? _myUserId;
  String _myUserName = '';
  String? _profilePictureUrl;

  bool _isFollowRequested = false;
  int _selectedFilter = 0;
  late Future<List<Map<String, dynamic>>> _postsFuture;
  late Future<List<Map<String, dynamic>>> _reportsFuture;
  late Future<Map<int, String>> _lakeNamesFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchUserPosts();
    _reportsFuture = _fetchUserReports();
    _lakeNamesFuture = _fetchLakeNames();
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

  String _displayName(int userId) {
    if (_myUserId != null && userId == _myUserId) return _myUserName;
    return 'User #$userId';
  }

  Future<List<Map<String, dynamic>>> _fetchUserPosts() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/api/social/posts'));
    if (response.statusCode != 200) {
      throw Exception('Could not collect post (${response.statusCode})');
    }
    final all = (json.decode(response.body) as List)
        .cast<Map<String, dynamic>>();
    return all.where((p) => p['userId'] == widget.userId).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchUserReports() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/users/${widget.userId}/comments'),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not collect reports (${response.statusCode})');
    }
    return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
  }

  Future<Map<int, String>> _fetchLakeNames() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/api/locations'));
      if (response.statusCode != 200) return {};
      final data = (json.decode(response.body) as List)
          .cast<Map<String, dynamic>>();
      return {for (final loc in data) loc['id'] as int: loc['title'] as String};
    } catch (e) {
      debugPrint('Could not collect location-names: $e');
      return {};
    }
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
                        child:
                            (widget.userId == _myUserId &&
                                _profilePictureUrl != null &&
                                _profilePictureUrl!.isNotEmpty)
                            ? Image.network(
                                _profilePictureUrl!,
                                fit: BoxFit.cover,
                              )
                            //Kan bara visa annan användares avatar när backend returnerar profilePictureUrl per användare i PostRespone
                            : Image.asset(
                                'assets/icon_sample_user.png',
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
                          const SizedBox(height: 20),
                          Text(
                            _displayName(widget.userId),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 18,
                                    color: Color(0xFF6E6E6E),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '- friends [in development]',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF6E6E6E),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 18,
                                    color: Color(0xFF6E6E6E),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '- posts [in development]',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF6E6E6E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                    'Bio [in development]',
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
                                if (_isFollowRequested)
                                  const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Request sent',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          height: 1.1,
                                        ),
                                      ),
                                      Text(
                                        '[in development]',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  const Text(
                                    'Follow',
                                    style: TextStyle(color: Colors.black),
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
                                const SizedBox(width: 8),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        height: 1.1,
                                      ),
                                    ),
                                    Text(
                                      '[in development]',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
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
                  _filterButton('All', 0),
                  const SizedBox(width: 8),
                  _filterButton('Posts', 1),
                  const SizedBox(width: 8),
                  _filterButton('Reports', 2),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFilteredContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredContent() {
    if (_selectedFilter == 2) return _buildReportsList();
    if (_selectedFilter == 1) return _buildPostsList();
    return _buildCombinedList();
  }

  Widget _buildPostsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Could not load the posts');
        }
        final posts = snapshot.data ?? const [];
        if (posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No posts from this user')),
          );
        }
        return Column(
          children: posts.map((post) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                username: _displayName(widget.userId),
                userId: widget.userId,
                date: _formatDate(post['createdAt'] as String),
                text: post['body'] as String? ?? '',
                imageUrl: post['imageUrl'] as String?,
                locationId: post['locationId'] as int?,
                feeling: post['feeling'] as String?,
                disableUsernameTap: true,
                replaceOnTap: true,
                profilePictureUrl: widget.userId == _myUserId
                    ? _profilePictureUrl
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildReportsList() {
    return FutureBuilder<List<Object>>(
      future: Future.wait([_reportsFuture, _lakeNamesFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Text('Could not load content');
        }
        final reports = snapshot.data![0] as List<Map<String, dynamic>>;
        final lakeNames = snapshot.data![1] as Map<int, String>;
        if (reports.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No reports from this user')),
          );
        }
        return Column(
          children: reports.map((r) {
            final locId = r['locationId'] as int;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                username: _displayName(widget.userId),
                userId: widget.userId,
                date: _formatDate(r['createdAt'] as String),
                text: r['body'] as String? ?? '',
                imageUrl: r['imageUrl'] as String?,
                locationId: locId,
                locationName: lakeNames[locId] ?? 'Unknown location',
                disableUsernameTap: true,
                replaceOnTap: true,
                profilePictureUrl: widget.userId == _myUserId
                    ? _profilePictureUrl
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCombinedList() {
    return FutureBuilder<List<Object>>(
      future: Future.wait([_postsFuture, _reportsFuture, _lakeNamesFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Could not load content');
        }
        final posts = snapshot.data![0] as List<Map<String, dynamic>>;
        final reports = snapshot.data?[1] as List<Map<String, dynamic>>;
        final lakeNames = snapshot.data?[2] as Map<int, String>;

        final combined = <Map<String, dynamic>>[
          for (final p in posts) {...p, '_type': 'post'},
          for (final r in reports) {...r, '_type': 'report'},
        ];
        combined.sort((a, b) {
          final aDate = a['createdAt'] as String? ?? '';
          final bDate = b['createdAt'] as String? ?? '';
          return bDate.compareTo(aDate);
        });

        if (combined.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No content from this user')),
          );
        }

        return Column(
          children: combined.map((item) {
            final isReport = item['_type'] == 'report';
            final locId = item['locationId'] as int?;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                username: _displayName(widget.userId),
                userId: widget.userId,
                date: _formatDate(item['createdAt'] as String),
                text: item['body'] as String? ?? '',
                imageUrl: item['imageUrl'] as String?,
                locationId: locId,
                locationName: isReport
                    ? (lakeNames[locId] ?? 'Unknown location')
                    : null,
                feeling: isReport ? null : item['feeling'] as String?,
                disableUsernameTap: true,
                replaceOnTap: true,
                profilePictureUrl: widget.userId == _myUserId
                    ? _profilePictureUrl
                    : null,
              ),
            );
          }).toList(),
        );
      },
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
}
