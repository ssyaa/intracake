class Section<T> {
  final String title;
  final String? subTitle;
  final List<T> items;

  Section({required this.title, required this.subTitle, required this.items});
}