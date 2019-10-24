import 'package:flutter/widgets.dart';

class Page {
  const Page({@required this.title, @required this.path, @required this.widgetBuilder, this.icon, this.children});

  final WidgetBuilder widgetBuilder;
  final String path;
  final String title;
  final String icon;

  final List<Page> children;
}

const Page mainPage = Page(title: "Shared lists", path: "/", widgetBuilder: null);
const Page listPage = Page(title: "List details", path: "/list", widgetBuilder: null);

const List<Page> pages = [mainPage, listPage];
