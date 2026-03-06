import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/styles/shadow_styles.dart';
import 'package:myfschools/common/widgets/utility_card.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';
import '../forms/forms_list_screen.dart';
import '../schedule/schedule_screen.dart';
import '../grades/grades_screen.dart';
import '../clubs/clubs_screen.dart';
import '../events/events_screen.dart';
import '../notifications/notifications_screen.dart';
import '../login/login.dart';

import '../../controllers/home_controller.dart'; // import controller

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Safe Area for top padding
              SizedBox(height: MediaQuery.of(context).padding.top),

              /// -- Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                   TTexts.greeting,
                   style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }, 
                    icon: const Icon(Iconsax.logout, color: Colors.red),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Student Info Card
              AnimatedBuilder(
                animation: _homeController,
                builder: (context, child) {
                          return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TSizes.md),
                    decoration: BoxDecoration(
                      color: TColors.sunshade, // Orange color from design
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [TShadowStyle.primaryShadow],
                    ),
                    child: _homeController.isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : Column(
                            children: [
                              // Top Section: Avatar & Name
                              GestureDetector(
                                onTap: () {
                                  // Hộp thoại đổi bé
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Chọn Hồ Sơ Học Sinh",
                                              style: Theme.of(context).textTheme.headlineSmall,
                                            ),
                                            const SizedBox(height: TSizes.spaceBtwItems),
                                            ..._homeController.children.map((child) {
                                              bool isSelected = _homeController.selectedChild?.childId == child.childId;
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(child.avatarUrl),
                                                  backgroundColor: Colors.grey.shade200,
                                                  onBackgroundImageError: (_, __) => const Icon(Iconsax.user),
                                                ),
                                                title: Text(child.childName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                subtitle: Text("Lớp: ${child.className} - ID: ${child.childId}"),
                                                trailing: isSelected 
                                                    ? const Icon(Iconsax.tick_circle, color: TColors.sunshade)
                                                    : null,
                                                onTap: () {
                                                  _homeController.switchChild(child.childId);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }).toList(),
                                            const SizedBox(height: TSizes.spaceBtwItems),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: _homeController.avatarUrl.isNotEmpty
                                          ? ClipOval(
                                              child: Image.network(
                                                _homeController.avatarUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Iconsax.user, size: 30, color: Colors.grey),
                                              ),
                                            )
                                          : const Icon(Iconsax.user, size: 30, color: Colors.grey),
                                    ),
                                    const SizedBox(width: TSizes.spaceBtwItems),
                                    
                                    // Name & ID
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          _homeController.childName,
                                          style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.white, fontWeightDelta: 2),
                                        ),
                                        Text(
                                          _homeController.childId,
                                          style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    // Switch Icon
                                    const Icon(Iconsax.arrow_swap_horizontal, color: Colors.white),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              const Divider(color: Colors.white54, thickness: 1),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              
                              // Bottom Section: Class & School
                              Row(
                                children: [
                                  const Icon(Iconsax.book, color: Colors.white, size: 18),
                                  const SizedBox(width: TSizes.xs),
                                  Text(_homeController.className, style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)),
                                  const Spacer(),
                                  const Icon(Iconsax.teacher, color: Colors.white, size: 18),
                                  const SizedBox(width: TSizes.xs),
                                  Text("Đại học FPT", style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                  );
                }
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Utilities Section
              Text(TTexts.utilities, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Utilities Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, 
                mainAxisSpacing: TSizes.spaceBtwSections,
                crossAxisSpacing: TSizes.spaceBtwItems,
                children: [
                  UtilityCard(
                    icon: Iconsax.clipboard_text, 
                    label: TTexts.forms, 
                    color: Colors.purple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FormsListScreen())),
                  ), // Forms
                  UtilityCard(
                    icon: Iconsax.people, 
                    label: TTexts.clubs, 
                    color: const Color(0xFFD84315),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClubsScreen())),
                  ), // Clubs (Orange/Brown)
                  UtilityCard(
                    icon: Iconsax.calendar_1, 
                    label: TTexts.schedule, 
                    color: Colors.redAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleScreen())),
                  ), // Schedule
                  UtilityCard(
                    icon: Iconsax.notification, 
                    label: TTexts.notifications, 
                    color: Colors.green,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                  ), // Notifications
                  UtilityCard(
                    icon: Iconsax.chart_21, 
                    label: TTexts.grades, 
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GradesScreen())),
                  ), // Grades
                  UtilityCard(
                    icon: Iconsax.cup, 
                    label: TTexts.events, 
                    color: Colors.orangeAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EventsScreen())),
                  ), // Events
                ],
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar removed
    );
  }
}


