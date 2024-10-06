// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello, Enter your employee number!`
  String get auth_hello {
    return Intl.message(
      'Hello, Enter your employee number!',
      name: 'auth_hello',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get auth_button {
    return Intl.message(
      'Continue',
      name: 'auth_button',
      desc: '',
      args: [],
    );
  }

  /// `Depets`
  String get home_tab1 {
    return Intl.message(
      'Depets',
      name: 'home_tab1',
      desc: '',
      args: [],
    );
  }

  /// `Soon`
  String get home_tab2 {
    return Intl.message(
      'Soon',
      name: 'home_tab2',
      desc: '',
      args: [],
    );
  }

  /// `Soon`
  String get home_tab3 {
    return Intl.message(
      'Soon',
      name: 'home_tab3',
      desc: '',
      args: [],
    );
  }

  /// `Depets List`
  String get home_lbl {
    return Intl.message(
      'Depets List',
      name: 'home_lbl',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get home_search {
    return Intl.message(
      'Search',
      name: 'home_search',
      desc: '',
      args: [],
    );
  }

  /// `Total  :  {Total}  LE.`
  String home_total(Object Total) {
    return Intl.message(
      'Total  :  $Total  LE.',
      name: 'home_total',
      desc: '',
      args: [Total],
    );
  }

  /// `New Entry`
  String get home_newEntry {
    return Intl.message(
      'New Entry',
      name: 'home_newEntry',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get home_name {
    return Intl.message(
      'Name',
      name: 'home_name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get home_phoneNum {
    return Intl.message(
      'Phone',
      name: 'home_phoneNum',
      desc: '',
      args: [],
    );
  }

  /// `Money`
  String get home_money {
    return Intl.message(
      'Money',
      name: 'home_money',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get home_actions {
    return Intl.message(
      'Actions',
      name: 'home_actions',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
