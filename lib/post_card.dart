import 'package:flutter/material.dart';
import 'other_profile_screen.dart';

class PostCard extends StatelessWidget {
  final String username;
  final int userId;
  final String date;
  final String text;
  final String? imageUrl; //hasImage
  final int? locationId; //location
  final bool disableUsernameTap;
  final bool replaceOnTap;

  const PostCard({
    super.key,
    required this.username,
    required this.userId,
    required this.date,
    required this.text,
    this.imageUrl,
    this.locationId,
    this.disableUsernameTap = false,
    this.replaceOnTap = false,
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
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/icon_sample_user.png'),
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
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF6E6E6E),
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

          if (locationId != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Plats #$locationId',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
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
