# Editable Cart — Requirements Document

This document defines the "Editable Cart" feature for Sandwich Shop. It consolidates the feature purpose, user stories, acceptance criteria, subtasks, data contracts, edge cases, and test requirements so developers and QA can implement and validate the feature consistently.

---

## 1. Feature description and purpose

### 1.1 Description
The Editable Cart feature allows users to manage items in their shopping cart before checkout. Core capabilities include:
- Edit item options (e.g., size: six-inch vs footlong; bread type).
- Change item quantity (increment and decrement) for existing cart entries.
- Remove items from the cart.
- Optionally persist the cart across app restarts (local persistence).
- Provide immediate feedback (SnackBar/toast) and an Undo option for removals.
- Ensure UI and model stay in sync and pricing updates correctly.

### 1.2 Purpose / Value
- Improve UX by letting customers adjust orders without navigating back to product screens.
- Reduce abandonment by making corrections easy.
- Prevent duplicate cart entries by merging edited items (if edited item matches an existing entry, quantities should merge).
- Provide safety (undo) for accidental removals.

---

## 2. Users and roles (who interacts)

- Shopper (anonymous guest): Uses cart in a single session; can add/edit/remove items.
- Registered user: Same capabilities as guest; if persistence is enabled, cart persists across sessions.
- QA/Test engineer: Validates behavior with unit and widget tests.
- Developer: Implements model and UI changes; ensures tests and migrations.
- Product manager / Designer: Reviews UX flows and acceptance criteria.

---

## 3. User stories

Each story follows the format: role — goal — reason.

1. Shopper — Edit item options in the cart — So I can change size or bread without re-ordering.
   - Acceptance: Open edit modal for a cart row, change size and/or bread, save, and see updated line price and cart total.

2. Shopper — Change quantity of an item in the cart — So I can order more or fewer of the same sandwich.
   - Acceptance: Increment and decrement controls update line quantity and price; quantity never drops below 0 or a defined minimum (1 for active item, or 0 if removal flow).

3. Shopper — Remove an item from the cart — So I can delete an item I no longer want.
   - Acceptance: Remove button deletes the item and updates cart total; a SnackBar provides an Undo action that restores the removed item.

4. Shopper (registered) — Have my cart persist across app restarts — So I don't lose my selections between sessions.
   - Acceptance: If persistence enabled, cart reloads on app start; modifications persist.

5. Shopper — Edit an item so it merges with an identical existing item — So quantities consolidate and prices remain accurate.
   - Acceptance: If the edited options create a sandwich that equals an existing cart key, their quantities are merged and total is updated.

6. QA — The feature must be testable — So automated unit and widget tests verify behavior.
   - Acceptance: Unit tests for model behavior (add/remove/replace/merge) and widget tests for UI actions (open edit sheet, save changes, remove with Undo, quantity controls).

---

## 4. Acceptance criteria (detailed)

This section lists criteria that must be satisfied for the feature to be considered complete. Each item is testable and verifiable.

### 4.1 Edit item options
- Given a cart with at least one item, when the user taps Edit on an item, the app opens an edit sheet/dialog/panel pre-populated with the item’s current options (size, bread).
- User can toggle size and select a bread type.
- When the user saves:
  - If the edited sandwich matches an existing cart entry (e.g., same type, same size, same bread), the system merges quantities (sum of both).
  - Otherwise, the system replaces the original cart key with a new key representing the edited sandwich, preserving the original quantity.
  - The cart total, item line price, and cart item listing update immediately.
- Model-level API must provide an atomic operation for replace-or-merge (example: `Cart.replaceItem(old, updated)` or `Cart.updateItem(old, updated)`).

### 4.2 Quantity editing
- Each cart item row has controls to increase and decrease quantity.
- Increasing quantity increments the line's quantity by 1 and updates the line price and total.
- Decreasing quantity decrements quantity by 1 and updates prices immediately.
- If quantity reaches 0 as a result of decrement, the item must either be removed automatically or present a confirmation depending on UX decision; if auto-removed, a SnackBar with Undo must be displayed.
- Quantity cannot be set to a negative number.

### 4.3 Remove item + Undo
- Remove action deletes the item from the cart and updates totals.
- After removal, show SnackBar with an Undo button that:
  - Is visible for the typical SnackBar duration (e.g., 3–6 seconds).
  - Restores the deleted item with its previous quantity when tapped.
- If Undo is not tapped before timeout, the deletion is final.

