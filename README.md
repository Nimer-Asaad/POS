# POS Store

A modern Flutter-based point-of-sale and repair management system for mobile shops and retail businesses.

## Overview

POS Store is designed with a local-first architecture and optional Supabase synchronization. It supports both Arabic and English, provides a responsive UI for horizontal mobile layouts, and covers sales, inventory, repairs, customers, reports, and operational workflows.

The project follows a clear separation between the UI layer, state management, business logic, and the local database. The app starts from [lib/main.dart](lib/main.dart) and renders its primary shell from [lib/app/app.dart](lib/app/app.dart).

## Key Features

- Daily dashboard with sales, profit, repair, and side-income insights.
- Fast POS workflow with cart management, discounts, payments, and receipt printing.
- Inventory management with search, categories, quantity tracking, cost, and sale price.
- Customer management with financial history and transaction records.
- Sales and purchase invoices for operational tracking and review.
- Repair module with debts, suppliers, supplier requests, and repair purchase invoices.
- Reports for transactions, provider operations, and profit analytics.
- Application settings for language, theme, database path, and cost-visibility protection.
- Offline-first usage with optional Supabase synchronization when configured.

## Main Modules

### Dashboard

Provides a quick operational summary with KPI cards and shortcut actions. Primary source: [lib/features/dashboard/presentation/dashboard_screen.dart](lib/features/dashboard/presentation/dashboard_screen.dart).

### POS

The main selling interface for adding products to the cart, adjusting quantities, applying discounts, recording payments, and printing invoices. Source: [lib/features/pos/presentation/pos_screen.dart](lib/features/pos/presentation/pos_screen.dart).

### Inventory

Manages products and stock with counts, categories, and financial metrics, along with a dedicated screen for daily service-related inventory flows. Sources: [lib/features/inventory/presentation/inventory_screen.dart](lib/features/inventory/presentation/inventory_screen.dart) and [lib/features/inventory/presentation/daily_services_inventory_screen.dart](lib/features/inventory/presentation/daily_services_inventory_screen.dart).

### Customers

Handles customer records, search, details, financial history, and related transactions. Source: [lib/features/customers/presentation/customers_screen.dart](lib/features/customers/presentation/customers_screen.dart).

### Invoices

Includes screens for sales invoices and purchase invoices to review and organize recorded transactions. Sources: [lib/features/invoices/presentation/sales_invoices_screen.dart](lib/features/invoices/presentation/sales_invoices_screen.dart) and [lib/features/invoices/presentation/purchase_invoices_screen.dart](lib/features/invoices/presentation/purchase_invoices_screen.dart).

### Repairs

Covers repair orders, debts, suppliers, supplier requests, and repair-related purchase invoices. Sources: [lib/features/repairs/presentation/repairs_screen.dart](lib/features/repairs/presentation/repairs_screen.dart), [lib/features/repairs/presentation/debts_screen.dart](lib/features/repairs/presentation/debts_screen.dart), [lib/features/repairs/presentation/suppliers_screen.dart](lib/features/repairs/presentation/suppliers_screen.dart), [lib/features/repairs/presentation/supplier_requests_screen.dart](lib/features/repairs/presentation/supplier_requests_screen.dart), and [lib/features/repairs/presentation/purchase_invoices_screen.dart](lib/features/repairs/presentation/purchase_invoices_screen.dart).

### Reports

Provides business reporting for sales, profit, transaction history, and provider operations. Sources: [lib/features/reports/presentation/reports_screen.dart](lib/features/reports/presentation/reports_screen.dart), [lib/features/reports/presentation/transactions_history_screen.dart](lib/features/reports/presentation/transactions_history_screen.dart), and [lib/features/reports/presentation/provider_operations_screen.dart](lib/features/reports/presentation/provider_operations_screen.dart).

### Programs and Service Transactions

Supports operational services such as electricity, wallet top-ups, telecom services, internet services, shipment settlements, and cash drawer openings. The logic is centered around [lib/providers/programs_provider.dart](lib/providers/programs_provider.dart) and [lib/providers/service_transactions_provider.dart](lib/providers/service_transactions_provider.dart).

### Settings

Includes controls for language, theme, local database path, and password-protected cost visibility. Source: [lib/features/settings/presentation/settings_screen.dart](lib/features/settings/presentation/settings_screen.dart) and [lib/core/providers/settings_provider.dart](lib/core/providers/settings_provider.dart).

## Architecture

The codebase is organized into clear layers:

- UI in `lib/features/**/presentation`
- State and orchestration in `lib/features/**/providers` and `lib/providers`
- Data access through Drift and DAOs in `lib/data/db`
- Shared configuration and synchronization in `lib/core`

The application uses Riverpod for state management and dependency injection, Drift for local persistence, and Supabase as an optional cloud synchronization layer.

## Data & Sync

The app initializes its environment from a `.env` file and then attempts to configure Supabase. If initialization fails, it continues in local-only mode without interrupting the user experience.

Automatic synchronization is implemented in [lib/core/database/auto_sync_extension.dart](lib/core/database/auto_sync_extension.dart) and [lib/core/sync/auto_sync_service.dart](lib/core/sync/auto_sync_service.dart). It covers core entities such as products, customers, sales, repairs, suppliers, payments, and debts.

## Language & UI

- Arabic and English are officially supported.
- Text direction and labels adapt automatically based on the selected language.
- The interface is optimized for horizontal mobile layouts.
- Both light and dark themes are available.

## Requirements

- Flutter 3.11 or later
- Dart 3.11 or later
- A `.env` file in the project root if Supabase is enabled

## Environment File

Create a `.env` file in the project root and define the following values:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

If the file is not present, the app will continue to run locally, but Supabase features and cloud synchronization will be unavailable.

## Local Setup

```bash
flutter pub get
flutter run
```

## Useful Commands

```bash
flutter analyze
flutter test
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Project Structure

```text
lib/
	app/                 # App shell, theme, and navigation
	core/                # Shared configuration, utilities, sync, database, common UI
	data/                # Drift database, DAOs, and entities
	design/              # Colors, shadows, and visual tokens
	features/            # Main feature areas by business domain
	l10n/                # Localization files
	providers/           # Shared Riverpod providers
```

## Notes

- The app includes multiple primary screens inside a unified navigation shell.
- Many screens rely directly on the Drift database, with optional synchronization to Supabase.
- Sensitive values such as cost visibility are protected by a locally stored password.

## Download Windows App

[Download Latest Release](https://github.com/Nimer-Asaad/POS/releases/latest)

## Developed by

Nimer Asaad

## License

No license has been defined yet.
