class ImageUtils {
  static const String baseUrl = "http://216.126.239.86:5000";

  static String format(String url) {
    if (url.isEmpty) return "";

    if (url.startsWith("http")) return url;

    if (url.startsWith("data:image")) return url;

    if (url.startsWith("/")) {
      return "$baseUrl$url";
    }

    return "$baseUrl/$url";
  }
}
