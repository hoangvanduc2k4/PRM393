import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

import '../../../../controllers/form_controller.dart';
import 'package:intl/intl.dart';

class CreateFormScreen extends StatefulWidget {
  const CreateFormScreen({super.key});

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final FormController _formController = FormController();
  String? _selectedType = TTexts.typeSickLeave;
  final TextEditingController _reasonController = TextEditingController();
  String? _fileName;

  @override
  void dispose() {
    _reasonController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập lý do'), backgroundColor: Colors.red),
      );
      return;
    }

    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    String? error = await _formController.submitForm(
      type: _selectedType ?? TTexts.typeSickLeave,
      reason: _reasonController.text.trim(),
      date: currentDate,
    );

    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gửi đơn thành công!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.createFormTitle, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade,
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
                    const DropdownMenuItem(value: TTexts.typeSickLeave, child: Text(TTexts.typeSickLeave)),
                    const DropdownMenuItem(value: TTexts.typeLateArrival, child: Text(TTexts.typeLateArrival)),
                    const DropdownMenuItem(value: TTexts.typeAbsentExtracurricular, child: Text(TTexts.typeAbsentExtracurricular)),
                    const DropdownMenuItem(value: TTexts.typeRegisterMeals, child: Text(TTexts.typeRegisterMeals)),
                    const DropdownMenuItem(value: TTexts.typeRegisterBus, child: Text(TTexts.typeRegisterBus)),
                    const DropdownMenuItem(value: TTexts.typeChangeClass, child: Text(TTexts.typeChangeClass)),
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
            AnimatedBuilder(
              animation: _formController,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _formController.isLoading ? null : _submit,
                     style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.sunshade,
                      side: BorderSide.none,
                    ),
                    child: _formController.isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(TTexts.submitCaps),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
