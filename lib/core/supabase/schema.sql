-- ============================================================================
-- SUPABASE POSTGRESQL SCHEMA - POS STORE
-- Generated from Drift database schema (25 tables)
-- All timestamps in UTC via timestamptz
-- All money amounts in cents/fils (integers)
-- All IDs are TEXT (UUID strings stored as text, except CashDrawerEvents)
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE INVENTORY TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.suppliers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  barcode TEXT,
  category TEXT NOT NULL,
  supplier_id TEXT REFERENCES public.suppliers(id) ON DELETE SET NULL,
  sell_price INTEGER NOT NULL,
  cost_price INTEGER NOT NULL,
  qty INTEGER NOT NULL,
  track_imei BOOLEAN NOT NULL,
  image_path TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  balance INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- PURCHASE TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.purchases (
  id TEXT PRIMARY KEY,
  supplier_id TEXT REFERENCES public.suppliers(id) ON DELETE SET NULL,
  invoice_number TEXT,
  total INTEGER NOT NULL,
  paid INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.purchase_items (
  id TEXT PRIMARY KEY,
  purchase_id TEXT NOT NULL REFERENCES public.purchases(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  qty INTEGER NOT NULL,
  unit_cost INTEGER NOT NULL,
  line_total INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.purchase_invoices (
  id TEXT PRIMARY KEY,
  invoice_number TEXT NOT NULL,
  supplier TEXT NOT NULL,
  total INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.purchase_invoice_items (
  id TEXT PRIMARY KEY,
  purchase_invoice_id TEXT NOT NULL REFERENCES public.purchase_invoices(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  qty INTEGER NOT NULL,
  purchase_price INTEGER NOT NULL,
  sale_price INTEGER NOT NULL,
  line_total INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.purchase_payments (
  id TEXT PRIMARY KEY,
  purchase_id TEXT REFERENCES public.purchases(id) ON DELETE SET NULL,
  supplier_id TEXT NOT NULL REFERENCES public.suppliers(id) ON DELETE RESTRICT,
  amount INTEGER NOT NULL,
  description TEXT,
  payment_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SALES TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.sales (
  id TEXT PRIMARY KEY,
  customer_id TEXT REFERENCES public.customers(id) ON DELETE SET NULL,
  total INTEGER NOT NULL,
  discount INTEGER NOT NULL,
  paid INTEGER NOT NULL,
  payment_type TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.sale_items (
  id TEXT PRIMARY KEY,
  sale_id TEXT NOT NULL REFERENCES public.sales(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  qty INTEGER NOT NULL,
  unit_price INTEGER NOT NULL,
  line_total INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.payments (
  id TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  direction TEXT NOT NULL,
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- REPAIR TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.repairs (
  id TEXT PRIMARY KEY,
  customer_id TEXT REFERENCES public.customers(id) ON DELETE SET NULL,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  device TEXT NOT NULL,
  model TEXT,
  imei TEXT,
  issue TEXT NOT NULL,
  status TEXT NOT NULL,
  estimated_cost INTEGER NOT NULL DEFAULT 0,
  final_cost INTEGER NOT NULL DEFAULT 0,
  discount INTEGER NOT NULL DEFAULT 0,
  paid_at_receive INTEGER NOT NULL DEFAULT 0,
  paid_at_delivery INTEGER NOT NULL DEFAULT 0,
  total_paid INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS public.repair_parts (
  id TEXT PRIMARY KEY,
  repair_id TEXT NOT NULL REFERENCES public.repairs(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  qty INTEGER NOT NULL,
  unit_price INTEGER NOT NULL,
  line_total INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.repair_part_orders (
  id TEXT PRIMARY KEY,
  repair_id TEXT NOT NULL REFERENCES public.repairs(id) ON DELETE CASCADE,
  part_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  supplier_id TEXT REFERENCES public.suppliers(id) ON DELETE SET NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'Pending',
  quantity INTEGER NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- INVENTORY & STOCK MANAGEMENT
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.stock_movements (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  qty_delta INTEGER NOT NULL,
  reason TEXT NOT NULL,
  ref_id TEXT,
  created_at TIMESTAMPTZ NOT NULL
);

-- ============================================================================
-- DEBT MANAGEMENT
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.debts (
  id TEXT PRIMARY KEY,
  customer_id TEXT REFERENCES public.customers(id) ON DELETE SET NULL,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  source_type TEXT NOT NULL,
  source_id TEXT NOT NULL,
  amount INTEGER NOT NULL,
  due_date TIMESTAMPTZ,
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  is_settled BOOLEAN NOT NULL DEFAULT FALSE,
  settled_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SERVICE OPERATIONS TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.electricity_recharges (
  id TEXT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  subscription_number TEXT,
  amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  operation_type TEXT NOT NULL DEFAULT 'Electricity',
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.wallet_operations (
  id TEXT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.telelink_operations (
  id TEXT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.farahnet_payments (
  id TEXT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  amount_paid INTEGER NOT NULL,
  profit_amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.program_topups (
  id TEXT PRIMARY KEY,
  program_type TEXT NOT NULL,
  amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.settlements (
  id TEXT PRIMARY KEY,
  program_type TEXT NOT NULL,
  amount INTEGER NOT NULL,
  operated_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- CASH MANAGEMENT
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.cash_drawer_events (
  id SERIAL PRIMARY KEY,
  event_type TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SERVICE TRANSACTIONS & INVENTORY
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.service_transactions (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  provider TEXT NOT NULL,
  provider_label TEXT,
  customer_name TEXT,
  amount_cents INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  notes TEXT,
  sale_id TEXT REFERENCES public.sales(id) ON DELETE SET NULL,
  profit_cents INTEGER,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.service_daily_inventory (
  id TEXT PRIMARY KEY,
  date TIMESTAMPTZ NOT NULL,
  provider TEXT NOT NULL,
  opening_balance_cents INTEGER NOT NULL DEFAULT 0,
  closing_balance_cents INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Products
CREATE INDEX idx_products_category ON public.products(category);
CREATE INDEX idx_products_barcode ON public.products(barcode);
CREATE INDEX idx_products_supplier_id ON public.products(supplier_id);

-- Customers
CREATE INDEX idx_customers_phone ON public.customers(phone);
CREATE INDEX idx_customers_name ON public.customers(name);

-- Suppliers
CREATE INDEX idx_suppliers_phone ON public.suppliers(phone);
CREATE INDEX idx_suppliers_name ON public.suppliers(name);

-- Sales & related
CREATE INDEX idx_sales_customer_id ON public.sales(customer_id);
CREATE INDEX idx_sales_created_at ON public.sales(created_at);
CREATE INDEX idx_sale_items_sale_id ON public.sale_items(sale_id);
CREATE INDEX idx_sale_items_product_id ON public.sale_items(product_id);

-- Purchases & related
CREATE INDEX idx_purchases_supplier_id ON public.purchases(supplier_id);
CREATE INDEX idx_purchase_items_purchase_id ON public.purchase_items(purchase_id);
CREATE INDEX idx_purchase_items_product_id ON public.purchase_items(product_id);

-- Repairs
CREATE INDEX idx_repairs_customer_id ON public.repairs(customer_id);
CREATE INDEX idx_repairs_status ON public.repairs(status);
CREATE INDEX idx_repairs_created_at ON public.repairs(created_at);
CREATE INDEX idx_repair_parts_repair_id ON public.repair_parts(repair_id);

-- Stock movements
CREATE INDEX idx_stock_movements_product_id ON public.stock_movements(product_id);
CREATE INDEX idx_stock_movements_created_at ON public.stock_movements(created_at);

-- Debts
CREATE INDEX idx_debts_customer_id ON public.debts(customer_id);
CREATE INDEX idx_debts_is_settled ON public.debts(is_settled);
CREATE INDEX idx_debts_created_at ON public.debts(created_at);

-- Service operations
CREATE INDEX idx_electricity_recharges_created_at ON public.electricity_recharges(created_at);
CREATE INDEX idx_wallet_operations_created_at ON public.wallet_operations(created_at);
CREATE INDEX idx_telelink_operations_created_at ON public.telelink_operations(created_at);
CREATE INDEX idx_farahnet_payments_created_at ON public.farahnet_payments(created_at);

-- Service transactions
CREATE INDEX idx_service_transactions_created_at ON public.service_transactions(created_at);
CREATE INDEX idx_service_transactions_sale_id ON public.service_transactions(sale_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) - DEVELOPMENT MODE
-- ============================================================================
-- IMPORTANT: These are PERMISSIVE policies for development only.
-- In production, restrict to authenticated users and their specific data/shop.

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sale_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.repairs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.repair_parts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.debts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.electricity_recharges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallet_operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telelink_operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.farahnet_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.program_topups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.settlements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.repair_part_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_drawer_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_daily_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_invoice_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_payments ENABLE ROW LEVEL SECURITY;

-- DEV MODE: Allow all operations for anon key
-- TODO: Replace with proper auth policies in production

CREATE POLICY "Enable all for products" ON public.products FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for customers" ON public.customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for suppliers" ON public.suppliers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for sales" ON public.sales FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for sale_items" ON public.sale_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for purchases" ON public.purchases FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for purchase_items" ON public.purchase_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for repairs" ON public.repairs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for repair_parts" ON public.repair_parts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for payments" ON public.payments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for debts" ON public.debts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for stock_movements" ON public.stock_movements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for electricity_recharges" ON public.electricity_recharges FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for wallet_operations" ON public.wallet_operations FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for telelink_operations" ON public.telelink_operations FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for farahnet_payments" ON public.farahnet_payments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for program_topups" ON public.program_topups FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for settlements" ON public.settlements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for repair_part_orders" ON public.repair_part_orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for cash_drawer_events" ON public.cash_drawer_events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for service_transactions" ON public.service_transactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for service_daily_inventory" ON public.service_daily_inventory FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for purchase_invoices" ON public.purchase_invoices FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for purchase_invoice_items" ON public.purchase_invoice_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for purchase_payments" ON public.purchase_payments FOR ALL USING (true) WITH CHECK (true);

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