### 4.4 Persistence (optional / configurable)
- If enabled by product, cart state persists to device local storage (e.g., SharedPreferences, local file, or other platform-appropriate persistence).
- On app startup, if a saved cart exists and is valid, load it into memory.
- Migration/backwards compatibility: saved data must be resilient to new enum values or slight model changes.
- Persistence should not block UI; read happens asynchronously on app startup and UI shows the loaded cart once ready.

### 4.5 Pricing correctness
- Pricing uses the canonical `PricingRepository` to compute line prices. E.g., six-inch = £7.00, footlong = £11.00 (or project-specific constants).
- After any edit, increment, decrement, or merge, the line price and cart total must reflect current `PricingRepository` calculations.

### 4.6 Concurrency and atomicity
- Model-level operations that change keys (replace/merge) must be atomic with respect to the quantity update to avoid lost updates.
- UI should reflect operations optimistically, and non-fatal failures (rare) should provide clear error feedback.

### 4.7 Accessibility & internationalization
- Buttons and inputs must be accessible (a11y labels, proper semantics).
- Currency values must be formatted consistently using app-wide utilities and consider locale formatting (decimal separator, currency symbol).
- All strings should be localizable.

### 4.8 Tests
- Unit tests for Cart model:
  - add, remove (partial), remove completely, getQuantity
  - replaceItem(old, updated) behavior: preserve quantity, merge if necessary, update total.
  - Behavior when removing non-existent items is a no-op (no thrown exceptions).
- Widget tests:
  - CartScreen displays items and totals.
  - Edit flow: tapping Edit opens modal, saving with changes updates UI and model.
  - Quantity controls update line and total.
  - Remove action shows SnackBar; Undo restores the item.
  - Persistence load behavior (if persistence implemented) — stub persistence layer and verify restore.

---

## 5. Subtasks (work breakdown)

Below are suggested subtasks suitable for sprint planning. Each subtask includes expected acceptance checks.

1. Subtask: Design UX for edit modal and quantity controls
   - Deliverables: mockup for cart row, edit sheet, Undo SnackBar text.
   - Acceptance: PM/Designer sign-off.

2. Subtask: Model API additions
   - Add method: `Cart.replaceItem(Sandwich oldItem, Sandwich newItem)` (atomic replace-or-merge).
   - Add method: `Cart.removeCompletely(Sandwich item)` (explicit removal).
   - Add any helper methods needed for persistence (toJson/fromJson).
   - Acceptance: Unit tests for model-level operations pass.

3. Subtask: CartScreen UI updates
   - Display cart rows as cards with thumbnail, name, size/bread text, combined quantity+price text, Edit and Delete buttons, and quantity controls.
   - Integrate edit sheet UI (pre-populated) and wire Save to `replaceItem`.
   - Acceptance: Widget tests for CartScreen pass.

4. Subtask: Undo for deletes
   - Implement SnackBar with Undo that restores item.
   - Acceptance: Widget test verifies remove then Undo restores the item.

5. Subtask: Persistence (optional)
   - Implement local persistence using platform-appropriate store (e.g., SharedPreferences for mobile).
   - Ensure serialization and deserialization of sandwich and cart types are stable.
   - Acceptance: Integration test or widget test stubs persistence and verifies restore on app startup.

6. Subtask: Tests and CI
   - Add/extend unit and widget tests.
   - Ensure tests run in CI and coverage criteria for the feature are met.
   - Acceptance: CI run completes with all tests green.

7. Subtask: Documentation & changelog
   - Document public API changes on `Cart`, update README or developer docs.
   - Acceptance: README contains a brief note explaining new APIs and migration steps for saved cart format.

---

## 6. Data contract & API guidance

- Sandwich (existing model)
  - Fields: type (SandwichType enum), isFootlong (bool), breadType (BreadType enum), name getter, image getter.
  - Must implement equality/hashCode consistent with identity used in the cart key (so keys that represent the same options compare equal).

- Cart (model)
  - Existing: Map<Sandwich,int> items, add(...), remove(...), totalPrice getter.
  - Required: New/updated methods:
    - replaceItem(Sandwich oldItem, Sandwich newItem):
      - Behavior: If oldItem not found → no-op (or throw? prefer no-op).
      - Removes oldItem key and either inserts newItem with preserved quantity or merges quantity into an existing newItem entry.
      - Returns boolean or void; unit tests validate state.
    - removeCompletely(Sandwich item):
      - Behavior: remove the key regardless of quantity.
    - getQuantity(Sandwich item) -> int.
    - (Optional) toJson/fromJson for persistence.

