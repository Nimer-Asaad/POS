-- ============================================================================
-- SUPABASE SEED DATA - POS STORE
-- Demo data for testing and development
-- Run this SQL in your Supabase SQL Editor after creating the schema
-- ============================================================================

-- ============================================================================
-- SUPPLIERS (NO FK DEPENDENCIES)
-- ============================================================================

INSERT INTO public.suppliers (id, name, phone, address, created_at)
VALUES
  ('sup-001', 'Al Aman Trading', '555-1001', 'Damascus Road, Aleppo', NOW()),
  ('sup-002', 'Tech World Imports', '555-1002', 'Central Market, Damascus', NOW()),
  ('sup-003', 'Electrical House', '555-1003', 'Industrial Zone, Homs', NOW()),
  ('sup-004', 'Premium Parts Co', '555-1004', 'Business District, Daraa', NOW()),
  ('sup-005', 'Mobile Phone Supplies', '555-1005', 'Tech Hub, Latakia', NOW());

-- ============================================================================
-- CUSTOMERS (NO FK DEPENDENCIES)
-- ============================================================================

INSERT INTO public.customers (id, name, phone, balance, created_at)
VALUES
  ('cust-001', 'Abu Ahmed', '0932-123456', 50000, NOW()),
  ('cust-002', 'Fatima Mohammad', '0933-234567', 75000, NOW()),
  ('cust-003', 'Omar Al-Rashid', '0934-345678', 0, NOW()),
  ('cust-004', 'Layla Hassan', '0935-456789', 120000, NOW()),
  ('cust-005', 'Hassan Ibrahim', '0936-567890', 0, NOW()),
  ('cust-006', 'Aisha Ali', '0937-678901', 30000, NOW()),
  ('cust-007', 'Mohammed Karim', '0938-789012', 0, NOW()),
  ('cust-008', 'Noor Jamil', '0939-890123', 45000, NOW());

-- ============================================================================
-- PRODUCTS (FK: suppliers)
-- ============================================================================

INSERT INTO public.products (id, name, barcode, category, supplier_id, sell_price, cost_price, qty, track_imei, image_path, created_at)
VALUES
  ('prod-001', 'iPhone 13 Pro', '865012056783459', 'smartphones', 'sup-002', 150000, 120000, 5, true, '/products/iphone13.jpg', NOW()),
  ('prod-002', 'Samsung Galaxy S21', '868235062054123', 'smartphones', 'sup-005', 130000, 100000, 8, true, '/products/galaxy.jpg', NOW()),
  ('prod-003', 'Charging Cable USB-C', '612345678901234', 'accessories', 'sup-002', 3500, 1500, 50, false, null, NOW()),
  ('prod-004', 'Phone Screen Protector', '612345678901235', 'accessories', 'sup-001', 2000, 800, 100, false, null, NOW()),
  ('prod-005', 'Battery Pack 20000mAh', '612345678901236', 'accessories', 'sup-003', 8500, 4000, 15, false, null, NOW()),
  ('prod-006', 'LED Lights 100W', '612345678901237', 'electrical', 'sup-003', 45000, 25000, 3, false, null, NOW()),
  ('prod-007', 'Phone Case Silicone', '612345678901238', 'accessories', 'sup-004', 5000, 2500, 30, false, null, NOW()),
  ('prod-008', 'Screen Repair Kit', '612345678901239', 'repair-parts', 'sup-004', 12000, 6000, 10, false, null, NOW()),
  ('prod-009', 'Phone Speaker', '612345678901240', 'accessories', 'sup-005', 7500, 3500, 12, false, null, NOW()),
  ('prod-010', 'HDMI Cable 2M', '612345678901241', 'accessories', 'sup-001', 4000, 1800, 25, false, null, NOW());

-- ============================================================================
-- PURCHASES (FK: suppliers)
-- ============================================================================

INSERT INTO public.purchases (id, supplier_id, invoice_number, total, paid, created_at)
VALUES
  ('purch-001', 'sup-001', 'INV-2024-001', 500000, 500000, NOW()),
  ('purch-002', 'sup-002', 'INV-2024-002', 750000, 500000, NOW()),
  ('purch-003', 'sup-003', 'INV-2024-003', 300000, 300000, NOW());

-- ============================================================================
-- PURCHASE_ITEMS (FK: purchases, products)
-- ============================================================================

INSERT INTO public.purchase_items (id, purchase_id, product_id, qty, unit_cost, line_total, created_at)
VALUES
  ('purch-item-001', 'purch-001', 'prod-003', 50, 1500, 75000, NOW()),
  ('purch-item-002', 'purch-001', 'prod-004', 100, 800, 80000, NOW()),
  ('purch-item-003', 'purch-002', 'prod-001', 5, 120000, 600000, NOW()),
  ('purch-item-004', 'purch-003', 'prod-006', 3, 25000, 75000, NOW());

