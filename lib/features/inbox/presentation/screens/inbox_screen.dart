import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final List<Map<String, String>> _updates = [
    {"title": "Just trust us", "time": "01/26"},
    {"title": "So iconic", "time": "12/25"},
    {"title": "Inspired by you", "time": "12/25"},
    {"title": "Big mood", "time": "12/25"},
    {"title": "Inspired by you", "time": "11/25"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inbox',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    'assets/icons/pencil.png',
                    height: 23,
                    color: AppColors.lightBackground,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Message',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextDisabled,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.lightTextDisabled,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,

                leading: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.person_add_outlined, size: 28),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite your friends',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightSurface,
                      ),
                    ),
                    Text(
                      'Connect to start chatting',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextDisabled,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),
              Text(
                'Updates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _updates.length,
                  itemBuilder: (context, index) {
                    final Map<String, String> update = _updates[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        onTap: () {
                          context.push('/update_screen', extra: update['title']);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.darkSurfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/image${index + 1}.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              update['title']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightSurface,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              update['time']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightTextDisabled,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.more_horiz, size: 24),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
