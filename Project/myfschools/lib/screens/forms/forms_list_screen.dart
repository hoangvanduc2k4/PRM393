import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/form_card.dart';
import 'create_form_screen.dart';

import '../../../../controllers/form_controller.dart';
import 'package:intl/intl.dart';

class FormsListScreen extends StatefulWidget {
  const FormsListScreen({super.key});

  @override
  State<FormsListScreen> createState() => _FormsListScreenState();
}

class _FormsListScreenState extends State<FormsListScreen> {
  final FormController _formController = FormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

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
        child: AnimatedBuilder(
          animation: _formController,
          builder: (context, child) {
            if (_formController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_formController.forms.isEmpty) {
              return const Center(child: Text('Chưa có đơn từ nào.'));
            }

            return ListView.builder(
              itemCount: _formController.forms.length,
              itemBuilder: (context, index) {
                final form = _formController.forms[index];
                return FormCard(
                  title: form.title,
                  type: form.type,
                  date: form.date, // Alternatively: DateFormat('dd/MM/yyyy').format(form.createdAt.toDate()),
                  reason: form.reason,
                  status: form.status,
                );
              },
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Refresh list when coming back from Create screen
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFormScreen()));
          _formController.fetchForms();
        },
        backgroundColor: TColors.sunshade,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}
