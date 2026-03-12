-- ============================================================================
-- CLEAR ALL DATA FROM SUPABASE - POS STORE
-- Deletes all data from tables while keeping table structure intact
-- Run this in Supabase SQL Editor to reset all data
-- ============================================================================

-- IMPORTANT: Delete in reverse dependency order to avoid FK constraint violations

-- ============================================================================
-- CHILD TABLES (Tables with FK dependencies)
-- ============================================================================

-- Service and repair related
DELETE FROM public.repair_parts;
DELETE FROM public.repair_part_orders;
DELETE FROM public.sale_items;
DELETE FROM public.purchase_items;
DELETE FROM public.purchase_invoice_items;
DELETE FROM public.purchase_payments;
DELETE FROM public.service_transactions;

-- Stock and debts
DELETE FROM public.stock_movements;
DELETE FROM public.debts;
DELETE FROM public.payments;

-- ============================================================================
-- PARENT TABLES (Tables referenced by others)
-- ============================================================================

DELETE FROM public.repairs;
DELETE FROM public.sales;
DELETE FROM public.purchases;
DELETE FROM public.purchase_invoices;
DELETE FROM public.products;
DELETE FROM public.customers;
DELETE FROM public.suppliers;

-- ============================================================================
-- STANDALONE TABLES (No FK dependencies)
-- ============================================================================

DELETE FROM public.electricity_recharges;
DELETE FROM public.wallet_operations;
DELETE FROM public.telelink_operations;
DELETE FROM public.farahnet_payments;
DELETE FROM public.program_topups;
DELETE FROM public.settlements;
DELETE FROM public.service_daily_inventory;
DELETE FROM public.cash_drawer_events;

-- ============================================================================
-- RESET SERIAL SEQUENCES (for auto-increment columns)
-- ============================================================================

-- Reset cash_drawer_events id sequence to start from 1
ALTER SEQUENCE cash_drawer_events_id_seq RESTART WITH 1;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Check table counts (should all be 0)
SELECT 
  'suppliers' as table_name, COUNT(*) as row_count FROM public.suppliers
UNION ALL SELECT 'products', COUNT(*) FROM public.products
UNION ALL SELECT 'customers', COUNT(*) FROM public.customers
UNION ALL SELECT 'purchases', COUNT(*) FROM public.purchases
UNION ALL SELECT 'purchase_items', COUNT(*) FROM public.purchase_items
UNION ALL SELECT 'sales', COUNT(*) FROM public.sales
UNION ALL SELECT 'sale_items', COUNT(*) FROM public.sale_items
UNION ALL SELECT 'repairs', COUNT(*) FROM public.repairs
UNION ALL SELECT 'repair_parts', COUNT(*) FROM public.repair_parts
UNION ALL SELECT 'debts', COUNT(*) FROM public.debts
UNION ALL SELECT 'payments', COUNT(*) FROM public.payments
UNION ALL SELECT 'stock_movements', COUNT(*) FROM public.stock_movements
UNION ALL SELECT 'electricity_recharges', COUNT(*) FROM public.electricity_recharges
UNION ALL SELECT 'wallet_operations', COUNT(*) FROM public.wallet_operations
UNION ALL SELECT 'telelink_operations', COUNT(*) FROM public.telelink_operations
UNION ALL SELECT 'farahnet_payments', COUNT(*) FROM public.farahnet_payments
UNION ALL SELECT 'program_topups', COUNT(*) FROM public.program_topups
UNION ALL SELECT 'settlements', COUNT(*) FROM public.settlements
UNION ALL SELECT 'service_transactions', COUNT(*) FROM public.service_transactions
UNION ALL SELECT 'service_daily_inventory', COUNT(*) FROM public.service_daily_inventory
UNION ALL SELECT 'cash_drawer_events', COUNT(*) FROM public.cash_drawer_events
UNION ALL SELECT 'repair_part_orders', COUNT(*) FROM public.repair_part_orders
UNION ALL SELECT 'purchase_invoices', COUNT(*) FROM public.purchase_invoices
UNION ALL SELECT 'purchase_invoice_items', COUNT(*) FROM public.purchase_invoice_items
UNION ALL SELECT 'purchase_payments', COUNT(*) FROM public.purchase_payments;

-- ============================================================================
-- END OF DATA CLEARING
-- ============================================================================
