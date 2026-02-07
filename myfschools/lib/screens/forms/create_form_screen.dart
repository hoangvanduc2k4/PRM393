import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class CreateFormScreen extends StatefulWidget {
  const CreateFormScreen({super.key});

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  String? _selectedType = TTexts.typeSickLeave;
  final TextEditingController _reasonController = TextEditingController();
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.createFormTitle, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA726),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Form Type
            Text(TTexts.formType, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(value: TTexts.typeSickLeave, child: Text(TTexts.typeSickLeave)),
                    DropdownMenuItem(value: TTexts.typeLateArrival, child: Text(TTexts.typeLateArrival)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // -- Reason
            Text(TTexts.reason, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            TextFormField(
              controller: _reasonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: TTexts.reasonHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // -- Evidence
             Text(TTexts.evidence, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
               decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
              ),
              child: Row(
                children: [
                   ElevatedButton(
                    onPressed: () {
                      // Basic simulation of picking a file
                      setState(() {
                         _fileName = "minh_chung_xin_nghi.jpg";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text(TTexts.selectFile),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Text(
                      _fileName ?? "Chưa chọn tệp nào", 
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            
            // -- Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.pop(context);
                },
                 style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  side: BorderSide.none,
                ),
                child: const Text(TTexts.submitCaps),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
