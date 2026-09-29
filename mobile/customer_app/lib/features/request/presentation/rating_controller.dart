import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_package/shared_package.dart';
import '../data/rating_repository.dart';

class RatingState {
  final double stars;
  final String? tag;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  RatingState({
    this.stars = 0,
    this.tag,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  RatingState copyWith({
    double? stars,
    String? tag,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return RatingState(
      stars: stars ?? this.stars,
      tag: tag ?? this.tag,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  RatingState clearError() {
    return RatingState(
      stars: stars,
      tag: tag,
      isSubmitting: isSubmitting,
      errorMessage: null,
      isSuccess: isSuccess,
    );
  }
}

final ratingControllerProvider = NotifierProvider<RatingController, RatingState>(RatingController.new);

class RatingController extends Notifier<RatingState> {
  @override
  RatingState build() {
    return RatingState();
  }

  void setStars(double stars) {
    state = state.clearError().copyWith(stars: stars);
  }

  void setTag(String tag) {
    // toggle tag off if it's already selected
    if (state.tag == tag) {
      state = state.clearError().copyWith(tag: null);
    } else {
      state = state.clearError().copyWith(tag: tag);
    }
  }

  Future<void> submitRating(String requestId, String saathiId) async {
    if (state.isSubmitting) return; // Prevent double submit
    if (state.stars == 0) {
      state = state.copyWith(errorMessage: 'Please select a star rating.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = state.copyWith(errorMessage: 'User not authenticated.');
      return;
    }

    state = state.clearError().copyWith(isSubmitting: true);

    try {
      final repo = ref.read(ratingRepositoryProvider);
      
      // Basic duplicate protection
      final alreadyRated = await repo.hasRated(requestId, user.uid);
      if (alreadyRated) {
        state = state.copyWith(isSubmitting: false, isSuccess: true, errorMessage: 'You have already rated this trip.');
        return;
      }

      final rating = RatingModel(
        id: repo.generateId(),
        requestId: requestId,
        fromUserId: user.uid,
        toUserId: saathiId,
        stars: state.stars,
        tag: state.tag,
        createdAt: Timestamp.now(),
      );

      await repo.submitRating(rating);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit rating. Please try again.',
      );
    }
  }

  void reset() {
    state = RatingState();
  }
}