-- ============================================================================
-- PURCHASE_INVOICES (NO FK in insert)
-- ============================================================================

INSERT INTO public.purchase_invoices (id, invoice_number, supplier, total, created_at)
VALUES
  ('pinv-001', 'PI-2024-001', 'Al Aman Trading', 400000, NOW()),
  ('pinv-002', 'PI-2024-002', 'Tech World Imports', 600000, NOW());

-- ============================================================================
-- PURCHASE_INVOICE_ITEMS (FK: purchase_invoices, products)
-- ============================================================================

INSERT INTO public.purchase_invoice_items (id, purchase_invoice_id, product_id, qty, purchase_price, sale_price, line_total, created_at)
VALUES
  ('pinv-item-001', 'pinv-001', 'prod-003', 30, 1500, 3500, 45000, NOW()),
  ('pinv-item-002', 'pinv-001', 'prod-004', 50, 800, 2000, 40000, NOW()),
  ('pinv-item-003', 'pinv-002', 'prod-001', 3, 120000, 150000, 450000, NOW()),
  ('pinv-item-004', 'pinv-002', 'prod-002', 2, 100000, 130000, 200000, NOW());

-- ============================================================================
-- PURCHASE_PAYMENTS (FK: purchases, suppliers)
-- ============================================================================

INSERT INTO public.purchase_payments (id, purchase_id, supplier_id, amount, description, payment_date, created_at)
VALUES
  ('pay-purch-001', 'purch-002', 'sup-002', 250000, 'Partial payment for INV-2024-002', NOW(), NOW()),
  ('pay-purch-002', 'purch-002', 'sup-002', 250000, '50% payment for INV-2024-002', (NOW() + interval '7 days'), (NOW() + interval '7 days'));

-- ============================================================================
-- SALES (FK: customers)
-- ============================================================================

INSERT INTO public.sales (id, customer_id, total, discount, paid, payment_type, created_at)
VALUES
  ('sale-001', 'cust-001', 155000, 5000, 150000, 'cash', NOW()),
  ('sale-002', 'cust-002', 140000, 10000, 140000, 'card', (NOW() - interval '2 days')),
  ('sale-003', 'cust-003', 25000, 0, 25000, 'cash', (NOW() - interval '5 days')),
  ('sale-004', 'cust-004', 90000, 5000, 0, 'credit', (NOW() - interval '10 days')),
  ('sale-005', null, 35000, 0, 35000, 'cash', (NOW() - interval '1 day'));

-- ============================================================================
-- SALE_ITEMS (FK: sales, products)
-- ============================================================================

INSERT INTO public.sale_items (id, sale_id, product_id, qty, unit_price, line_total, created_at)
VALUES
  ('sale-item-001', 'sale-001', 'prod-001', 1, 150000, 150000, NOW()),
  ('sale-item-002', 'sale-001', 'prod-003', 1, 3500, 3500, NOW()),
  ('sale-item-003', 'sale-002', 'prod-002', 1, 130000, 130000, (NOW() - interval '2 days')),
  ('sale-item-004', 'sale-002', 'prod-007', 1, 5000, 5000, (NOW() - interval '2 days')),
  ('sale-item-005', 'sale-003', 'prod-003', 5, 3500, 17500, (NOW() - interval '5 days')),
  ('sale-item-006', 'sale-003', 'prod-004', 2, 2000, 4000, (NOW() - interval '5 days')),
  ('sale-item-007', 'sale-004', 'prod-005', 2, 8500, 17000, (NOW() - interval '10 days')),
  ('sale-item-008', 'sale-004', 'prod-009', 1, 7500, 7500, (NOW() - interval '10 days')),
  ('sale-item-009', 'sale-005', 'prod-010', 5, 4000, 20000, (NOW() - interval '1 day')),
  ('sale-item-010', 'sale-005', 'prod-004', 3, 2000, 6000, (NOW() - interval '1 day'));

-- ============================================================================
-- PAYMENTS (FK: customers)
-- ============================================================================

INSERT INTO public.payments (id, customer_id, amount, direction, note, created_at)
VALUES
  ('pay-001', 'cust-001', 50000, 'credit', 'Payment for sale-001', NOW()),
  ('pay-002', 'cust-002', 75000, 'credit', 'Partial payment for outstanding balance', (NOW() - interval '3 days')),
  ('pay-003', 'cust-004', 90000, 'credit', 'Full payment for sale-004', (NOW() - interval '8 days')),
  ('pay-004', 'cust-006', 30000, 'advance', 'Advance payment for future purchases', (NOW() - interval '15 days'));

