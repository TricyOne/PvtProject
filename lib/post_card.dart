import 'package:flutter/material.dart';
import 'other_profile_screen.dart';

class PostCard extends StatelessWidget {
  final String username;
  final int userId;
  final String date;
  final String text;
  final String? imageUrl;
  final int? locationId;
  final String? locationName;
  final bool disableUsernameTap;
  final bool replaceOnTap;
  final String? feeling;
  final String? profilePictureUrl;

  static const feelingLabel = {
    'HAPPY': 'happy',
    'EXCITED': 'excited',
    'CALM': 'calm',
    'TIRED': 'tired',
    'COLD': 'cold',
  };
  static const feelingEmoji = {
    'HAPPY': '\u{1F600}',
    'EXCITED': '\u{1F929}',
    'CALM': '\u{1F60C}',
    'TIRED': '\u{1F971}',
    'COLD': '\u{1F976}',
  };

  const PostCard({
    super.key,
    required this.username,
    required this.userId,
    required this.date,
    required this.text,
    this.imageUrl,
    this.locationId,
    this.locationName,
    this.disableUsernameTap = false,
    this.replaceOnTap = false,
    this.feeling,
    this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    (profilePictureUrl != null && profilePictureUrl!.isNotEmpty)
                    ? NetworkImage(profilePictureUrl!)
                    : const AssetImage('assets/icon_sample_user.png')
                          as ImageProvider,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: disableUsernameTap
                    ? null
                    : () {
                        final route = MaterialPageRoute(
                          builder: (context) =>
                              OtherProfileScreen(userId: userId),
                        );
                        if (replaceOnTap) {
                          Navigator.pushReplacement(context, route);
                        } else {
                          Navigator.push(context, route);
                        }
                      },
                child: Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(height: 150, color: const Color(0xFF1A237E)),
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (locationId != null || locationName != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  locationName ?? 'Location #$locationId',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          if (feeling != null && feelingLabel.containsKey(feeling)) ...[
            Text(
              '${username.split(' ').first} is feeling ${feelingLabel[feeling]} ${feelingEmoji[feeling]}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
