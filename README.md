# Ekub Mobile

> A Flutter app for running traditional Ethiopian ekub (rotating savings) groups: track contributions, turn order, and payouts, built with **Clean Architecture** and **BLoC**.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![State Management](https://img.shields.io/badge/State-BLoC-blueviolet)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## About

An **ekub** is a traditional rotating savings association: a group contributes a fixed amount each round, and one member receives the full pot each cycle until everyone has been paid out once. Most groups still track this on paper or in chat threads, which leads to disputes about who paid and whose turn it is.

Ekub Mobile gives organizers and members a single source of truth: who has paid this round, who gets the payout, and the full schedule ahead. It talks to the [Ekub FastAPI backend](https://github.com/biruksolomon/ekub-backend), which enforces the business rules (turn order, round-closing eligibility, payout tracking).

## Features

- Register and log in with JWT authentication
- View every group you organize or belong to, with live status (pending, active, completed)
- Group dashboard showing the current round, payout recipient, and payment progress
- Organizer checklist to mark members as paid and close the round once everyone has contributed
- Full payout calendar showing the turn order and schedule for every round
- Personal history: your turn order, rounds paid and missed, and next payout round

## Screens

| # | Screen | Purpose |
|---|---|---|
| 1 | Login / Register | Single toggling auth form |
| 2 | My Groups | List of your groups with status chips |
| 3 | Group Dashboard | Current round, payout recipient, progress |
| 4 | Add Contribution | Organizer checklist and close-round action |
| 5 | Payout Calendar | Read-only schedule of every round |
| 6 | Member History | Your own standing within a group |

<!-- Add screenshots here once the UI is built:
<p float="left">
  <img src="docs/screenshots/login.png" width="200" />
  <img src="docs/screenshots/groups.png" width="200" />
  <img src="docs/screenshots/dashboard.png" width="200" />
</p>
-->

## Architecture

The app follows **Clean Architecture**, organized feature-first. Each feature is a vertical slice with its own `data`, `domain`, and `presentation` layers. State is managed with **BLoC**.

```
lib/
├── main.dart
├── injection_container.dart        # get_it dependency wiring
├── core/
│   ├── constants/                  # API constants
│   ├── error/                      # exceptions.dart, failures.dart
│   ├── network/                    # Dio client + auth interceptor
│   ├── theme/                      # colors, ThemeData
│   └── utils/                      # validators
├── features/
│   ├── auth/
│   ├── groups/
│   ├── group_dashboard/
│   ├── contributions/
│   ├── payout_calendar/
│   └── member_history/
│       ├── data/
│       │   ├── datasources/        # Dio calls
│       │   ├── models/             # entities + fromJson/toJson
│       │   └── repositories/       # implements domain contracts
│       ├── domain/
│       │   ├── entities/           # plain Dart classes
│       │   ├── repositories/       # abstract contracts
│       │   └── usecases/           # one class per user action
│       └── presentation/
│           ├── bloc/               # events, states, bloc
│           ├── screens/
│           └── widgets/
└── shared/
    └── widgets/                    # loading, error view, buttons
```

### Dependency rule

```
presentation  ->  domain  <-  data
```

- **Domain** is pure Dart: no Flutter, no Dio, no JSON. It defines entities, repository contracts, and use cases.
- **Data** implements the domain contracts, calls the API, and converts exceptions into `Failure` objects.
- **Presentation** talks to use cases through BLoCs. Widgets never touch repositories or Dio directly.

### BLoC flow

```
UI event  ->  Bloc  ->  UseCase  ->  Repository (contract)  ->  DataSource (Dio)
   ^                                                                    |
   +------------------------ new State <--------------------------------+
```

## Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter |
| State management | flutter_bloc |
| Dependency injection | get_it |
| HTTP | dio |
| Functional error handling | dartz (Either / Failure) |
| Value equality | equatable |
| Secure token storage | flutter_secure_storage |
| Backend | FastAPI + PostgreSQL |

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- A running instance of the [Ekub backend](https://github.com/biruksolomon/ekub-backend)

### Run locally

```bash
git clone https://github.com/biruksolomon/ekub-mobile.git
cd ekub-mobile
flutter pub get
```

Set your backend URL in `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const baseUrl = 'http://10.0.2.2:8000/api/v1'; // Android emulator -> localhost
}
```

Then run:

```bash
flutter run
```

### Tests

```bash
flutter test
```

## Design Decisions

- **Backend is the source of truth.** The app never re-implements ekub rules like "a round can only close when everyone has paid." It calls the endpoint and shows whatever error the service layer returns.
- **Feature-first structure** keeps each slice self-contained and easy to delete or extend, instead of one giant `blocs/` and `screens/` folder.
- **Use cases stay thin.** Each one wraps a single repository call, which keeps BLoCs free of data-layer knowledge and easy to test with mocks.

## Roadmap

- [ ] Create-group and add-member flows
- [ ] Local notifications before a round is due
- [ ] Animated turn-order draw when starting a group
- [ ] Export contribution ledger as CSV/PDF
- [ ] Amharic localization
- [ ] Publish to Google Play

## Related

- **Backend:** [ekub-backend](https://github.com/biruksolomon/ekub-backend) (FastAPI, PostgreSQL, SQLAlchemy)

## Author

**Biruk Solomon**: [GitHub](https://github.com/biruksolomon)

## License

MIT
