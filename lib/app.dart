import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/salary_provider.dart';
import 'screens/home_screen.dart';

class SalaryManagementApp extends StatelessWidget {
  const SalaryManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Salary Management',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
