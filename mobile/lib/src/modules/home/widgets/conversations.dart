import 'package:flutter/material.dart';
import 'package:mobile/src/core/extensions.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  final List<Map<String, String>> _conversations = [
    {'title': 'Morning thoughts', 'subtitle': '08:45'},
    {
      'title': '1:1 w/ Akshay',
      'subtitle': 'Conversation with\nAkshay about product features',
    },
    {
      'title': '2025 predications',
      'subtitle': 'Thoughts on tech trends for\n2025',
    },
    {
      'title': 'Project Kickoff Meeting',
      'subtitle': 'Notes from the quarterly\nplanning session',
    },
    {'title': 'Weekend Plans', 'subtitle': 'Ideas for the upcoming weekend'},
    {
      'title': 'Book Recommendations',
      'subtitle': 'List of must-read books for\npersonal development',
    },
    {
      'title': 'Travel Journal',
      'subtitle': 'Memories from the recent\ntrip to Japan',
    },
    {
      'title': 'Recipe Collection',
      'subtitle': 'Favorite recipes and\ncooking experiments',
    },
    {
      'title': 'Daily Standup',
      'subtitle': 'Team updates and blockers\nfrom today\'s meeting',
    },
    {
      'title': 'Learning Goals',
      'subtitle': 'Skills to develop in\nthe next quarter',
    },
    {
      'title': 'Interview Prep',
      'subtitle': 'Questions and answers for\nupcoming interviews',
    },
    {
      'title': 'Health & Fitness',
      'subtitle': 'Workout routine and\nnutrition tracking',
    },
    {
      'title': 'Side Project Ideas',
      'subtitle': 'Creative concepts for\nfuture development',
    },
  ];

  final List<RadialGradient> _gradients = [
    RadialGradient(
      center: Alignment(-0.6, -0.4),
      focal: Alignment(-0.4, -0.2),
      radius: 1.0,
      colors: [Color(0xFF5B84FF), Color(0xFF5B84FF), Color(0xFF2E5BFF)],
      stops: const [0.0, 0.5, 1.0],
      tileMode: TileMode.clamp,
    ),
    RadialGradient(
      center: Alignment(0.6, -0.3),
      focal: Alignment(0.4, -0.1),
      radius: 1.0,
      colors: [Color(0xFFFD5F4A), Color(0xFFFF8F4A), Color(0xFFEF6C2D)],
      stops: const [0.0, 0.5, 1.0],
      tileMode: TileMode.clamp,
    ),
    RadialGradient(
      center: Alignment(0.0, 0.2),
      focal: Alignment(0.1, 0.1),
      radius: 1.0,
      colors: [Color(0xFFEF7BFF), Color(0xFFBF7BFF), Color(0xFF9A4CFF)],
      stops: const [0.0, 0.5, 1.0],
      tileMode: TileMode.clamp,
    ),
    RadialGradient(
      center: Alignment(0.0, 0.2),
      focal: Alignment(0.1, 0.1),
      radius: 1.0,
      colors: [Color(0xFFFFB86B), Color(0xFFFF7A59), Color(0xFFD9534F)],
      stops: const [0.0, 0.5, 1.0],
      tileMode: TileMode.clamp,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.4,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _conversations.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) =>
            Divider(height: 24, thickness: 1, color: context.colors.card),
        itemBuilder: (context, index) {
          final conv = _conversations[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 120,
                decoration: ShapeDecoration(
                  gradient: _gradients[index % _gradients.length],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conv['title'] ?? '',
                      style: context.textTheme.body2.copyWith(
                        color: context.colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conv['subtitle'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.subtext1.copyWith(
                        color: context.colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
