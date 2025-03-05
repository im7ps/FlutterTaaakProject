import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
	static final appTheme = ThemeData(
		primaryColor: AppColors.primary,
		scaffoldBackgroundColor: AppColors.mainBackground,
		fontFamily: 'Raleway',
		inputDecorationTheme: InputDecorationTheme(
			filled: true,
			fillColor: AppColors.secondaryBackground,
			hintStyle: const TextStyle(
				color: AppColors.hintTextColor,
				fontWeight: FontWeight.w500,
			),
			contentPadding: const EdgeInsets.all(30),
			border: OutlineInputBorder(
				borderRadius: BorderRadius.circular(4),
				borderSide: BorderSide.none,
			),
			enabledBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(4),
				borderSide: BorderSide.none,
			),
		),
		buttonTheme: ButtonThemeData(
			buttonColor: AppColors.primary,
			textTheme: ButtonTextTheme.primary,
		),
		textTheme: TextTheme(
			headlineLarge: TextStyle(
				color: Colors.white,
				fontSize: 32,
				fontWeight: FontWeight.bold,
			),
			headlineSmall: TextStyle(
				color: Colors.white,
				fontSize: 20,
				fontWeight: FontWeight.w600,
			),
			bodyMedium: TextStyle(
				color: Colors.white,
				fontSize: 16,
			),
		),
		iconTheme: IconThemeData(
			color: Colors.white,
		),
	);
}