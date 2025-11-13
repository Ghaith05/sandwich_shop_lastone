
# Sandwich Shop App

A feature-rich Flutter application for ordering sandwiches with shopping cart functionality, order history, and persistent storage. Built with clean architecture, comprehensive testing, and modern Flutter best practices.

## Features

### 🥪 **Order Management**
- Browse multiple sandwich types (Veggie Delight, Chicken Teriyaki, Tuna Melt, Meatball Marinara)
- Choose between Footlong and Six-inch sizes
- Select bread type (White, Wheat, Italian, Multigrain)
- Add quantity with intuitive controls
- Add special notes to orders
- Real-time sandwich image preview

### 🛒 **Shopping Cart**
- Add multiple sandwiches to cart
- View all items with quantities and prices
- Edit quantities (increment/decrement)
- Remove items from cart
- See total price calculation
- Navigate to checkout

### 💳 **Checkout & Payment**
- Review order summary with itemized pricing
- Simulated payment processing with loading indicator
- Order confirmation with unique order ID
- Automatic cart clearing after successful payment
- Orders saved to local database

### 📜 **Order History**
- View all past orders
- See order details (ID, items, total, date/time)
- Persistent storage using SQLite database
- Formatted order information

### 🎨 **User Experience**
- Clean, modern Material Design UI
- Custom app logo and branding
- Responsive layout with proper spacing
- Profile screen for user information
- Adjustable font size settings
- Navigation between multiple screens

### 🗄️ **Data Persistence**
- SQLite database integration
- Desktop platform support (Windows, Linux, macOS)
- Order history saved locally
- Cross-platform compatibility

## Screenshots

| Order Screen | Cart Screen | Checkout Screen | Order History |
|-------------|-------------|-----------------|---------------|
| Browse sandwiches | Manage cart | Review & pay | View past orders |

## Installation & Setup

### Prerequisites
- Windows, macOS, or Linux
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or newer recommended)
- Git

### Clone the Repository
```sh
git clone https://github.com/Ghaith05/sandwich_shop_lastone.git
cd sandwich_shop_lastone
```

### Install Dependencies
```sh
flutter pub get
```

### Run the App

**On Windows:**
```sh
flutter run -d windows
```

**On macOS:**
```sh
flutter run -d macos
```

**On Linux:**
```sh
flutter run -d linux
```

**On Mobile (Android/iOS):**
```sh
flutter run
```

## Usage

### Ordering Sandwiches
1. Select sandwich type from dropdown
2. Choose size (toggle between Six-inch and Footlong)
3. Select bread type
4. Set quantity using +/- buttons
5. Add optional notes
6. Tap "Add to Cart"

### Managing Cart
1. Tap "View Cart" to see all items
2. Adjust quantities with +/- buttons
3. Remove items with trash icon
4. View total price
5. Tap "Checkout" when ready

### Checkout Process
1. Review order summary
2. Verify payment method (Card ending in 1234)
3. Tap "Confirm Payment"
4. Wait for processing (with loading indicator)
5. Receive order confirmation
6. Order automatically saved to history

### Viewing Order History
1. From main screen, navigate to "Order History"
2. View all past orders with:
   - Order ID
   - Total amount
   - Item count
   - Order date and time

### Settings
- Adjust font size for better readability
- View profile information
- Settings persist across app restarts

## Testing

The app includes comprehensive test coverage:

### Run All Tests
```sh
flutter test
```

### Test Coverage
- **Unit Tests**: 20 tests
  - SavedOrder model (8 tests)
  - DatabaseService (12 tests)
- **Widget Tests**: 98+ tests
  - OrderScreen tests
  - CartScreen tests
  - CheckoutScreen tests
  - OrderHistoryScreen tests
  - ProfileScreen tests
  - SettingsScreen tests

### Run Specific Tests
```sh
flutter test test/models/saved_order_test.dart
flutter test test/services/database_service_test.dart
flutter test test/views/
```

## Project Structure

```
lib/
  main.dart                     # App entry point with SQLite initialization
  models/
    cart.dart                   # Shopping cart model (ChangeNotifier)
    sandwich.dart               # Sandwich model with enums
    saved_order.dart            # Order model for database
  services/
    database_service.dart       # SQLite database operations
  repositories/
    pricing_repository.dart     # Price calculation logic
  views/
    order_screen.dart           # Main sandwich ordering screen
    cart_screen.dart            # Shopping cart view
    checkout_screen.dart        # Checkout and payment
    order_history_screen.dart   # Order history display
    profile_screen.dart         # User profile
    settings_screen.dart        # App settings
    app_styles.dart            # Shared styling
    styled_button.dart         # Custom button widget
    
assets/
  images/                       # Sandwich images and logo
  sandwiches.json              # Sandwich data (if used)

test/
  models/                       # Model unit tests
  services/                     # Service unit tests
  views/                        # Widget tests
  repositories/                 # Repository tests
```

## Technologies & Packages

### Core
- **Flutter** - UI framework
- **Dart** - Programming language

### State Management
- **Provider** (^6.1.2) - State management solution

### Database
- **sqflite** (^2.4.2) - SQLite database for mobile
- **sqflite_common_ffi** (^2.3.6) - SQLite for desktop platforms
- **path** (^1.9.1) - File path manipulation

### Development
- **flutter_test** - Testing framework
- **flutter_lints** - Code linting

## Architecture

### Design Patterns
- **MVVM** (Model-View-ViewModel) architecture
- **Repository Pattern** for data access
- **Provider** for state management
- **Singleton** pattern for database service

### Key Components
- **Models**: Data structures (Cart, Sandwich, SavedOrder)
- **Services**: Business logic (DatabaseService)
- **Repositories**: Data operations (PricingRepository)
- **Views**: UI screens and widgets

## Database Schema

### Orders Table
```sql
CREATE TABLE orders(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId TEXT NOT NULL,
  totalAmount REAL NOT NULL,
  itemCount INTEGER NOT NULL,
  orderDate INTEGER NOT NULL
)
```

## Known Features & Capabilities

✅ Multi-screen navigation
✅ Shopping cart with state management
✅ Order persistence with SQLite
✅ Desktop platform support (Windows, Linux, macOS)
✅ Comprehensive test coverage (118+ tests)
✅ Custom styling and theming
✅ Image assets and branding
✅ Order history tracking
✅ Payment simulation
✅ Settings persistence

## Future Enhancements

- [ ] User authentication
- [ ] Backend API integration
- [ ] Payment gateway integration
- [ ] Order tracking and status updates
- [ ] Multiple payment methods
- [ ] Delivery address management
- [ ] Favorites and saved orders
- [ ] Order modification/cancellation
- [ ] Receipt generation and printing
- [ ] Analytics and reporting

## Contribution

Pull requests and issues are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Write tests for new features
- Follow existing code style
- Update documentation as needed
- Ensure all tests pass before submitting PR

## Contact

- **Author**: Ghaith Ahmad Alsawair
- **GitHub**: [Ghaith05](https://github.com/Ghaith05)
- **Email**: Ghaithahmadalsawair73@gmail.com

## License

This project is available for educational purposes.

---

**Note**: This app was developed as part of a Flutter learning project and demonstrates core concepts including state management, database integration, widget testing, and cross-platform development.

_Last updated: November 2025_
