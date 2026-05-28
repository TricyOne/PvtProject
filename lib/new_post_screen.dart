import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'profile_screen.dart';
import 'feeling_picker_screen.dart';

const String apiBaseUrl = 'http://194.104.94.159:8080';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _selectedImage;
  final TextEditingController _textController = TextEditingController();
  String? _selectedFeeling;
  bool _isPublishing = false;

  final _storage = const FlutterSecureStorage();
  String? _jwtToken;
  int? _currentUserId;

  static const Map<String, String> _displayLabel = {
    'HAPPY': 'happy',
    'EXCITED': 'excited',
    'CALM': 'calm',
    'TIRED': 'tired',
    'COLD': 'cold',
  };
  static const Map<String, String> _emoji = {
    'HAPPY': '\u{1F600}',
    'EXCITED': '\u{1F929}',
    'CALM': '\u{1F60C}',
    'TIRED': '\u{1F971}',
    'COLD': '\u{1F976}',
  };

  @override
  void initState() {
    super.initState();
    _loadAuth();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadAuth() async {
    final jwt = await _storage.read(key: 'jwt_token');
    final userIdStr = await _storage.read(key: 'user_id');
    if (!mounted) return;
    setState(() {
      _jwtToken = jwt;
      _currentUserId = userIdStr != null ? int.parse(userIdStr) : null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Could not choose image: $e');
    }
  }

  Future<void> _openFeelingPicker() async {
    final picked = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const FeelingPickerScreen()),
    );
    if (picked == null) return;

    final label = _displayLabel[picked]!;
    final emoji = _emoji[picked]!;

    //placeholdernamn används, byt till riktiga visningsnamn när profile_screen.dart levererar det
    final newLine = 'User #${_currentUserId!} is feeling $label $emoji';

    final currentText = _textController.text;
    final rest = _selectedFeeling != null
        ? (currentText.contains('\n')
              ? currentText.substring(currentText.indexOf('\n') + 1)
              : '')
        : currentText;

    setState(() {
      _selectedFeeling = picked;
      _textController.text = rest.isEmpty ? '$newLine\n' : '$newLine\n$rest';
    });
  }

  Future<String?> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/api/uploads/images'),
    );
    request.headers['Authorization'] = 'Bearer ${_jwtToken!}';

    final ext = image.path.split('.').last.toLowerCase();
    final mimeType = switch (ext) {
      'png' => MediaType('image', 'png'),
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'webp' => MediaType('image', 'webp'),
      _ => MediaType('application', 'octet-stream'),
    };

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: mimeType,
      ),
    );

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      debugPrint('Upload fel: ${streamed.statusCode}');
      debugPrint('Backend-svar: $body');
      return null;
    }

    final data = json.decode(body) as Map<String, dynamic>;
    return data['imageKey'] as String?;
  }

  Future<void> _publish() async {
    if (_isPublishing) return;

    setState(() => _isPublishing = true);

    try {
      String? imageKey;

      if (_selectedImage != null) {
        imageKey = await _uploadImage(_selectedImage!);
        if (imageKey == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bilduppladdning misslyckades')),
          );
          return;
        }
      }

      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/social/posts'),
        headers: {
          'Authorization': 'Bearer ${_jwtToken!}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': _currentUserId!,
          'body': _textController.text,
          if (imageKey != null) 'imageKey': imageKey,
          //Blockerat: person-knapp/plats-knapp inte aktiv än - p.g.a. ingen locationId
          if (_selectedFeeling != null) 'feeling': _selectedFeeling,
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Inlägget publicerades')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Misslyckades: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fel: $e')));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1E4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC1E4FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.close, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
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
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/icon_sample_user.png'),
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(width: 12),
                //placeholdernamn, byts till riktiga visningsnamnet när profile_screen.dart levererar funktionaliteten
                Text(
                  'User #${_currentUserId ?? ""}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Personer+Plats kräver user-search-endpoint från backend.
                const _RoundedButton(icon: Icons.people, label: 'People'),
                const _RoundedButton(
                  icon: Icons.location_on,
                  label: 'Location',
                ),
                _FeelingButton(
                  selectedFeeling: _selectedFeeling,
                  emoji: _selectedFeeling == null
                      ? null
                      : _emoji[_selectedFeeling],
                  label: _selectedFeeling == null
                      ? 'Feeling'
                      : _displayLabel[_selectedFeeling]!,
                  onTap: _openFeelingPicker,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Stack(
              children: [
                Container(
                  height: 140,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE5F2FF)),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Share your thoughts and feelings!',
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 12,
                  child: Icon(Icons.edit, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: _selectedImage == null ? 90 : 270,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F2FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _selectedImage == null
                    ? Row(
                        children: [
                          Container(
                            width: 90,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0090FF),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x7F000000),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Add photos...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),

                          Image.asset(
                            'assets/icon_camera_img-box.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: GestureDetector(
                onTap: _publish,
                child: Container(
                  width: 370,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0090FF),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Publish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _RoundedButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FeelingButton extends StatelessWidget {
  final String? selectedFeeling;
  final String? emoji;
  final String label;
  final VoidCallback onTap;

  const _FeelingButton({
    required this.selectedFeeling,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji == null)
                Image.asset('assets/icon_feeling.png', width: 18, height: 18)
              else
                Text(emoji!, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
