# HarmonyOS Business Trip Reimbursement Mini Program

A corporate financial utility built on HarmonyOS (Stage Model) using ArkTS and ArkUI to streamline business trip reimbursement workflows. The application allows employees to input trip metadata, dynamically itemize expenses, perform calculations using a built-in calculator, and verify details via a read-only preview before final submission.

## Key Features

- **Dynamic Expense Itemization:** Add, modify, and remove expense records with automated minimum-item boundary enforcement.
- **Built-in Quick Calculator:** Floating arithmetic keypad featuring 1-click result population into active input fields.
- **Read-Only Verification Modal:** Two-way state-synchronized preview modal for final reimbursement review and form re-initialization.
- **Robust Error & Null-Safety Defense:** Defensive arithmetic logic guarding against zero-division (`/0`), `NaN` numeric values, and unhandled null references using `?.` and `??` syntax.
- **Local Draft Persistence:** Asynchronous local draft storage and retrieval leveraging HarmonyOS `@kit.ArkData` preferences key-value storage.

## Tech Stack & Frameworks

- **Language & Framework:** ArkTS / ArkUI (HarmonyOS Stage Model, API 10/12+)
- **Development Environment:** DevEco Studio (v4.0+)
- **Local Persistence:** ArkData Preferences (`@kit.ArkData`)
- **System Capabilities:** AbilityKit (`@kit.AbilityKit`)

## Quick Start / Setup

1. Open **DevEco Studio** and select **Open Project**, navigating to the project root directory.
2. Perform project setup via **File > Sync and Refresh Project**.
3. Navigate to `products/entry/src/main/ets/pages/Index.ets`.
4. Launch the application using the **Previewer** panel or run it on a HarmonyOS Emulator / Device (`Shift + F10`).

## License

This project is licensed under the MIT License.
