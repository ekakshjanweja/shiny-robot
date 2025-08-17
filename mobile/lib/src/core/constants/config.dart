class AppConfig {
  static String get scheme => ConfigModel.scheme;
  static String get host => ConfigModel.host;
  static int get port => ConfigModel.port;
}

class ConfigModel {
  static const String scheme = String.fromEnvironment(
    "scheme",
    defaultValue: "http",
  );
  static const String host = String.fromEnvironment(
    "host",
    defaultValue: "10.0.2.2",
  );
  static const int port = int.fromEnvironment("port", defaultValue: 8000);

  ConfigModel._();
}
