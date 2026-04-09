class EnvConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api2-staging.codemitra.org',
  );
}