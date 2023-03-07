///木を構成する要素
class TreeElement {
  final int id;
  TreeElement? parent;
  final List<TreeElement> childs;
  TreeElement(this.id, this.parent) : childs = [];
}
