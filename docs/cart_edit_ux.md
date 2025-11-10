# Cart Edit UX

Purpose: Document the visual layout and interactions for the "Edit item" modal and cart quantity controls so developers can implement a consistent experience.

Overview
- The Edit modal is opened from the cart row's Edit icon.
- It is a bottom sheet (modal) on mobile and a centered dialog on larger screens.
- The modal shows:
  - Title: `Edit <Sandwich name>`
  - Current thumbnail on the left
  - Options:
    - Size selector: a segmented control or Switch for "Six-inch" / "Footlong"
    - Bread selector: dropdown or radio list for BreadType values
  - Quantity controls: small stepper with `-` and `+` buttons and a numeric label between
  - Save and Cancel buttons
  - Inline summary line: `Qty: X - £Y.YY` (uses PricingRepository for price)

Accessibility
- All controls must have semantic labels.
- Buttons must meet minimum touch target size.
- Colors should keep adequate contrast.

Behavior
- Save: closes sheet and applies changes via `Cart.replaceItem(old, updated)` (atomic replace-or-merge).
- Cancel: closes sheet without changes.
- Quantity stepper: updates the previewed price immediately; if quantity goes to 0, show a confirm remove or allow Save to replace with quantity 0 (prefer confirm UX).

Notes for developers
- Provide a `CartEditModal` widget that accepts the `Sandwich` to edit, current quantity, and two callbacks: `onSave(Sandwich updated, int quantity)` and `onCancel()`.
- The widget should be self-contained and testable without coupling to `Cart`.

Design tokens / spacing
- Padding: 16dp
- Spacing between form elements: 8dp
- Primary action: filled button (Save)
- Secondary action: text button (Cancel)

Example usage (pseudocode):

```dart
showModalBottomSheet(context: ctx, builder: (_) => CartEditModal(
  sandwich: sandwich,
  quantity: qty,
  onSave: (updated, q) => cart.replaceItem(sandwich, updated, quantity: q),
  onCancel: () => Navigator.pop(ctx),
));
```
