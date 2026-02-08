import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/club_card.dart';

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(TTexts.clubs, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
          centerTitle: true,
          backgroundColor: TColors.sunshade, // Light Orange
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Đã tham gia"),
              Tab(text: "Toàn bộ"),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            // -- Tab 1: My Clubs
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ListView(
                children: const [
                  ClubCard(
                    clubName: "F-Code (Lập trình)",
                    category: "Học thuật",
                    memberCount: 120,
                    isJoined: true,
                    icon: Iconsax.code,
                    color: Colors.blue,
                    showStatus: false, // Don't show "Joined" text
                  ),
                  ClubCard(
                    clubName: "Tiếng Anh (FEC)",
                    category: "Học thuật",
                    memberCount: 150,
                    isJoined: true,
                    icon: Iconsax.language_square,
                    color: Colors.red,
                    showStatus: false, // Don't show "Joined" text
                  ),
                ],
              ),
            ),

            // -- Tab 2: All Clubs
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ListView(
                children: [
                   // Search Bar inside "All" tab or globally? Let's put it here for list focus
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm...",
                      prefixIcon: const Icon(Iconsax.search_normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  
                  const ClubCard(
                    clubName: "F-Music (Âm nhạc)",
                    category: "Nghệ thuật",
                    memberCount: 85,
                    isJoined: false,
                    icon: Iconsax.music,
                    color: Colors.purple,
                  ),
                   const ClubCard(
                    clubName: "Vovinam FPT",
                    category: "Thể thao",
                    memberCount: 200,
                    isJoined: false,
                    icon: Iconsax.activity,
                    color: Colors.orange,
                  ),
                  const ClubCard(
                    clubName: "Multimedia (F-Media)",
                    category: "Truyền thông",
                    memberCount: 90,
                    isJoined: false,
                    icon: Iconsax.camera,
                    color: Colors.teal,
                  ),
                  // Duplicate some for "All" feel
                   const ClubCard(
                    clubName: "F-Code (Lập trình)",
                    category: "Học thuật",
                    memberCount: 120,
                    isJoined: true,
                    icon: Iconsax.code,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
