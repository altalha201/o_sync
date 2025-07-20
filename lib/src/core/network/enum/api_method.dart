enum OSyncNetworkMethod {
  get,
  post,
  put,
  patch,
  delete,
}

extension ApiMethodeExt on OSyncNetworkMethod {
  String get value => name.toUpperCase();
}