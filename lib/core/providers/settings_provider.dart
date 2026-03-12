import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final String costVisibilityPassword;
  final String costRecoveryCode;
  final String? databaseDirectoryPath;

  const SettingsState({
    required this.locale,
    required this.themeMode,
    required this.costVisibilityPassword,
    required this.costRecoveryCode,
    this.databaseDirectoryPath,
  });

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    String? costVisibilityPassword,
    String? costRecoveryCode,
    String? databaseDirectoryPath,
    bool clearDatabaseDirectoryPath = false,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      costVisibilityPassword:
          costVisibilityPassword ?? this.costVisibilityPassword,
      costRecoveryCode: costRecoveryCode ?? this.costRecoveryCode,
      databaseDirectoryPath: clearDatabaseDirectoryPath
          ? null
          : (databaseDirectoryPath ?? this.databaseDirectoryPath),
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const _kLocaleKey = 'app_locale';
  static const _kThemeModeKey = 'app_theme_mode';
  static const _kCostPasswordKey = 'inventory_cost_password';
  static const _kDatabaseDirectoryPathKey = 'database_directory_path';
  static const _defaultCostPassword = '8520';
  static const _defaultRecoveryCode = '0000';

  SettingsNotifier()
    : super(
        const SettingsState(
          locale: Locale('ar'),
          themeMode: ThemeMode.system,
          costVisibilityPassword: _defaultCostPassword,
          costRecoveryCode: _defaultRecoveryCode,
          databaseDirectoryPath: null,
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Locale
    final localeCode = prefs.getString(_kLocaleKey);
    final locale = localeCode != null ? Locale(localeCode) : const Locale('ar');

    // Load ThemeMode
    final themeModeIndex = prefs.getInt(_kThemeModeKey);
    final themeMode = themeModeIndex != null
        ? ThemeMode.values[themeModeIndex]
        : ThemeMode.system;

    // Load Cost Password
    final costPassword =
        prefs.getString(_kCostPasswordKey) ?? _defaultCostPassword;

    // Load Database Directory Path
    final databaseDirectoryPath = prefs.getString(_kDatabaseDirectoryPathKey);

    state = SettingsState(
      locale: locale,
      themeMode: themeMode,
      costVisibilityPassword: costPassword,
      costRecoveryCode: _defaultRecoveryCode,
      databaseDirectoryPath: databaseDirectoryPath,
    );
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) return;
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeModeKey, themeMode.index);
  }

  bool verifyCostPassword(String input) {
    return input.trim() == state.costVisibilityPassword;
  }

  Future<bool> changeCostPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.trim().isEmpty) return false;
    if (currentPassword.trim() != state.costVisibilityPassword) return false;

    state = state.copyWith(costVisibilityPassword: newPassword.trim());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCostPasswordKey, newPassword.trim());
    return true;
  }

  Future<bool> resetCostPasswordWithRecovery({
    required String recoveryCode,
    required String newPassword,
  }) async {
    if (newPassword.trim().isEmpty) return false;
    if (recoveryCode.trim() != state.costRecoveryCode) return false;

    state = state.copyWith(costVisibilityPassword: newPassword.trim());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCostPasswordKey, newPassword.trim());
    return true;
  }

  Future<void> setDatabaseDirectoryPath(String path) async {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(databaseDirectoryPath: trimmed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDatabaseDirectoryPathKey, trimmed);
  }

  Future<void> clearDatabaseDirectoryPath() async {
    state = state.copyWith(clearDatabaseDirectoryPath: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDatabaseDirectoryPathKey);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);
