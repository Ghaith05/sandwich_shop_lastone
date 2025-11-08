
# Sandwich Shop App

A simple Flutter app for managing sandwich orders. Users can select sandwich size, add special notes, and increment or decrement their order count with intuitive controls. The app demonstrates clean state management, custom styling, and modern Flutter UI patterns.

## Features
- Choose between Footlong and 6-inch sandwiches
- Add special notes to your order (e.g., "no onions", "extra pickles")
- Increment and decrement sandwich quantity (Add/Remove buttons)
- Buttons are automatically disabled at quantity bounds (0 and max)
- Shared text styles via `app_styles.dart`
- Responsive UI with dropdown selection and input field


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
```sh
flutter run
```

## Usage
- Select sandwich size from the dropdown (Footlong or 6-inch)
- Enter a note in the text field (optional)
- Press **Add** to increase the quantity (up to the max, default 5)
- Press **Remove** to decrease the quantity (down to 0)
- Add/Remove buttons are disabled at their respective bounds
- The current order and note are displayed at the top

### Running Tests
```sh
flutter test
```

## Project Structure & Technologies
```
lib/
  main.dart           # Main app logic and UI
  app_styles.dart     # Shared text styles (normalText, heading1)
  ...
test/
  ...                 # Widget and unit tests
```
- **Flutter** for UI and state management
- **Dart** as the programming language
- **Material Design** widgets

## Known Issues / Limitations
- No persistent storage (orders reset on restart)
- No authentication or backend
- Only two sandwich sizes (easy to extend)
- UI is basic but easy to customize via `app_styles.dart`

## Contribution
Pull requests and issues are welcome! Please fork the repo and open a PR with your changes.

## Contact
- Author: [Your Name]
- GitHub: [Ghaith05](https://github.com/Ghaith05)
- Email: [Ghaithahmadalsawair73@gmail.com]

---
_This README is regularly updated. Please check back for the latest instructions and features._
