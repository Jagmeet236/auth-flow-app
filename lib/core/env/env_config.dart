enum Environment { staging, production }

class EnvConfig {
  static Environment currentEnv = Environment.staging;

  static String get baseUrl {
    switch (currentEnv) {
      case Environment.staging:
        return 'https://api2-staging.codemitra.org';

      case Environment.production:
        return '';
    }
  }

  static bool get isProd => currentEnv == Environment.production;
}
