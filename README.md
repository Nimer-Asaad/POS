# POS Store

نظام نقاط بيع وإدارة متجر مبني بـ Flutter، ويعمل بأسلوب local-first مع دعم اختياري للمزامنة مع Supabase. التطبيق يدعم العربية والإنجليزية، ويستهدف شاشات أفقية مع واجهة مخصصة لإدارة المبيعات، المخزون، الصيانة، العملاء، التقارير، والعمليات الخدمية.

## نظرة عامة

يعتمد المشروع على بنية واضحة تفصل بين الواجهة، مزودات الحالة، طبقة البيانات، وقاعدة البيانات المحلية. التطبيق يبدأ من [lib/main.dart](lib/main.dart) ويعرض واجهة رئيسية موحدة من [lib/app/app.dart](lib/app/app.dart).

## أهم المزايا

- Dashboard مع مؤشرات يومية للمبيعات، الأرباح، الصيانة، والإيرادات الجانبية.
- POS للبيع السريع مع سلة، خصومات، دفع، وطباعة.
- إدارة المخزون مع البحث، الفئات، وتتبّع الكميات والتكلفة وسعر البيع.
- شاشة العملاء مع السجل المالي والتاريخ الشرائي.
- شاشة الفواتير للمبيعات وفواتير الشراء.
- وحدة الصيانة مع الديون، الموردين، طلبات الموردين، وفواتير الشراء الخاصة بالصيانة.
- التقارير مع سجل المعاملات، عمليات المزودات، وتقارير الأرباح.
- إعدادات التطبيق للغة، الثيم، كلمة مرور إظهار التكلفة، ومجلد قاعدة البيانات.
- دعم العمل دون اتصال، مع مزامنة اختيارية إلى Supabase عند توفر الإعدادات.

## الفيتشرز الرئيسية

### Dashboard

يوفر ملخصًا سريعًا للأداء اليومي، ويتضمن بطاقات KPIs وإجراءات سريعة للوصول إلى باقي أجزاء التطبيق. المصدر الأساسي: [lib/features/dashboard/presentation/dashboard_screen.dart](lib/features/dashboard/presentation/dashboard_screen.dart).

### POS

واجهة البيع الرئيسية لإضافة المنتجات إلى السلة، تعديل الكميات، تطبيق الخصم، تسجيل المدفوعات، وطباعة الفاتورة. يدعم أيضًا خدمات/عمليات جانبية مرتبطة بالمبيعات. المصدر: [lib/features/pos/presentation/pos_screen.dart](lib/features/pos/presentation/pos_screen.dart).

### Inventory

إدارة المنتجات والمخزون مع إحصائيات الكميات والفئات والقيم المالية، بالإضافة إلى شاشة خاصة بالخدمات اليومية المرتبطة بالمخزون. المصادر: [lib/features/inventory/presentation/inventory_screen.dart](lib/features/inventory/presentation/inventory_screen.dart) و [lib/features/inventory/presentation/daily_services_inventory_screen.dart](lib/features/inventory/presentation/daily_services_inventory_screen.dart).

### Customers

إدارة العملاء، البحث، التفاصيل، السجل المالي، وتاريخ العمليات المرتبطة بكل عميل. المصدر: [lib/features/customers/presentation/customers_screen.dart](lib/features/customers/presentation/customers_screen.dart).

### Invoices

شاشات لفواتير المبيعات وفواتير الشراء. هذا الجزء مخصص لمراجعة العمليات المسجلة وتنظيمها. المصادر: [lib/features/invoices/presentation/sales_invoices_screen.dart](lib/features/invoices/presentation/sales_invoices_screen.dart) و [lib/features/invoices/presentation/purchase_invoices_screen.dart](lib/features/invoices/presentation/purchase_invoices_screen.dart).

### Repairs

وحدة الصيانة تشمل شاشة الإصلاحات، الديون، الموردين، طلبات الموردين، وفواتير الشراء الخاصة بقطع الصيانة. المصادر: [lib/features/repairs/presentation/repairs_screen.dart](lib/features/repairs/presentation/repairs_screen.dart)، [lib/features/repairs/presentation/debts_screen.dart](lib/features/repairs/presentation/debts_screen.dart)، [lib/features/repairs/presentation/suppliers_screen.dart](lib/features/repairs/presentation/suppliers_screen.dart)، [lib/features/repairs/presentation/supplier_requests_screen.dart](lib/features/repairs/presentation/supplier_requests_screen.dart)، و [lib/features/repairs/presentation/purchase_invoices_screen.dart](lib/features/repairs/presentation/purchase_invoices_screen.dart).