- PricingRepository
  - Single source of truth for prices; use to compute line price in UI and tests.

---

## 7. Edge cases and constraints

- Editing to produce an identical item:
  - If the edit result equals an existing key, merge quantities and delete the original entry.
- Collisions from object identity:
  - Ensure Sandwich equality/hashCode is implemented on value semantics (type + size + bread), not referential identity.
- Race conditions:
  - If two UI events operate simultaneously (unlikely in single-threaded Flutter), ensure model operations retain a consistent final state. Use setState and synchronous model calls carefully.
- Invalid persisted data:
  - If persisted cart fails to parse, clear it and log a warning; do not crash the app.
- Currency/rounding:
  - Use consistent rounding rules (2 decimal places) across UI and tests.
- Accessibility:
  - Ensure Tap/press targets meet size guidelines.

---

## 8. Non-functional requirements

- Performance: Cart updates are local and must be instantaneous; no network calls on edit.
- Reliability: All model operations must be deterministic and covered by unit tests.
- Local storage (persistence): Writes should be fast and performed asynchronously; do not block main UI thread.
- Security: Do not persist sensitive user data. Cart contains only order choices (non-sensitive).

---

## 9. Test matrix (suggested tests)

- Unit tests (Cart):
  - add: adding same Sandwich increments quantity.
  - remove (partial): removing quantity decrements appropriately.
  - removeCompletely: item no longer present.
  - replaceItem: preserves quantity and merges when needed.
  - totalPrice: sums line prices from PricingRepository.

- Widget tests (CartScreen & Edit flow):
  - CartScreen shows empty message for empty cart.
  - CartScreen renders item rows correctly with combined text "Qty: X - £Y.YY".
  - Tap Edit opens modal with pre-selected options; saving changes updates UI.
  - Tap Delete removes item and shows SnackBar; tap Undo restores.
  - Quantity increment/decrement buttons update lines and total.
  - Persistence (if implemented): simulate saved state and verify load.

- Integration / manual checks:
  - UX sign-off: Visual verification of modal, spacing, buttons.
  - Localization test: Visual verification for different locales (currency formatting).

---

## 10. Acceptance checklist (quick-run)

- [ ] Model: `replaceItem`, `removeCompletely`, and unit tests implemented and passing.
- [ ] UI: CartScreen shows card rows with thumbnail, details, combined qty+price string.
- [ ] Edit modal: Pre-populated options and Save wires to model.
- [ ] Remove: Delete action removes item and SnackBar Undo restores.
- [ ] Quantity: Increase/decrease controls work and prevent negative values.
- [ ] Pricing: PricingRepository used for all price calculations; totals are correct.
- [ ] Tests: All unit and widget tests pass locally and in CI.
- [ ] Docs: README or developer docs updated for changed API and persistence format (if used).
- [ ] Accessibility & i18n: Buttons and text are accessible and strings localizable.

---

## 11. Risks and mitigations

- Risk: Sandwich equality not implemented correctly leads to duplicate keys or failed merges.
  - Mitigation: Add unit tests for Sandwich equality and ensure value-based equality/hashCode.

- Risk: Persistence format changes could break stored carts.
  - Mitigation: Implement versioned serialization and safe fallback (discard corrupt data gracefully).

- Risk: UI tests brittle due to precise widget tree structure.
  - Mitigation: Prefer semantic lookups (by text/semantics label) rather than exact widget hierarchy.

---

## 12. Timeline & sizing (rough estimate)
(Estimate for an experienced Flutter developer)

- Design & review: 0.5 - 1 day
- Model changes + unit tests: 0.5 - 1 day
- UI changes + widget tests: 1 - 2 days
- Undo and polish: 0.5 day
- Optional persistence: 1 day
- Buffer & QA: 0.5 day

---

## 13. Deliverables
- Requirements (this document)
- Code changes:
  - `lib/models/cart.dart` (API additions)
  - `lib/views/cart_screen.dart` (UI + edit modal)
  - Optional: `lib/services/cart_persistence.dart` or similar
- Tests:
  - Unit tests under `test/models/`
  - Widget tests under `test/views/`
- Developer docs/README update

---

If you want, I can now:
- Convert this into a formal ticket (title, acceptance criteria in Gherkin) and add estimated story points; or
- Generate the test skeletons for unit and widget tests and apply code patches to your repo to implement them.

Which next step do you want me to take?
