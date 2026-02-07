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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726), // Orange color from design
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [TShadowStyle.primaryShadow],
                ),
                child: Column(
                  children: [
                    // Top Section: Avatar & Name
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Iconsax.user, size: 30, color: Colors.grey),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        
                        // Name & ID
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Hoang Van Duc",
                              style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.white, fontWeightDelta: 2),
                            ),
                            Text(
                              "HE181827",
                              style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Switch Icon
                        const Icon(Iconsax.arrow_swap_horizontal, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(color: Colors.white54, thickness: 1),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Bottom Section: Class & School
                    Row(
                      children: [
                        const Icon(Iconsax.book, color: Colors.white, size: 18),
                        const SizedBox(width: TSizes.xs),
                        Text("SE1885", style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)),
                        const Spacer(),
                        const Icon(Iconsax.teacher, color: Colors.white, size: 18),
                        const SizedBox(width: TSizes.xs),
                        Text("Đại học FPT", style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)),
                      ],
                    )
                  ],
                ),
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


