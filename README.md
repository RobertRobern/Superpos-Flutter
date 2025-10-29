# Rovent SuperPOS

A comprehensive, scalable Android POS system tailored for supermarkets, built with Flutter.

## Project Overview

Rovent SuperPOS is a feature-rich point-of-sale system designed specifically for supermarket operations in Kenya. It offers seamless integration with hardware peripherals, robust inventory management, and compliance with local tax regulations.

## Development Phases

### Phase 1: Core Setup and Basic POS Features
- Basic application architecture and UI components
- Product and cart management
- Core POS screen layout
- Authentication system
- Theme and routing setup

### Phase 2: Hardware Integration
- Bluetooth and USB thermal printer support
- Barcode scanner integration
- Scale integration for weighted items
- Receipt customization and printing

### Phase 3: Payment Processing
- Cash transaction handling
- Card payment integration
- Mobile money integration
- Digital wallet support
- Payment workflow management

### Phase 4: Inventory Management
- Real-time stock tracking
- Automated low-stock alerts
- Purchase order generation
- Barcode label printing
- Multi-location inventory sync

### Phase 5: Analytics and CRM
- Sales analytics dashboard
- Customer loyalty program
- SMS notification system
- Personalized marketing tools
- Performance reporting

### Phase 6: Advanced Features
- Cloud synchronization
- Offline transaction support
- e-TIMS integration
- AI-driven inventory forecasting
- Multi-store management

## Project Structure — Feature‑First Layered Architecture

This repository follows a Feature‑First Layered Architecture: features are the primary organizing unit, and each feature is split into the conventional layers (data, domain, presentation). Core/shared utilities that are cross‑feature live under `lib/core` and `lib/shared` respectively. This keeps feature code co‑located for easier navigation and independent delivery while preserving clean separation of concerns.

High level layout:

```
lib/
├── core/                      # Cross-cutting infrastructure and utilities
│   ├── database/              # Local DB adapters (sqflite), migrations
│   ├── error/                 # Error and exception handling
│   ├── network/               # API clients, interceptors, connectivity
│   ├── routes/                # App routing logic
│   ├── themes/                # App themes and styling
│   ├── utils/                 # Shared helpers and constants
│   └── widgets/               # Reusable UI components
├── features/                  # Feature-first folders
│   ├── auth/                  # Authentication feature
│   │   ├── data/              # models, datasources, repositories implementations
│   │   ├── domain/            # entities, repositories interfaces, usecases
│   │   └── presentation/      # pages, blocs/cubits, widgets
│   ├── pos/                   # Point of Sale (checkout) feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── bloc/          # or cubit/provider/controllers
│   │       └── widgets/
│   ├── inventory/             # Inventory management feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── payments/              # Payment handling and integrations
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── analytics/             # Sales analytics, reports, CRM
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/                    # Cross-feature models and shared widgets
│   ├── models/
│   └── widgets/
└── main.dart                  # App entry point & dependency injection bootstrap
```

Notes and conventions:
- Keep feature internals private to the feature and expose only domain-level interfaces (repositories/usecases) to other features.
- Use dependency injection (e.g. `get_it`) configured in `main.dart` to wire implementations.
- `core/` contains infrastructure that may be replaced (e.g. switching DB or HTTP client) without touching feature logic.
- Tests and integration harnesses should mirror this layout under `test/`.

This structure makes it easier to add new features (e.g. promotions, e-TIMS integration, SMS gateway) with minimal cross-cutting changes.

## Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Android Studio / VS Code
- Physical or virtual Android device
- Bluetooth thermal printer (for testing)
- Barcode scanner (for testing)

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure your local development environment
4. Run the app using `flutter run`

## Contributing
Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
