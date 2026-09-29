import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rating_controller.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String requestId;
  final String saathiId;

  const RatingScreen({
    super.key,
    required this.requestId,
    required this.saathiId,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final List<String> _tags = ['Polite', 'On Time', 'Safe Driving', 'Helpful'];

  @override
  void initState() {
    super.initState();
    // Clear state on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratingControllerProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ratingControllerProvider);
    final controller = ref.read(ratingControllerProvider.notifier);

    // Listen for error or success
    ref.listen<RatingState>(ratingControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    if (state.isSuccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rating Submitted'), automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              Text('Thank you!', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              const Text('Your rating has been submitted successfully.'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Back to Home'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Vahan Saathi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  icon: Icon(
                    state.stars >= starValue ? Icons.star : Icons.star_border,
                    size: 48,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    controller.setStars(starValue.toDouble());
                  },
                );
              }),
            ),
            const SizedBox(height: 32),
            const Text('Add a tag (optional):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: _tags.map((tag) {
                final isSelected = state.tag == tag;
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) {
                    controller.setTag(tag);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: (state.stars == 0 || state.isSubmitting)
                  ? null
                  : () => controller.submitRating(widget.requestId, widget.saathiId),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: state.isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Rating', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
