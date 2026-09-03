# 🛒 3Z Insta Cart - Flutter Mobile App

A modern, responsive, offline-first mobile application for **3Z Insta Cart** built with **Flutter 3.x, Dart 3.x, and BLoC Cubit** state management.

---

## 🚀 Key Features

- **🛍️ Rich Grocery Catalog & Categorization**:
  - Over 27+ grocery products across 10 categories: `Produce`, `Dairy & Eggs`, `Bakery`, `Beverages`, `Snacks`, `Pantry`, `Meat & Seafood`, `Frozen`, `Organic`, and `Household`.
  - Real-time search with instant query filtering and category chip selector.
  - Organic badges, discount tags (`SALE`), product ratings, and stock tracking.
- **🛒 Dynamic Shopping Cart**:
  - Incremental quantity controls with instant item addition.
  - Automated financial formulas: subtotal, 7% sales tax, and tiered delivery fee ($3.99 / FREE over $35.00).
  - Dynamic progress indicator: *"Add $X.XX more for FREE delivery!"*
- **⚡ Zero-Auth Instant Checkout**:
  - No login/registration barrier required — uses demo guest profile (`Alice Johnson`) with customizable delivery address and instructions.
  - Multiple simulated payment options (Apple Pay / Credit Card, 3Z Wallet).
- **📦 Real-Time Order Lifecycle Simulation**:
  - Simulated pending order advancement: `Pending` $\rightarrow$ `Order Confirmed` $\rightarrow$ `Shopper Preparing` $\rightarrow$ `Out for Delivery` $\rightarrow$ `Delivered`.
  - Interactive **"Advance Step"** simulation controller for instant demo testing and verification.
  - Step timeline tile tracker with live ETA and item review.

---

## 🏗️ Architecture & Design Decisions

### 1. State Management: BLoC / Cubit Pattern
This app implements the **BLoC (Cubit)** architectural pattern to ensure predictable state transitions, clean separation of concerns, and high testability:

- **`CatalogCubit`**: Manages product fetching, search queries, and category filtering.
- **`CartCubit`**: Handles cart item additions, quantity modifications, subtotal, tax (7%), and delivery fee computation.
- **`OrderCubit`**: Handles instant checkout, atomic inventory deduction, and stream-based order state updates.

### 2. Clean Architecture Layering
```
lib/
├── core/                                     # Theme, design tokens, formatters, constants
│   ├── theme/ (app_colors.dart, app_theme.dart)
│   ├── constants/ (app_constants.dart)
│   └── utils/ (currency_formatter.dart)
├── data/                                     # Models, in-memory data sources, repositories
│   ├── models/ (category, product, cart_item, order, customer)
│   ├── datasources/ (mock_grocery_data.dart)
│   └── repositories/ (catalog_repo, cart_repo, order_repo)
├── logic/                                    # Reactive Cubits & States
│   ├── catalog/ (catalog_cubit.dart, catalog_state.dart)
│   ├── cart/ (cart_cubit.dart, cart_state.dart)
│   └── order/ (order_cubit.dart, order_state.dart)
└── presentation/                             # UI Layer (Screens & Widgets)
    ├── screens/
    │   ├── splash/ (splash_screen.dart)
    │   ├── main/ (main_nav_screen.dart)
    │   ├── home/ (home_screen.dart)
    │   ├── product_detail/ (product_detail_screen.dart)
    │   ├── cart/ (cart_screen.dart)
    │   ├── checkout/ (checkout_screen.dart)
    │   ├── order_success/ (order_success_screen.dart)
    │   └── orders/ (orders_list_screen.dart, order_tracking_screen.dart)
    └── widgets/ (product_card, category_chip, cart_badge_icon, status_timeline_tile)
```

### 3. Key Design Decisions Made
1. **Self-Contained / Offline First**:
   - Instead of requiring an active network backend, the app embeds a comprehensive mock dataset and local repository that simulates network operations, stock validation, and order state machines.
2. **Deterministic Financial Math**:
   - Rounding formulas guarantee exact currency parity with the Spring Boot, Python/Flask, Node.js, and Laravel backends.
3. **Automatic & Manual Order Simulation**:
   - Orders auto-advance through realistic timer transitions (3s, 7s, 13s, 20s) while also giving reviewers a manual **"Advance Step"** button to jump directly to any state.

---

## 📦 How to Run the App

### 📋 Prerequisites
- **Flutter SDK**: `>= 3.13.2` (Verified on Flutter `3.47.2`)
- **Xcode** (for iOS simulator / macOS) or **Android Studio** (for Android emulator).

---

### 1. Install Dependencies
```bash
cd /Users/peterperez/Documents/Androidstudioprojects/threezinstacart
flutter pub get
```

---

### 2. Run Automated Tests
```bash
flutter test
```
*Executes all 9 unit and cubit integration tests covering catalog search, cart calculations, and order simulation.*

---

### 3. Analyze Code Quality
```bash
flutter analyze
```

---

### 4. Launch on Device / Emulator

```bash
# Check available devices
flutter devices

# Run on macOS desktop
flutter run -d macos

# Or run on iOS Simulator
flutter run -d iPhone

# Or run on Android Emulator
flutter run -d android

# Or run in Chrome (Web)
flutter run -d chrome
```

---

## 🧪 Testing Coverage

The automated test suite verifies:
- `CatalogCubit`: Category switching, keyword searching, and best seller extraction.
- `CartCubit`: Quantity updates, 7% sales tax calculation, and free delivery thresholds ($35+).
- `OrderCubit`: Atomic stock deduction upon checkout, order tracking number generation, and step advancement.
# 3Z-Insta-Cart-Flutter-App