-- ============================================================================
-- REPAIRS (FK: customers)
-- ============================================================================

INSERT INTO public.repairs (id, customer_id, customer_name, customer_phone, device, model, imei, issue, status, estimated_cost, final_cost, discount, paid_at_receive, paid_at_delivery, total_paid, created_at, updated_at)
VALUES
  ('repair-001', 'cust-001', 'Abu Ahmed', '0932-123456', 'iPhone', '13 Pro', '865012056783459', 'Screen broken, not turning on', 'completed', 80000, 75000, 0, 20000, 55000, 75000, (NOW() - interval '20 days'), (NOW() - interval '15 days')),
  ('repair-002', 'cust-006', 'Aisha Ali', '0937-678901', 'Samsung', 'Galaxy S21', '868235062054123', 'Battery drain, slow performance', 'pending', 45000, 0, 0, 10000, 0, 10000, (NOW() - interval '5 days'), (NOW() - interval '5 days')),
  ('repair-003', null, 'Unknown Customer', '0900-000000', 'Phone', 'Generic', null, 'Not powering on', 'waiting', 30000, 0, 0, 0, 0, 0, (NOW() - interval '3 days'), (NOW() - interval '3 days'));

-- ============================================================================
-- REPAIR_PARTS (FK: repairs, products)
-- ============================================================================

INSERT INTO public.repair_parts (id, repair_id, product_id, qty, unit_price, line_total, created_at)
VALUES
  ('repair-parts-001', 'repair-001', 'prod-008', 1, 12000, 12000, (NOW() - interval '20 days')),
  ('repair-parts-002', 'repair-002', 'prod-005', 1, 8500, 8500, (NOW() - interval '5 days'));

-- ============================================================================
-- REPAIR_PART_ORDERS (FK: repairs, products as parts, suppliers)
-- ============================================================================

INSERT INTO public.repair_part_orders (id, repair_id, part_id, supplier_id, operated_at, status, quantity, notes, created_at)
VALUES
  ('order-001', 'repair-002', 'prod-008', 'sup-004', NOW(), 'Pending', 1, 'Waiting for part arrival', NOW()),
  ('order-002', 'repair-003', 'prod-005', 'sup-003', (NOW() - interval '2 days'), 'Ordered', 2, 'Emergency parts requested', (NOW() - interval '2 days'));

-- ============================================================================
-- STOCK_MOVEMENTS (FK: products)
-- ============================================================================

INSERT INTO public.stock_movements (id, product_id, type, qty_delta, reason, ref_id, created_at)
VALUES
  ('stock-001', 'prod-001', 'purchase', 5, 'Purchase from supplier', 'purch-002', (NOW() - interval '10 days')),
  ('stock-002', 'prod-001', 'sale', -1, 'Sold in sale-001', 'sale-001', NOW()),
  ('stock-003', 'prod-003', 'purchase', 50, 'Purchase from supplier', 'purch-001', (NOW() - interval '15 days')),
  ('stock-004', 'prod-003', 'sale', -5, 'Sold in sale-003', 'sale-003', (NOW() - interval '5 days')),
  ('stock-005', 'prod-004', 'adjustment', -2, 'Stock adjustment - damaged items', null, (NOW() - interval '7 days'));

-- ============================================================================
-- DEBTS (FK: customers)
-- ============================================================================

INSERT INTO public.debts (id, customer_id, customer_name, customer_phone, source_type, source_id, amount, due_date, note, created_at, is_settled, settled_at)
VALUES
  ('debt-001', 'cust-004', 'Layla Hassan', '0935-456789', 'sale', 'sale-004', 90000, (NOW() + interval '15 days'), 'Payment due for sale-004', (NOW() - interval '10 days'), false, null),
  ('debt-002', 'cust-002', 'Fatima Mohammad', '0933-234567', 'repair', 'repair-001', 0, null, 'Repair completed and paid', (NOW() - interval '15 days'), true, (NOW() - interval '15 days'));

-- ============================================================================
-- ELECTRICITY_RECHARGES (NO FK)
-- ============================================================================

INSERT INTO public.electricity_recharges (id, customer_name, subscription_number, amount, operated_at, operation_type, notes, created_at)
VALUES
  ('elec-001', 'Abu Ahmed', 'SUB-2024-001', 50000, (NOW() - interval '5 days'), 'Electricity', 'Monthly bill payment', (NOW() - interval '5 days')),
  ('elec-002', 'Fatima Mohammad', 'SUB-2024-002', 35000, (NOW() - interval '2 days'), 'Electricity', 'Quarterly payment', (NOW() - interval '2 days'));

-- ============================================================================
-- WALLET_OPERATIONS (NO FK)
-- ============================================================================

