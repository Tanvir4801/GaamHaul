# GaamHaul

GaamHaul is a local vehicle-hiring marketplace designed for Gujarat villages. 
It connects customers (farmers, nursery workers, shopkeepers, construction workers, etc.) with local vehicle owners (Vahan Saathis) for hourly, half-day, or full-day hires.

## Architecture & Monorepo Structure

This project uses a monorepo structure:

```text
gaamhaul/
│
├── mobile/
│   ├── customer_app/   # Flutter + Dart + Riverpod for customers
│   ├── saathi_app/     # Flutter + Dart + Riverpod for vehicle owners
│   └── shared_package/ # Dart package containing shared models, enums, etc.
│
├── admin_web/          # React + TS + Vite + Tailwind CSS + shadcn/ui for admin dashboard
│
├── functions/          # Firebase Cloud Functions (TypeScript) for backend logic
│
└── README.md
```

## Technologies & Infrastructure

- **Mobile:** Flutter, Dart, Riverpod
- **Admin Web:** React, TypeScript, Vite, Tailwind CSS, shadcn/ui
- **Backend:** Firebase (Authentication, Cloud Firestore, Cloud Functions, Firebase Cloud Messaging)
  - Firestore Region: `asia-south1`
- **Maps:** `flutter_map`, CARTO Voyager (tiles), OpenStreetMap (data), OSRM (routing)

## Important Locked Decisions

- **Single Firebase Project:** (`gaamhaul-prod`) Shared across customer app, saathi app, and admin web.
- **Authentication:** 
  - Customer & Vahan Saathi: Phone / OTP
  - Admin: Email / Password
- **Marketplace Mechanic:** A multi-interest marketplace, not a first-accept dispatch. Customers broadcast a request, multiple Saathis can express interest, and the customer selects one.
- **No Live Tracking:** Saathi locations are captured when going "On Duty" and refreshed periodically. There is NO continuous GPS stream, live vehicle marker, or background tracking.
- **MVP Vehicle Types:** Limited to e_loader, pickup, tempo, mini_truck, and tractor.
- **Security:** Fields like `shortlistedVehicleIds` and `selectedSaathiId` are only writable by trusted Cloud Functions. The `selectSaathi` action must use a Firestore transaction.

## Intentionally NOT Included (Out of Scope for MVP)

- Continuous/background GPS and live tracking
- In-app chat (Phone/WhatsApp are used instead)
- Payment gateways, wallets, or online payments
- Open auction/bidding
- Automated OCR document verification
- Passenger ride-hailing (GaamRide)
- Premium glassmorphism UI or excessive animations at the expense of performance
