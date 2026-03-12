import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pos_store/l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/migration/push_local_to_supabase_service.dart';
import '../../../core/supabase/clear_supabase_data.dart';
import '../../../core/database/clear_local_data.dart';
import '../../../core/providers/auto_sync_provider.dart';
import '../../../core/database/auto_sync_extension.dart';
import '../../../providers/db_provider.dart';
import '../../inventory/providers/products_providers.dart';
import '../../inventory/presentation/inventory_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Future<void> _pickDatabaseFolder(BuildContext context, WidgetRef ref) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: _t(
        context,
        'اختر مجلد حفظ قاعدة البيانات',
        'Select database storage folder',
      ),
    );

    if (selectedDirectory == null || selectedDirectory.trim().isEmpty) {
      return;
    }

    await ref
        .read(settingsProvider.notifier)
        .setDatabaseDirectoryPath(selectedDirectory);
    ref.invalidate(dbProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            context,
            'تم حفظ مجلد قاعدة البيانات. سيتم إنشاء الملف هناك تلقائيًا.',
            'Database folder saved. The database file will be created there automatically.',
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _resetDatabaseFolder(BuildContext context, WidgetRef ref) async {
    await ref.read(settingsProvider.notifier).clearDatabaseDirectoryPath();
    ref.invalidate(dbProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            context,
            'تمت إعادة مجلد قاعدة البيانات للوضع الافتراضي.',
            'Database folder reset to default location.',
          ),
        ),
      ),
    );
  }

  Future<void> _showChangeCostPasswordDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(context, 'تغيير كلمة مرور التكلفة', 'Change Cost Password'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(
                        context,
                        'كلمة المرور الحالية',
                        'Current Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPasswordController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(
                        context,
                        'كلمة المرور الجديدة',
                        'New Password',
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() => isSaving = true);
                          final success = await ref
                              .read(settingsProvider.notifier)
                              .changeCostPassword(
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              );

                          if (!context.mounted) return;

                          if (success) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'تم تغيير كلمة المرور بنجاح',
                                    'Password changed successfully',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _t(
                                  context,
                                  'فشل التغيير: تأكد من كلمة المرور الحالية',
                                  'Change failed: verify current password',
                                ),
                              ),
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'حفظ', 'Save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showRecoveryResetDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final recoveryController = TextEditingController();
    final newPasswordController = TextEditingController();
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(context, 'استعادة كلمة المرور', 'Recover Password'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: recoveryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(context, 'رمز الاستعادة', 'Recovery Code'),
                      hintText: '0000',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPasswordController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(
                        context,
                        'كلمة المرور الجديدة',
                        'New Password',
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() => isSaving = true);
                          final success = await ref
                              .read(settingsProvider.notifier)
                              .resetCostPasswordWithRecovery(
                                recoveryCode: recoveryController.text,
                                newPassword: newPasswordController.text,
                              );

                          if (!context.mounted) return;

                          if (success) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'تمت الاستعادة وتحديث كلمة المرور',
                                    'Password recovered and updated',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _t(
                                  context,
                                  'رمز الاستعادة غير صحيح أو كلمة المرور فارغة',
                                  'Invalid recovery code or empty password',
                                ),
                              ),
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'استعادة', 'Recover')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show migration progress dialog
  Future<void> _showMigrationDialog(
    BuildContext context,
    WidgetRef ref,
    PushLocalToSupabaseService migrationService,
    dynamic database,
  ) async {
    final tableStatsMap = <String, List<String>>{};
    bool isMigrating = false;
    bool migrationComplete = false;
    bool migrationError = false;
    String errorMessage = '';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(
                  context,
                  'مزامنة البيانات مع Supabase',
                  'Sync Data to Supabase',
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(dialogContext).size.width < 640
                    ? MediaQuery.of(dialogContext).size.width * 0.9
                    : 500,
                height: MediaQuery.of(dialogContext).size.height < 760
                    ? MediaQuery.of(dialogContext).size.height * 0.55
                    : 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMigrating && !migrationComplete && !migrationError)
                      Column(
                        children: [
                          Text(
                            _t(
                              context,
                              'انقر على الزر للبدء برفع كل البيانات المحلية إلى السحابة',
                              'Click the button to upload all local data to the cloud',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              setDialogState(() => isMigrating = true);

                              try {
                                await migrationService.migrate(
                                  driftDatabase: database,
                                  onProgress:
                                      (
                                        tableName,
                                        current,
                                        total,
                                        statsIfComplete,
                                      ) {
                                        if (statsIfComplete != null) {
                                          setDialogState(() {
                                            tableStatsMap[tableName] = [
                                              '${statsIfComplete.successfulRows}/${statsIfComplete.totalRows}',
                                              'completed',
                                            ];
                                          });
                                        }
                                      },
                                );

                                setDialogState(() {
                                  isMigrating = false;
                                  migrationComplete = true;
                                });

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _t(
                                          context,
                                          'تم رفع البيانات بنجاح!',
                                          'Data uploaded successfully!',
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                setDialogState(() {
                                  isMigrating = false;
                                  migrationError = true;
                                  errorMessage = e.toString();
                                });

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _t(context, 'خطأ: $e', 'Error: $e'),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.cloud_upload),
                            label: Text(
                              _t(context, 'ابدأ المزامنة', 'Start Migration'),
                            ),
                          ),
                        ],
                      )
                    else if (isMigrating)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text(
                            _t(
                              context,
                              'جاري رفع البيانات...',
                              'Uploading data...',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${tableStatsMap.length}/25 جداول',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tableStatsMap.entries
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${e.key}: ${e.value[0]}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (migrationComplete)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _t(
                              context,
                              'اكتملت المزامنة!',
                              'Migration Complete!',
                            ),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _t(
                              context,
                              'تم رفع ${tableStatsMap.length} جدول بنجاح',
                              'Successfully uploaded ${tableStatsMap.length} tables',
                            ),
                          ),
                        ],
                      )
                    else if (migrationError)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _t(context, 'حدث خطأ!', 'Error Occurred!'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                if (migrationComplete || migrationError)
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(_t(context, 'إغلاق', 'Close')),
                  )
                else
                  TextButton(
                    onPressed: isMigrating
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: Text(_t(context, 'إلغاء', 'Cancel')),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: AppTopBar(title: l10n.settings),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Section
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(l10n.arabic),
                        value: 'ar',
                        groupValue: settings.locale.languageCode,
                        onChanged: (value) =>
                            notifier.setLocale(const Locale('ar')),
                      ),
                      const Divider(),
                      RadioListTile<String>(
                        title: Text(l10n.english),
                        value: 'en',
                        groupValue: settings.locale.languageCode,
                        onChanged: (value) =>
                            notifier.setLocale(const Locale('en')),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Theme Section
                Text(l10n.theme, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.lightMode),
                        value: ThemeMode.light,
                        groupValue: settings.themeMode,
                        onChanged: (value) =>
                            notifier.setThemeMode(ThemeMode.light),
                      ),
                      const Divider(),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.darkMode),
                        value: ThemeMode.dark,
                        groupValue: settings.themeMode,
                        onChanged: (value) =>
                            notifier.setThemeMode(ThemeMode.dark),
                      ),
                      const Divider(),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.systemMode),
                        value: ThemeMode.system,
                        groupValue: settings.themeMode,
                        onChanged: (value) =>
                            notifier.setThemeMode(ThemeMode.system),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  _t(context, 'حماية التكلفة', 'Cost Protection'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.password_rounded),
                        title: Text(
                          _t(
                            context,
                            'تغيير كلمة مرور إظهار التكلفة',
                            'Change Cost Visibility Password',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'تُستخدم في شاشة المخزون لعرض عمود التكلفة',
                            'Used in Inventory screen to unlock cost column',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            _showChangeCostPasswordDialog(context, ref),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_reset_rounded),
                        title: Text(
                          _t(
                            context,
                            'استعادة كلمة المرور برمز الاستعادة',
                            'Recover Password with Recovery Code',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'استخدمه إذا نسيت كلمة المرور الحالية',
                            'Use this if you forgot the current password',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showRecoveryResetDialog(context, ref),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.security_rounded),
                        title: Text(
                          _t(context, 'رمز الاستعادة', 'Recovery Code'),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'استخدم هذا الرمز عند نسيان كلمة المرور: ${settings.costRecoveryCode}',
                            'Use this code if you forget the password: ${settings.costRecoveryCode}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  _t(context, 'قاعدة البيانات المحلية', 'Local Database'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.folder_open_rounded),
                        title: Text(
                          _t(
                            context,
                            'مجلد حفظ قاعدة البيانات',
                            'Database Storage Folder',
                          ),
                        ),
                        subtitle: Text(
                          settings.databaseDirectoryPath ??
                              _t(
                                context,
                                'المسار الافتراضي للتطبيق',
                                'Default app directory',
                              ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _pickDatabaseFolder(context, ref),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.refresh_rounded),
                        title: Text(
                          _t(
                            context,
                            'إرجاع المسار الافتراضي',
                            'Use Default Path',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'إلغاء المسار المخصص والعودة لمسار التطبيق',
                            'Clear custom folder and use app default path',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: settings.databaseDirectoryPath == null
                            ? null
                            : () => _resetDatabaseFolder(context, ref),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Supabase Migration Section
                Text(
                  _t(context, 'مزامنة السحابة', 'Cloud Synchronization'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Auto-sync toggle
                AppCard(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final isAutoSyncEnabled = ref.watch(
                        isAutoSyncEnabledProvider,
                      );
                      final db = ref.watch(dbProvider);
                      final isAvailable = db.isAutoSyncAvailable;

                      return SwitchListTile(
                        title: Text(_t(context, 'مزامنة تلقائية', 'Auto-Sync')),
                        subtitle: Text(
                          isAvailable
                              ? _t(
                                  context,
                                  'مزامنة فورية مع Supabase بعد كل تغيير',
                                  'Real-time sync with Supabase after every change',
                                )
                              : _t(
                                  context,
                                  'غير متاح - تحقق من إعدادات Supabase',
                                  'Not available - check Supabase configuration',
                                ),
                        ),
                        value: isAutoSyncEnabled && isAvailable,
                        onChanged: isAvailable
                            ? (enabled) {
                                ref.read(toggleAutoSyncProvider)(enabled);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      enabled
                                          ? _t(
                                              context,
                                              'تم تفعيل المزامنة التلقائية',
                                              'Auto-sync enabled',
                                            )
                                          : _t(
                                              context,
                                              'تم إيقاف المزامنة التلقائية',
                                              'Auto-sync disabled',
                                            ),
                                    ),
                                    backgroundColor: enabled
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                );
                              }
                            : null,
                        secondary: Icon(
                          Icons.sync_rounded,
                          color: isAvailable && isAutoSyncEnabled
                              ? Colors.green
                              : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cloud_upload_rounded),
                        title: Text(
                          _t(
                            context,
                            'رفع البيانات على Supabase',
                            'Upload Data to Supabase',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'تحميل كل البيانات المحلية إلى السحابة',
                            'Upload all local data to the cloud database',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          // Get database instance
                          final database = ref.read(dbProvider);
                          final migrationService = PushLocalToSupabaseService();

                          await _showMigrationDialog(
                            context,
                            ref,
                            migrationService,
                            database,
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.cloud_off_rounded,
                          color: Colors.orange,
                        ),
                        title: Text(
                          _t(
                            context,
                            'حذف بيانات Supabase',
                            'Clear Supabase Data',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'مسح جميع البيانات من قاعدة البيانات السحابية',
                            'Delete all data from cloud database',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await _showClearSupabaseDialog(context);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                        ),
                        title: Text(
                          _t(
                            context,
                            'حذف البيانات المحلية',
                            'Clear Local Data',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'مسح جميع البيانات من التطبيق المحلي',
                            'Delete all data from local database',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final database = ref.read(dbProvider);
                          await _showClearLocalDialog(context, database);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.backup_rounded,
                          color: Colors.green,
                        ),
                        title: Text(
                          _t(
                            context,
                            'إضافة بيانات تجريبية',
                            'Seed Sample Data',
                          ),
                        ),
                        subtitle: Text(
                          _t(
                            context,
                            'إضافة البيانات الأولية للاختبار',
                            'Add initial sample data for testing',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final database = ref.read(dbProvider);
                          await _seedSampleData(context, database, ref);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show dialog to clear Supabase data
  Future<void> _showClearSupabaseDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              Text(_t(context, 'تحذير!', 'Warning!')),
            ],
          ),
          content: Text(
            _t(
              context,
              'هل أنت متأكد من حذف جميع البيانات من Supabase؟\nهذا الإجراء لا يمكن التراجع عنه!',
              'Are you sure you want to delete all data from Supabase?\nThis action cannot be undone!',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_t(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _executeClearSupabase(context);
              },
              child: Text(_t(context, 'حذف', 'Delete')),
            ),
          ],
        );
      },
    );
  }

  /// Execute Supabase data clearing
  Future<void> _executeClearSupabase(BuildContext context) async {
    String currentTable = '';
    int clearedTables = 0;
    int totalTables = 25;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(context, 'جاري حذف البيانات...', 'Clearing Data...'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _t(context, 'جدول: $currentTable', 'Table: $currentTable'),
                  ),
                  const SizedBox(height: 10),
                  Text('$clearedTables / $totalTables'),
                ],
              ),
            );
          },
        );
      },
    );

    try {
      final clearService = ClearSupabaseData();
      final result = await clearService.clearAllData(
        onTableCleared: (tableName) {
          // Update progress - but dialog is already showing
        },
      );

      if (context.mounted) {
        Navigator.pop(context); // Close progress dialog

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _t(
                  context,
                  'تم حذف ${result['totalRowsDeleted']} سجل من ${result['totalTablesCleared']} جدول',
                  'Deleted ${result['totalRowsDeleted']} rows from ${result['totalTablesCleared']} tables',
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _t(
                  context,
                  'خطأ: ${result['error']}',
                  'Error: ${result['error']}',
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(context, 'فشل الحذف: $e', 'Delete failed: $e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show dialog to clear local data
  Future<void> _showClearLocalDialog(
    BuildContext context,
    dynamic database,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(_t(context, 'تحذير خطير!', 'Critical Warning!')),
            ],
          ),
          content: Text(
            _t(
              context,
              'هل أنت متأكد من حذف جميع البيانات المحلية؟\nسيتم فقدان كل شيء إذا لم تقم برفع البيانات للسحابة!\nهذا الإجراء لا يمكن التراجع عنه!',
              'Are you sure you want to delete all local data?\nEverything will be lost if you haven\'t uploaded to cloud!\nThis action cannot be undone!',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_t(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _executeClearLocal(context, database);
              },
              child: Text(_t(context, 'حذف نهائياً', 'Delete Permanently')),
            ),
          ],
        );
      },
    );
  }

  /// Execute local data clearing
  Future<void> _executeClearLocal(
    BuildContext context,
    dynamic database,
  ) async {
    // Show progress dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _t(
              context,
              'جاري حذف البيانات المحلية...',
              'Clearing Local Data...',
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );

    try {
      final clearService = LocalDataClearer(database);
      await clearService.clearAllData();

      if (context.mounted) {
        Navigator.pop(context); // Close progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(
                context,
                'تم حذف جميع البيانات المحلية بنجاح',
                'All local data cleared successfully',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(context, 'فشل الحذف: $e', 'Delete failed: $e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Seed sample data
  Future<void> _seedSampleData(
    BuildContext context,
    dynamic database,
    WidgetRef ref,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _t(
              context,
              'إضافة البيانات التجريبية',
              'Add Sample Data',
            ),
          ),
          content: Text(
            _t(
              context,
              'هل تريد إضافة بيانات تجريبية للاختبار؟',
              'Do you want to add sample data for testing?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(_t(context, 'إلغاء', 'Cancel')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _executeSeedData(context, database, ref);
              },
              child: Text(_t(context, 'إضافة', 'Add')),
            ),
          ],
        );
      },
    );
  }

  /// Execute seeding of sample data
  Future<void> _executeSeedData(
    BuildContext context,
    dynamic database,
    WidgetRef ref,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _t(
              context,
              'جاري إضافة البيانات...',
              'Adding Sample Data...',
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );

    try {
      await database.seedSampleData();

      if (context.mounted) {
        Navigator.pop(context); // Close progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(
                context,
                'تم إضافة البيانات التجريبية بنجاح',
                'Sample data added successfully',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Invalidate providers to refresh UI
        ref.invalidate(productsStreamProvider);
        ref.invalidate(filteredProductsStreamProvider);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(context, 'فشل الإضافة: $e', 'Add failed: $e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