INSERT INTO public.wallet_operations (id, customer_name, amount, operated_at, notes, created_at)
VALUES
  ('wallet-001', 'Omar Al-Rashid', 100000, (NOW() - interval '8 days'), 'Top-up wallet for services', (NOW() - interval '8 days')),
  ('wallet-002', 'Hassan Ibrahim', 50000, (NOW() - interval '3 days'), 'Wallet recharge', (NOW() - interval '3 days'));

-- ============================================================================
-- TELELINK_OPERATIONS (NO FK)
-- ============================================================================

INSERT INTO public.telelink_operations (id, customer_name, amount, operated_at, notes, created_at)
VALUES
  ('telelink-001', 'Aisha Ali', 75000, (NOW() - interval '6 days'), 'Internet package payment', (NOW() - interval '6 days')),
  ('telelink-002', 'Mohammed Karim', 50000, (NOW() - interval '1 day'), 'Monthly subscription', (NOW() - interval '1 day'));

-- ============================================================================
-- FARAHNET_PAYMENTS (NO FK)
-- ============================================================================

INSERT INTO public.farahnet_payments (id, customer_name, amount_paid, profit_amount, operated_at, notes, created_at)
VALUES
  ('farah-001', 'Noor Jamil', 120000, 12000, (NOW() - interval '4 days'), 'Monthly Farahnet service', (NOW() - interval '4 days')),
  ('farah-002', 'Abu Ahmed', 80000, 8000, (NOW() - interval '11 days'), 'Farahnet top-up', (NOW() - interval '11 days'));

-- ============================================================================
-- PROGRAM_TOPUPS (NO FK)
-- ============================================================================

INSERT INTO public.program_topups (id, program_type, amount, operated_at, notes, created_at)
VALUES
  ('topup-001', 'VoIP', 25000, (NOW() - interval '7 days'), 'VoIP monthly package', (NOW() - interval '7 days')),
  ('topup-002', 'Data', 50000, (NOW() - interval '2 days'), 'High-speed data package', (NOW() - interval '2 days'));

-- ============================================================================
-- SETTLEMENTS (NO FK)
-- ============================================================================

INSERT INTO public.settlements (id, program_type, amount, operated_at, notes, created_at)
VALUES
  ('settle-001', 'Daily', 500000, (NOW() - interval '1 day'), 'Daily settlement for all services', (NOW() - interval '1 day')),
  ('settle-002', 'Weekly', 3500000, (NOW() - interval '4 days'), 'Weekly settlement batch', (NOW() - interval '4 days'));

-- ============================================================================
-- SERVICE_TRANSACTIONS (FK: sales)
-- ============================================================================

INSERT INTO public.service_transactions (id, category, provider, provider_label, customer_name, amount_cents, created_at, notes, sale_id, profit_cents)
VALUES
  ('svc-001', 'recharge', 'electricity', 'Electricity Co', 'Abu Ahmed', 5000000, (NOW() - interval '5 days'), 'Monthly electricity recharge', null, 100000),
  ('svc-002', 'payment', 'internet', 'Telelink', 'Fatima Mohammad', 7500000, (NOW() - interval '3 days'), 'Internet payment', 'sale-002', 150000),
  ('svc-003', 'topup', 'voip', 'VoIP Services', 'Omar Al-Rashid', 2500000, (NOW() - interval '8 days'), 'VoIP top-up', null, 50000);

-- ============================================================================
-- SERVICE_DAILY_INVENTORY (NO FK)
-- ============================================================================

INSERT INTO public.service_daily_inventory (id, date, provider, opening_balance_cents, closing_balance_cents, notes, created_at)
VALUES
  ('svc-daily-001', NOW(), 'electricity', 100000000, 95000000, 'Daily electricity inventory', NOW()),
  ('svc-daily-002', (NOW() - interval '1 day'), 'internet', 50000000, 42500000, 'Daily internet inventory', (NOW() - interval '1 day')),
  ('svc-daily-003', (NOW() - interval '2 days'), 'voip', 25000000, 22500000, 'Daily VoIP inventory', (NOW() - interval '2 days'));

-- ============================================================================
-- CASH_DRAWER_EVENTS (NO FK - SPECIAL: id is SERIAL)
-- ============================================================================

INSERT INTO public.cash_drawer_events (event_type, created_at, notes)
VALUES
  ('open', (NOW() - interval '1 day'), 'Cashier opened drawer'),
  ('close', (NOW() - interval '1 day'), 'Cashier closed drawer'),
  ('recount', (NOW() - interval '3 days'), 'Manual recount of drawer'),
  ('open', NOW(), 'Drawer opened for new shift');

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
-- Note: Data has been seeded with realistic relationships preserved
-- Change timestamps in production to match your actual data
-- Update UUIDs, phone numbers, and names as needed for your business
