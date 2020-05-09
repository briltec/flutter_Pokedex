import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/configs/colors.dart';
import 'package:pokedex/domain/entities/pokemon.dart';
import 'package:pokedex/providers/providers.dart';
import 'package:pokedex/ui/screens/pokemon_info/widgets/tab_about.dart';
import 'package:pokedex/ui/screens/pokemon_info/widgets/tab_base_stats.dart';
import 'package:pokedex/ui/screens/pokemon_info/widgets/tab_evolution.dart';

class TabData {
  const TabData({this.label, this.builder});

  final Widget Function(Pokemon pokemon, Animation animation) builder;
  final String label;
}

class PokemonTabInfo extends StatelessWidget {
  final Animation _animation;

  final List<TabData> _tabs = [
    TabData(
      label: 'About',
      builder: (pokemon, animation) => PokemonAbout(pokemon, animation),
    ),
    TabData(
      label: 'Base Stats',
      builder: (pokemon, animation) => PokemonBaseStats(pokemon),
    ),
    TabData(
      label: 'Evolution',
      builder: (pokemon, animation) => PokemonEvolution(pokemon, animation),
    ),
    TabData(
      label: 'Moves',
      builder: (pokemon, animation) => Container(
        alignment: Alignment.topCenter,
        child: Text('Under development'),
      ),
    ),
  ];

  PokemonTabInfo(this._animation);

  Widget _buildTabBar() {
    return TabBar(
      labelColor: AppColors.black,
      unselectedLabelColor: AppColors.grey,
      labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2,
      indicatorColor: AppColors.indigo,
      tabs: _tabs.map((tab) => Text(tab.label)).toList(),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: Consumer((context, read) {
        final currentPokemon = read(currentPokemonStateProvider).pokemon;

        return TabBarView(
          children: _tabs.map((tab) => tab.builder(currentPokemon, _animation)).toList(),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) => SizedBox(height: (1 - _animation.value) * 16 + 6),
            ),
            _buildTabBar(),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }
}