### Reports

تقارير شاملة عن المبيعات والأرباح وسجل المعاملات وعمليات المزودات. المصادر: [lib/features/reports/presentation/reports_screen.dart](lib/features/reports/presentation/reports_screen.dart)، [lib/features/reports/presentation/transactions_history_screen.dart](lib/features/reports/presentation/transactions_history_screen.dart)، و [lib/features/reports/presentation/provider_operations_screen.dart](lib/features/reports/presentation/provider_operations_screen.dart).

### Programs and service transactions

المنظومة الخدمية الخاصة بعمليات مثل الكهرباء، الواليت، تلفنك، فارح نت، الشحنات/التسويات، وفتح درج النقدية. هذه الوحدة مبنية حول مزودات و DAO متعددة لتسجيل العمليات اليومية وتجميعها. البداية المنطقية: [lib/providers/programs_provider.dart](lib/providers/programs_provider.dart) و [lib/providers/service_transactions_provider.dart](lib/providers/service_transactions_provider.dart).

### Settings

إعدادات التطبيق تشمل اللغة، الثيم، مسار قاعدة البيانات المحلية، وكلمات مرور التحكم في إظهار التكلفة. المصدر: [lib/features/settings/presentation/settings_screen.dart](lib/features/settings/presentation/settings_screen.dart) و [lib/core/providers/settings_provider.dart](lib/core/providers/settings_provider.dart).

## المعمارية

المشروع مبني على فصل واضح بين الطبقات:

- الواجهة في `lib/features/**/presentation`
- الحالة والمنطق الوسيط في `lib/features/**/providers` و `lib/providers`
- الوصول للبيانات عبر Drift و DAOs داخل `lib/data/db`
- إعدادات عامة ومزامنة داخل `lib/core`

يعتمد التطبيق على Riverpod لإدارة الحالة وحقن الاعتماديات، وعلى Drift كقاعدة بيانات محلية، وعلى Supabase كمصدر مزامنة اختياري.

## البيانات والمزامنة

يبدأ التطبيق بتهيئة البيئة من ملف `.env`، ثم يحاول تهيئة Supabase. إذا فشلت التهيئة، يستمر التطبيق بوضع local-only بدون إيقاف الواجهة.

المزامنة التلقائية موجودة في [lib/core/database/auto_sync_extension.dart](lib/core/database/auto_sync_extension.dart) و [lib/core/sync/auto_sync_service.dart](lib/core/sync/auto_sync_service.dart)، وتغطي الكيانات الأساسية مثل المنتجات والعملاء والمبيعات والإصلاحات والموردين والمدفوعات والديون.

## اللغات والواجهة

- العربية والإنجليزية مدعومتان رسميًا.
- التطبيق يحدد اتجاه النص والعبارات حسب اللغة.
- الواجهة مضبوطة على الوضع الأفقي للأجهزة المحمولة.
- الثيم يدعم الفاتح والداكن.

## المتطلبات

- Flutter 3.11 أو أحدث.
- Dart 3.11 أو أحدث.
- ملف `.env` في جذر المشروع إذا أردت تشغيل Supabase.

## ملف البيئة

أضف ملف `.env` في جذر المشروع، وعرّف القيم التالية:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

إذا لم يكن الملف موجودًا، سيعمل التطبيق محليًا فقط، لكن ميزات Supabase والمزامنة السحابية لن تكون متاحة.

## التشغيل المحلي

```bash
flutter pub get
flutter run
```

## أوامر مفيدة

```bash
flutter analyze
flutter test
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## هيكل المشروع

```text
lib/
	app/                 # التطبيق الرئيسي، الثيم، والـ shell navigation
	core/                # إعدادات عامة، أدوات، مزامنة، قاعدة بيانات، UI مشتركة
	data/                # Drift database و DAO والكيانات
	design/              # الألوان، الظلال، والـ tokens البصرية
	features/            # كل الفيتشرز الرئيسية حسب نطاق العمل
	l10n/                # ملفات الترجمة
	providers/           # مزودات Riverpod العامة
```

## ملاحظات

- التطبيق يحتوي على شاشات رئيسية متعددة داخل شريط تنقل موحد.
- كثير من الشاشات تعتمد على بيانات مباشرة من قاعدة Drift، مع مزامنة اختيارية إلى Supabase.
- بعض القيم الحساسة مثل إظهار التكلفة محمية بكلمة مرور محفوظة محليًا.

## الترخيص

لم يتم تحديد ترخيص حاليًا.
