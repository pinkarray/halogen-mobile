String capitalizeEachWord(String input) {
  return input
      .split(' ')
      .map((word) =>
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
