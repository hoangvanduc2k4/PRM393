import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/club_controller.dart';
import 'widgets/club_card.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  // Khởi tạo Controller
  final ClubController _clubController = ClubController();

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
        // Sử dụng AnimatedBuilder để lắng nghe thay đổi từ Controller
        body: AnimatedBuilder(
          animation: _clubController,
          builder: (context, _) {
            if (_clubController.isLoading) {
              return const Center(child: CircularProgressIndicator(color: TColors.sunshade));
            }

            return TabBarView(
              children: [
                // -- Tab 1: CLB đã tham gia
                _buildJoinedClubsTab(),

                // -- Tab 2: Tất cả CLB
                _buildAllClubsTab(),
              ],
            );
          },
        ),
      ),
    );
  }

  // Giao diện Tab 1
  Widget _buildJoinedClubsTab() {
    if (_clubController.joinedClubs.isEmpty) {
      return const Center(child: Text("Bạn chưa tham gia CLB nào."));
    }

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: ListView.builder(
        itemCount: _clubController.joinedClubs.length,
        itemBuilder: (context, index) {
          final club = _clubController.joinedClubs[index];
          return ClubCard(
            clubName: club.name,
            category: club.category,
            memberCount: club.memberCount,
            isJoined: club.isJoined,
            icon: club.icon,
            color: club.color,
            showStatus: false, 
          );
        },
      ),
    );
  }

  // Giao diện Tab 2
  Widget _buildAllClubsTab() {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          // Thanh tìm kiếm và Lọc
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (value) => _clubController.setSearchQuery(value),
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
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _clubController.selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Iconsax.arrow_down_1, size: 16),
                      style: Theme.of(context).textTheme.bodyMedium,
                      items: ['Tất cả', 'Học thuật', 'Nghệ thuật', 'Thể thao', 'Truyền thông', 'Khoa học']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) _clubController.setCategory(value);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          
          // Danh sách kết quả
          Expanded(
            child: _clubController.searchResults.isEmpty
                ? const Center(child: Text("Không tìm thấy kết quả."))
                : ListView.builder(
                    itemCount: _clubController.searchResults.length,
                    itemBuilder: (context, index) {
                      final club = _clubController.searchResults[index];
                      return ClubCard(
                        clubName: club.name,
                        category: club.category,
                        memberCount: club.memberCount,
                        isJoined: club.isJoined,
                        icon: club.icon,
                        color: club.color,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

}
