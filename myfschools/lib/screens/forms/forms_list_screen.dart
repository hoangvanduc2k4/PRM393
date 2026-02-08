import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/form_card.dart';
import 'create_form_screen.dart';

class FormsListScreen extends StatelessWidget {
  const FormsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.formsTitle, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: const [
             FormCard(
              title: TTexts.typeSickLeave,
              type: "Xin nghỉ học vì lý do sức khỏe",
              date: "27/1/2026",
              reason: "Em bị sốt cao không thể đến lớp được",
              status: TTexts.statusApproved,
            ),
             FormCard(
              title: TTexts.typeLateArrival,
              type: "Xin đến muộn tiết 1",
              date: "29/1/2026",
              reason: "Xe em bị hỏng giữa đường",
              status: TTexts.statusPending,
            ),
             FormCard(
              title: TTexts.typeSickLeave,
              type: "Xin nghỉ học đi khám bệnh",
              date: "24/1/2026",
              reason: "Lý do không chính đáng (thiếu giấy tờ chứng minh)",
              status: TTexts.statusRejected,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFormScreen())),
        backgroundColor: TColors.sunshade,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}
