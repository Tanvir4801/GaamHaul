import '../enums/vehicle_type.dart';
import '../enums/duration_type.dart';
import '../models/price_range.dart';
import '../models/rate_card_model.dart';

class RateCardCalculator {
  static final Map<VehicleType, RateCardModel> _seedRateCards = {
    VehicleType.eLoader: RateCardModel(
      id: 'seed_e_loader',
      vehicleType: VehicleType.eLoader,
      oneHour: const PriceRange(min: 150, max: 200),
      twoHour: const PriceRange(min: 250, max: 350),
      halfDay: const PriceRange(min: 600, max: 800),
      fullDay: const PriceRange(min: 1000, max: 1400),
    ),
    VehicleType.pickup: RateCardModel(
      id: 'seed_pickup',
      vehicleType: VehicleType.pickup,
      oneHour: const PriceRange(min: 200, max: 300),
      twoHour: const PriceRange(min: 350, max: 500),
      halfDay: const PriceRange(min: 900, max: 1200),
      fullDay: const PriceRange(min: 1500, max: 2000),
    ),
    VehicleType.tempo: RateCardModel(
      id: 'seed_tempo',
      vehicleType: VehicleType.tempo,
      oneHour: const PriceRange(min: 300, max: 450),
      twoHour: const PriceRange(min: 500, max: 700),
      halfDay: const PriceRange(min: 1200, max: 1600),
      fullDay: const PriceRange(min: 2000, max: 2800),
    ),
    VehicleType.miniTruck: RateCardModel(
      id: 'seed_mini_truck',
      vehicleType: VehicleType.miniTruck,
      oneHour: const PriceRange(min: 400, max: 600),
      twoHour: const PriceRange(min: 700, max: 1000),
      halfDay: const PriceRange(min: 1600, max: 2200),
      fullDay: const PriceRange(min: 2800, max: 3800),
    ),
    VehicleType.tractor: RateCardModel(
      id: 'seed_tractor',
      vehicleType: VehicleType.tractor,
      oneHour: const PriceRange(min: 350, max: 500),
      twoHour: const PriceRange(min: 600, max: 850),
      halfDay: const PriceRange(min: 1400, max: 1800),
      fullDay: const PriceRange(min: 2200, max: 3000),
    ),
  };

  /// Retrieves the static rate card for a given vehicle type.
  static RateCardModel getRateCard(VehicleType type) {
    final card = _seedRateCards[type];
    if (card == null) {
      throw ArgumentError('Rate card not found for vehicle type: $type');
    }
    return card;
  }

  /// Calculates the estimated price range based on the rate card and requested duration.
  static PriceRange calculateEstimatedPrice({
    required VehicleType vehicleType,
    required DurationType durationType,
  }) {
    final card = getRateCard(vehicleType);

    switch (durationType) {
      case DurationType.oneHour:
        return card.oneHour;
      case DurationType.twoHour:
        return card.twoHour;
      case DurationType.halfDay:
        return card.halfDay;
      case DurationType.fullDay:
        return card.fullDay;
      case DurationType.custom:
        // Custom falls back to 1 hour min, and full day max as a broad baseline for MVP.
        return PriceRange(min: card.oneHour.min, max: card.fullDay.max);
    }
  }
}
