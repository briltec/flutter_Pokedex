import 'package:flutter/material.dart';
import 'package:pokedex/configs/AppColors.dart';

class FabItem {
  final String title;
  final IconData icon;
  final Function onPress;

  const FabItem(this.title, this.icon, {this.onPress});
}

class FabMenuItem extends StatelessWidget {
  final FabItem item;

  const FabMenuItem(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: StadiumBorder(),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 16),
      color: Colors.white,
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.1),
      elevation: 0,
      highlightElevation: 2,
      disabledColor: Colors.white,
      onPressed: item.onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(item.title),
          SizedBox(width: 8),
          Icon(item.icon, color: AppColors.indigo),
        ],
      ),
    );
  }
}

class ExpandedAnimationFab extends AnimatedWidget {
  final List<FabItem> items;
  final Function onPress;

  const ExpandedAnimationFab({
    @required this.items,
    this.onPress,
    Animation animation,
  }) : super(listenable: animation);

  get _animation => listenable;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    final transform = Matrix4.translationValues(
      -(screenWidth - _animation.value * screenWidth) * ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: FabMenuItem(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          padding: EdgeInsets.symmetric(vertical: 12),
          itemCount: items.length,
          itemBuilder: buildItem,
        ),
        FloatingActionButton(
          backgroundColor: AppColors.indigo,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animation,
          ),
          onPressed: onPress,
        ),
      ],
    );
  }
}
