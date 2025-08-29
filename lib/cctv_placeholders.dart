final Map<String, String> cctvGroups = {
  "simpang pdam": "assets/simpang-pdam.png",
  "simpang dharma": "assets/simpang-dharma.png",
  "dinkes": "assets/dinkes.png",
  "simpang jambo tape": "assets/simpang-jambo-tape.png",
  "bustanussalatin": "assets/bustanussalatin.png",
};

String getCctvPlaceholder(String name) {
  final normalized = name.toLowerCase().trim();
  for (final entry in cctvGroups.entries) {
    if (normalized.contains(entry.key)) {
      return entry.value;
    }
  }
  return "assets/logo-diskominfotik.png";
}
