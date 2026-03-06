import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/event_card.dart';
import '../../controllers/event_controller.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventController _eventController = EventController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sự kiện", style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade, // Light Orange to match theme
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: AnimatedBuilder(
          animation: _eventController,
          builder: (context, _) {
            if (_eventController.isLoading) {
              return const Center(child: CircularProgressIndicator(color: TColors.sunshade));
            }

            if (_eventController.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.calendar_remove, size: 60, color: TColors.grey),
                    const SizedBox(height: TSizes.sm),
                    Text("Không có sự kiện nào sắp tới", style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: _eventController.events.length,
              itemBuilder: (context, index) {
                final event = _eventController.events[index];
                return EventCard(
                  eventName: event.eventName,
                  date: event.dateString,
                  month: event.monthString,
                  time: event.time,
                  location: event.location,
                  color: event.color,
                );
              },
            );
          }
        ),
      ),
    );
  }
}

