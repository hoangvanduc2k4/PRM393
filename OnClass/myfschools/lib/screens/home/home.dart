import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/styles/shadow_styles.dart';
import 'package:myfschools/common/widgets/utility_card.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    onPressed: () {},
                    icon: const Icon(Iconsax.notification),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Student Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [TShadowStyle.primaryShadow],
                ),
                child: Column(
                  children: [
                    // Top Section: Avatar & Name
                    Row(
                      children: [
                        // Avatar (Placeholder Icon for now)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.user,
                            size: 40,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),

                        // Name & ID
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hoang Van Duc",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .apply(
                                    color: Colors.white,
                                    fontWeightDelta: 2,
                                  ),
                            ),
                            Text(
                              "HE181827",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Switch Icon
                        const Icon(
                          Iconsax.arrow_swap_horizontal,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(color: Colors.white54),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Bottom Section: Class & School
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.book,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: TSizes.xs),
                            Text(
                              "SE1885",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.teacher,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: TSizes.xs),
                            Text(
                              "FPT University",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Utilities Section
              Text(
                TTexts.utilities,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Utilities Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // Changed to 3 columns
                mainAxisSpacing: TSizes.spaceBtwSections,
                crossAxisSpacing: TSizes.spaceBtwItems,
                children: const [
                  UtilityCard(
                    icon: Iconsax.clipboard_text,
                    label: TTexts.forms,
                    color: Colors.purple,
                  ),
                  UtilityCard(
                    icon: Iconsax.profile_circle,
                    label: TTexts.contact,
                    color: Colors.blue,
                  ),
                  UtilityCard(
                    icon: Iconsax.calendar_1,
                    label: TTexts.schedule,
                    color: Colors.redAccent,
                  ),
                  UtilityCard(
                    icon: Iconsax.user_tick,
                    label: TTexts.attendance,
                    color: Colors.green,
                  ),
                  UtilityCard(
                    icon: Iconsax.chart_21,
                    label: TTexts.grades,
                    color: Colors.blueAccent,
                  ),
                  UtilityCard(
                    icon: Iconsax.cup,
                    label: TTexts.events,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.orange.shade50, // Light orange background
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.orange.shade50, // Match container
            currentIndex: 0,
            selectedItemColor: TColors.primary,
            unselectedItemColor: TColors.darkGrey,
            elevation: 0, // Remove shadow to blend with container
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: TTexts.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: TTexts.me,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
