Prompt to send to an LLM — implement editable cart features for this Flutter app

Context
- Repo root: c:\Users\ialku\sandwich_shop
- Key files:
  - lib/main.dart (entry; shows OrderScreen(maxQuantity: 5))
  - lib/views/order_screen.dart (order UI)
  - lib/models/sandwich.dart (Sandwich model: type, size, bread)
  - lib/models/cart.dart (Cart model: add/remove/clear, totalPrice)
  - lib/repositories/pricing_repository.dart (pricing by size: six-inch = £7, footlong = £11)
- No network integration; local state only. Keep dependencies to Flutter SDK only.

Goal
Add editable cart functionality so users can modify cart items from the Cart screen. Update UI, repository, and tests. Keep the implementation simple and robust.

Required features (for each, implement UI behavior, repository changes, and tests)

1) Quantity stepper (per cart item)
- Description: Add +/- buttons on each cart row to increment/decrement quantity.
- Expected behavior:
  - Tapping + increments quantity up to maxQuantity (use OrderScreen maxQuantity or Cart-level max if available).
  - Tapping - decrements quantity down to 1 (or 0 if you allow 0 to represent removal).
  - Disable + when quantity == maxQuantity; disable - when quantity == 1 (or 0).
  - Update Cart.totalPrice and cart summary immediately.
  - Visual feedback: small animation or SnackBar "Quantity updated" (optional).
- Repo/API: implement Cart.updateQuantity(cartItemId, newQuantity).
- Tests:
  - Unit: updating quantity recalculates totalPrice.
  - Widget: tap + twice then assert quantity and cart summary updated; + disabled at max.

2) Direct quantity edit
- Description: Allow editing quantity by tapping the quantity label which opens a dialog with numeric input.
- Expected behavior:
  - Validate integer 1..maxQuantity.
  - Confirm updates quantity and totals; cancel leaves unchanged.
  - Show inline error for invalid input.
- Repo/API: reuse Cart.updateQuantity.
- Tests:
  - Input valid -> updates totals.
  - Input invalid -> shows error and no change.

3) Remove item (trash & swipe)
- Description: Add a Remove action (trash icon or Dismissible swipe).
- Expected behavior:
  - Removing deletes the item, updates totals and cart summary.
  - Show SnackBar with "Undo" to restore the removed item within timeout.
- Repo/API: implement Cart.remove(cartItemId) and Cart.restore(cartItem).
- Tests:
  - Remove item updates list and totals.
  - Undo restores item and totals.

4) Edit item options (size, bread, note)
- Description: Allow editing the Sandwich options for a cart item via modal bottom sheet or dialog.
- Expected behavior:
  - Changing size updates item price (use PricingRepository).
  - Update Cart.totalPrice immediately.
  - Edit note persists to cart item and is displayed in list.
- Repo/API: implement Cart.updateItemOptions(cartItemId, {size, bread, note}).
- Tests:
  - Change six-inch -> footlong updates item price and total.
  - Edit note shows the new note.

5) Cart summary UI (permanent)
- Description: Add a persistent cart summary displayed on main screen (bottom bar or header).
- Expected behavior:
  - Shows "Cart: X items — Total: £Y.YY".
  - Updates whenever cart changes.
- Tests:
  - After adding/updating/removing items, cart summary text shows correct count and price.

6) Persistence (optional but requested)
- Description: Persist cart to local storage so it survives app restarts (shared_preferences or a simple JSON file).
- Expected behavior:
  - Cart auto-saves on change; loaded at startup.
  - Tests use a mock or injected storage to avoid disk I/O.
- Tests:
  - Save then load returns same cart.

Implementation constraints & suggestions
- Keep UI standard (ListView for cart, each row: thumbnail, title + options, quantity stepper, price, overflow/ edit/remove).
- Use ModalBottomSheet or AlertDialog for edits.
- Use Dismissible for swipe-to-delete or an IconButton for remove.
- Use SnackBar with Undo action for removes.
- Enforce maxQuantity passed from OrderScreen where relevant.
- Use setState for local state; if required, add minimal Provider only if absolutely needed.

What to output (required)
- Provide code diffs/patches only for the modified files under lib/ and test/.
- For each changed file include a code snippet with file path header comment, e.g.:
  ```dart
  // filepath: lib/views/cart_screen.dart
  // ...existing code...
  { changed code }
  // ...existing code...
  ```
- Include new/updated unit and widget tests under test/ demonstrating the flows above. Tests should be runnable with `flutter test`.
- Explain any new public API added to Cart or repositories in 1–2 lines.

Priority & verification
- Prioritize correctness: stepper, remove+undo, edit options, cart summary.
- Run `flutter analyze` and `flutter test` locally and ensure all tests pass.
- Keep changes minimal and well-documented.

Example short instruction to implement (paste to LLM)
- "Modify lib/models/cart.dart to add updateQuantity/remove/restore/updateItemOptions/persistence methods and update lib/views/cart_screen.dart and lib/views/order_screen.dart to provide UI controls described above. Add tests under test/views/cart_screen_test.dart and test/models/cart_test.dart that assert quantity change, item removal with undo, edit options, and cart summary updates. Use PricingRepository for price calculations. Output diffs only."

Additional notes
- You can also talk about UI requirements or edge cases to handle. For example, reducing quantity below 1 could remove the item.
- Provide screenshots or sample UIs (Deliveroo/Uber Eats) for better styling guidance.
- Save this file as prompt.md in the project root and edit manually if needed.

