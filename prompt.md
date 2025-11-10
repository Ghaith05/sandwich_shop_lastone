## LLM Prompt for Implementing Cart Modification Features in a Flutter Sandwich Shop App

I am building a Flutter app for a sandwich shop. The app has two main pages:
- **Order Screen:** Users select sandwiches and add them to their cart.
- **Cart Screen:** Users view the items in their cart and see the total price.

### Relevant Models and Repository

- **Sandwich (`lib/models/sandwich.dart`):**
  - Has `SandwichType`, `BreadType`, and a `bool isFootlong` for size.
  - Each sandwich has a `name` and an `image` getter for display.
- **Cart (`lib/models/cart.dart`):**
  - Stores a map of `Sandwich` to quantity.
  - Methods: `add(Sandwich, {quantity})`, `remove(Sandwich, {quantity})`, `clear()`, `getQuantity(Sandwich)`.
  - `totalPrice` is calculated using the `PricingRepository`.
  - If removing more than the current quantity, the item is removed entirely.
- **PricingRepository (`lib/repositories/pricing_repository.dart`):**
  - `calculatePrice({required int quantity, required bool isFootlong})` returns the price for a sandwich based on size and quantity.

### Current UI

- The cart page lists each sandwich, its size, bread type, quantity, and price.
- The total price is shown at the bottom.
- There is a "Back to Order" button.

---

## Features to Implement

### 1. Change Quantity of an Item

**Description:**  
Allow users to increase or decrease the quantity of a specific sandwich in their cart.

**Requirements:**  
- Each cart item should display "+" and "–" buttons to adjust quantity.
- Tapping "+" increases the quantity by 1.
- Tapping "–" decreases the quantity by 1.
- If the quantity is reduced below 1, the item should be removed from the cart.
- The total price should update automatically.
- The UI should update immediately to reflect changes.

**Edge Cases:**  
- If the user tries to decrease the quantity when it is 1, the item should be removed.
- Prevent negative quantities.

---

### 2. Remove an Item from the Cart

**Description:**  
Allow users to remove a sandwich from their cart entirely.

**Requirements:**  
- Each cart item should have a "Remove" button (e.g., a trash icon).
- Tapping "Remove" deletes the item from the cart.
- The total price updates accordingly.
- Show a snackbar or other feedback when an item is removed.

---

### 3. Edit Item Details (Optional)

**Description:**  
Allow users to edit details of a sandwich in their cart (e.g., change bread type, size, or sandwich type).

**Requirements:**  
- Each cart item should have an "Edit" button.
- Tapping "Edit" opens a dialog or navigates to a screen to modify sandwich options.
- After saving, the cart updates the item (or replaces it if the combination is new).
- The price and UI update accordingly.

---

### General UI and Behavior Requirements

- All changes should be reflected immediately in the UI.
- The cart's total price should always be accurate.
- The cart should handle empty states gracefully (e.g., show a message if the cart is empty).
- Provide user feedback (e.g., snackbar) for actions like removing or updating items.
- The UI should prevent adding more than a maximum allowed quantity (see `OrderScreen.maxQuantity`).

---

**Please provide Flutter code and UI suggestions to implement these features, using the provided models and repository.**