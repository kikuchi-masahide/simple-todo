import 'dart:collection';
import 'package:flutter_app/model/types/task.dart';
import 'package:flutter_app/model/types/tree_element.dart';
import 'package:tuple/tuple.dart';

///Taskの森構造を管理するためのクラス IDのみ保持する
class TasksTrees {
  //id => 要素
  final Map<int, TreeElement> _elems;
  final List<TreeElement> _roots;

  ///ソートの時に使う関数
  late int Function(Task, Task) _sorter;

  TasksTrees()
      : _elems = {},
        _roots = [],
        _sorter = ((a, b) => b.id - a.id);

  void init(Map<int, Task> tasks) {
    for (var task in tasks.values) {
      //要素を森に追加ずみ
      if (_elems[task.id] != null) {
        continue;
      }
      //Stackとして利用
      //task、親、その親...の順に辿りIDをpush。「森に追加済みのTaskの子」または「根となるTask」が来たら、そこまででpushをやめる。その後IDをpopし要素を森へ追加するのを繰り返す
      Queue<int> q = Queue();
      int cur = task.id;
      while (true) {
        q.addFirst(cur);
        var t = tasks[cur] as Task;
        var par = t.parentId;
        if (par == null || _elems[par] != null) {
          break;
        }
        cur = par;
      }
      while (q.isNotEmpty) {
        var id = q.removeFirst();
        var t = tasks[id] as Task;
        var par = _elems[t.parentId];
        var elem = TreeElement(t, par);
        _elems[id] = elem;
        if (par == null) {
          _roots.add(elem);
        } else {
          par.childs.add(elem);
        }
      }
    }
  }

  //指定したファンクタで子を昇順ソート(a < b <==> functor(a,b)  < 0)
  void sortWith(int Function(Task, Task) functor) {
    _sorter = functor;
    _roots.sort((a, b) => _sorter(a.task, b.task));
    //この頂点の子をソート
    Queue<TreeElement> q = Queue();
    q.addAll(_roots);
    while (q.isNotEmpty) {
      var e = q.removeFirst();
      e.childs.sort((a, b) => _sorter(a.task, b.task));
      q.addAll(e.childs);
    }
  }

  ///全頂点eに対して深さ優先でfunc(e.id,深さ)を実行
  ///返り値がfalseの場合、子に対し実行を行わない
  void iterate(bool Function(Task, int) func) {
    //スタックとして利用 <要素、深さ>
    Queue<Tuple2<TreeElement, int>> q = Queue();
    for (var root in _roots) {
      q.addFirst(Tuple2(root, 0));
      while (q.isNotEmpty) {
        var tuple = q.removeFirst();
        var e = tuple.item1;
        var depth = tuple.item2;
        if (func(e.task, depth)) {
          for(var element in e.childs.reversed){
            q.addFirst(Tuple2(element, depth + 1));
          }
        }
      }
    }
  }

  bool hasChilds(int id) {
    return _elems[id]!.childs.isNotEmpty;
  }

  //この要素の全ての子が述語conditionを満たすか否か
  bool doAllChildsSatisfy(int id, bool Function(Task) condition) {
    var ret = true;
    var par = _elems[id]!;
    for (var ch in par.childs) {
      if (!condition(ch.task)) {
        ret = false;
        break;
      }
    }
    return ret;
  }

  ///木の更新
  void update(int id) {
    var elem = _elems[id]!;
    var oldParElem = _elems[id]!.parent;
    var newParElem = _elems[elem.task.parentId];
    elem.parent = newParElem;
    if (oldParElem != newParElem) {
      //親の変更があったので、古い親の子要素listから削除
      if (oldParElem != null) {
        oldParElem.childs.remove(elem);
      } else {
        _roots.remove(elem);
      }
      //新しい親の子要素listに追加
      if (newParElem != null) {
        newParElem.childs.add(elem);
      } else {
        _roots.add(elem);
      }
      if (newParElem != null) {
        newParElem.childs.sort(
          (a, b) => _sorter(a.task, b.task),
        );
      } else {
        _roots.sort((a, b) => _sorter(a.task, b.task));
      }
    }
  }

  void addElement(Task task) {
    var parEle = _elems[task.parentId];
    var ele = TreeElement(task, parEle);
    _elems[task.id] = ele;
    if (parEle != null) {
      parEle.childs.add(ele);
      parEle.childs.sort((a, b) => _sorter(a.task, b.task));
    } else {
      _roots.add(ele);
      _roots.sort((a, b) => _sorter(a.task, b.task));
    }
  }

  void deleteElement(int id) {
    var ele = _elems.remove(id)!;
    var parElem = ele.parent;
    if (parElem != null) {
      parElem.childs.remove(ele);
    } else {
      _roots.remove(ele);
    }
    for (var child in ele.childs) {
      child.parent = null;
    }
    _roots.addAll(ele.childs);
  }
}
