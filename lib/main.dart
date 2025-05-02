import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_form_data_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/services_screen.dart';
import 'screens/physical_security_screen.dart';
import 'screens/continue_registration_screen.dart';
import 'screens/secured_mobility/desired_services/desired_services_screen.dart';
import 'screens/secured_mobility/secured_mobility_screen.dart';
import 'screens/secured_mobility/service_configuration_screen.dart';
import 'screens/secured_mobility/schedule_service_screen.dart';
import "screens/secured_mobility/confirm_order_screen.dart";
import 'screens/secured_mobility/payment_screen.dart';
import 'screens/outsourcing_talent/desired_services/desired_services_screen.dart';
import 'screens/outsourcing_talent/outsourcing_talent_screen.dart';
import 'screens/outsourcing_talent/description_of_need_screen.dart';
import 'screens/outsourcing_talent/confirmation_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserFormDataProvider()),
      ],
      child: const HalogenApp(),
    ),
  );
}

class HalogenApp extends StatelessWidget {
  const HalogenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Objective',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white,
          hourMinuteTextColor: Colors.black,
          dayPeriodTextColor: Colors.black,
          dialHandColor: Colors.black,
          dialBackgroundColor: Color(0xFFEDEDED),
          hourMinuteColor: Color(0xFFEDEDED),
          entryModeIconColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          headerForegroundColor: Colors.black,
          dayForegroundColor: WidgetStatePropertyAll(Colors.black),
          todayBackgroundColor: WidgetStatePropertyAll(Colors.black),
          todayForegroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIconColor: Colors.black,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Colors.black, width: 1.5),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.black;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'Objective'),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/services': (context) => const ServicesScreen(),
        '/physical-security': (context) => const PhysicalSecurityScreen(),
        '/continue-registration':
            (context) => const ContinueRegistrationScreen(),
        '/secured-mobility': (context) => const SecuredMobilityScreen(),
        '/secured-mobility/desired-services':
            (context) => const SecuredMobilityDesiredServicesScreen(),
        '/secured-mobility/service-configuration':
            (context) => const SecuredMobilityServiceConfigurationScreen(),
        '/secured-mobility/schedule-service':
            (context) => const ScheduleServiceScreen(),
        '/secured-mobility/summary': (context) => const ConfirmOrderScreen(),
        '/secured-mobility/payment': (context) => const PaymentScreen(),
        '/outsourcing-talent/desired-services': (context) => const OutsourcingDesiredServicesScreen(),
        '/outsourcing-talent': (context) => const OutsourcingTalentScreen(),
        '/outsourcing-talent/description': (context) => const DescriptionOfNeedScreen(),
        '/outsourcing-talent/confirmation': (context) => const ConfirmationScreen(),
      },
    );
  }
}
