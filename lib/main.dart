import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _show = false;
  PageController _pageController = PageController();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: !_show
          ? null
          : CustomBottomNavigationBar(
              context: context,
              currentIndex: _selectedIndex,
              onChange: (index) {
                setState(() => _selectedIndex = index);
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              items: [
                CustomBottomNavigationItem(
                  icon: Icons.home,
                  label: 'Home',
                ),
                CustomBottomNavigationItem(
                  icon: Icons.store,
                  label: 'Store',
                ),
                CustomBottomNavigationItem(
                  icon: Icons.add,
                ),
                CustomBottomNavigationItem(
                  icon: Icons.explore,
                  label: 'Explore',
                ),
                CustomBottomNavigationItem(
                  icon: Icons.person,
                  label: 'Profile',
                ),
              ],
            ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Container(
            color: Colors.pink,
          ),
          Container(
            color: Colors.cyan,
          ),
          Container(
            color: Colors.deepPurple,
          ),
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.lightBlue,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _show = !_show;
          _show
              ? _animationController.forward()
              : _animationController.reverse();
        }),
        child: AnimatedIcon(
          progress: _animationController,
          icon: AnimatedIcons.close_menu,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final BuildContext context;
  final List<CustomBottomNavigationItem> items;
  final Function(int) onChange;
  final int currentIndex;

  CustomBottomNavigationBar({
    @required this.context,
    @required this.items,
    @required this.onChange,
    this.currentIndex = 0,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedWidth =
        MediaQuery.of(widget.context).size.width / widget.items.length;
    return Container(
      height: 60,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(
              left: widget.currentIndex < 3
                  ? selectedWidth * widget.currentIndex + 5.0
                  : selectedWidth * (widget.currentIndex - 1) + 60.0,
            ),
            curve: Curves.easeOutQuart,
            duration: Duration(seconds: 1),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: 40.0,
              width: widget.currentIndex == 2 ? 50.0 : selectedWidth + 10.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items.map((item) {
              final index = widget.items.indexOf(item);
              return GestureDetector(
                onTap: () => widget.onChange(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width:
                      widget.currentIndex == index && widget.currentIndex != 2
                          ? selectedWidth
                          : 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: widget.currentIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      widget.currentIndex == index && item.label != null
                          ? Expanded(
                              flex: 2,
                              child: Text(
                                item.label ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  CustomBottomNavigationItem({
    @required this.icon,
    this.label,
    this.color,
  });
}