End of prompt.
```// filepath: c:\Users\ialku\sandwich_shop\prompt.md
Prompt to send to an LLM — implement editable cart features for this Flutter app

Context
- Repo root: c:\Users\ialku\sandwich_shop
- Key files:
  - lib/main.dart (entry; shows OrderScreen(maxQuantity: 5))
  - lib/views/order_screen.dart (order UI)
  - lib/models/sandwich.dart (Sandwich model: type, size, bread)
  - lib/models/cart.dart (Cart model: add/remove/clear, totalPrice)
  - lib/repositories/pricing_repository.dart (pricing by size: six-inch = £7, footlong = £11)
- No network integration; local state only. Keep dependencies to Flutter SDK only.

Goal
Add editable cart functionality so users can modify cart items from the Cart screen. Update UI, repository, and tests. Keep the implementation simple and robust.

Required features (for each, implement UI behavior, repository changes, and tests)

1) Quantity stepper (per cart item)
- Description: Add +/- buttons on each cart row to increment/decrement quantity.
- Expected behavior:
  - Tapping + increments quantity up to maxQuantity (use OrderScreen maxQuantity or Cart-level max if available).
  - Tapping - decrements quantity down to 1 (or 0 if you allow 0 to represent removal).
  - Disable + when quantity == maxQuantity; disable - when quantity == 1 (or 0).
  - Update Cart.totalPrice and cart summary immediately.
  - Visual feedback: small animation or SnackBar "Quantity updated" (optional).
- Repo/API: implement Cart.updateQuantity(cartItemId, newQuantity).
- Tests:
  - Unit: updating quantity recalculates totalPrice.
  - Widget: tap + twice then assert quantity and cart summary updated; + disabled at max.

2) Direct quantity edit
- Description: Allow editing quantity by tapping the quantity label which opens a dialog with numeric input.
- Expected behavior:
  - Validate integer 1..maxQuantity.
  - Confirm updates quantity and totals; cancel leaves unchanged.
  - Show inline error for invalid input.
- Repo/API: reuse Cart.updateQuantity.
- Tests:
  - Input valid -> updates totals.
  - Input invalid -> shows error and no change.

3) Remove item (trash & swipe)
- Description: Add a Remove action (trash icon or Dismissible swipe).
- Expected behavior:
  - Removing deletes the item, updates totals and cart summary.
  - Show SnackBar with "Undo" to restore the removed item within timeout.
- Repo/API: implement Cart.remove(cartItemId) and Cart.restore(cartItem).
- Tests:
  - Remove item updates list and totals.
  - Undo restores item and totals.

4) Edit item options (size, bread, note)
- Description: Allow editing the Sandwich options for a cart item via modal bottom sheet or dialog.
- Expected behavior:
  - Changing size updates item price (use PricingRepository).
  - Update Cart.totalPrice immediately.
  - Edit note persists to cart item and is displayed in list.
- Repo/API: implement Cart.updateItemOptions(cartItemId, {size, bread, note}).
- Tests:
  - Change six-inch -> footlong updates item price and total.
  - Edit note shows the new note.

5) Cart summary UI (permanent)
- Description: Add a persistent cart summary displayed on main screen (bottom bar or header).
- Expected behavior:
  - Shows "Cart: X items — Total: £Y.YY".
  - Updates whenever cart changes.
- Tests:
  - After adding/updating/removing items, cart summary text shows correct count and price.

6) Persistence (optional but requested)
- Description: Persist cart to local storage so it survives app restarts (shared_preferences or a simple JSON file).
- Expected behavior:
  - Cart auto-saves on change; loaded at startup.
  - Tests use a mock or injected storage to avoid disk I/O.
- Tests:
  - Save then load returns same cart.

Implementation constraints & suggestions
- Keep UI standard (ListView for cart, each row: thumbnail, title + options, quantity stepper, price, overflow/ edit/remove).
- Use ModalBottomSheet or AlertDialog for edits.
- Use Dismissible for swipe-to-delete or an IconButton for remove.
- Use SnackBar with Undo action for removes.
- Enforce maxQuantity passed from OrderScreen where relevant.
- Use setState for local state; if required, add minimal Provider only if absolutely needed.

What to output (required)
- Provide code diffs/patches only for the modified files under lib/ and test/.
- For each changed file include a code snippet with file path header comment, e.g.:
  ```dart
  // filepath: lib/views/cart_screen.dart
  // ...existing code...
  { changed code }
  // ...existing code...
  ```
- Include new/updated unit and widget tests under test/ demonstrating the flows above. Tests should be runnable with `flutter test`.
- Explain any new public API added to Cart or repositories in 1–2 lines.

Priority & verification
- Prioritize correctness: stepper, remove+undo, edit options, cart summary.
- Run `flutter analyze` and `flutter test` locally and ensure all tests pass.
- Keep changes minimal and well-documented.

Example short instruction to implement (paste to LLM)
- "Modify lib/models/cart.dart to add updateQuantity/remove/restore/updateItemOptions/persistence methods and update lib/views/cart_screen.dart and lib/views/order_screen.dart to provide UI controls described above. Add tests under test/views/cart_screen_test.dart and test/models/cart_test.dart that assert quantity change, item removal with undo, edit options, and cart summary updates. Use PricingRepository for price calculations. Output diffs only."

Additional notes
- You can also talk about UI requirements or edge cases to handle. For example, reducing quantity below 1 could remove the item.
- Provide screenshots or sample UIs (Deliveroo/Uber Eats) for better styling guidance.
- Save this file as prompt.md in the project root and edit manually if needed.

End of prompt.