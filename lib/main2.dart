

void main() {
  const string1 = "string";
  const string2 = "string";
  final string3 = "string";
  var string4 = "string";
  print(identical(string1, string2));
  print(identical(string1, string3));
  print(identical(string1, string4));
  print(identical(string3, string4));
}