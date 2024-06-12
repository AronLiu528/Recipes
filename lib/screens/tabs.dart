import 'package:flutter/material.dart';

import 'package:flutter_04/data/dummy_data.dart';
import 'package:flutter_04/models/meal.dart';
import 'package:flutter_04/screens/categories.dart';
import 'package:flutter_04/screens/filters.dart';
import 'package:flutter_04/screens/meals.dart';
import 'package:flutter_04/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
}; //lesson .177 不會變動的初始值

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  } //lesson .166

  final List<Meal> _favoriteMeals = [];

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal); //檢查是否已包含meal

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite');
    } //新增/刪除 Favorite收藏夾
  } //lesson .167
  //setState >>lesson .168

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars(); //先清空前面有的彈出通知
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        //duration: const Duration(seconds: 3),延遲時間，預設4秒
        content: Text(message),
      ),
    );
  } //lesson .168

  Map<Filter, bool> _selectedFilters = kInitialFilters; //lesson .177

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); //每個導航後即關閉Drawer，lesson .172
    if (identifier == 'Filters') {
      //Navigator.of(context).pushReplacement(...) <= 導航至下一頁面不會有左上角返回箭頭，lesson .172
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilter: _selectedFilters,//篩選器的結果再回傳至FilterScreen，Lesson .177
          ),
        ),
      ); //lesson .172
      setState(() {
        _selectedFilters = result ?? kInitialFilters; //如果為null，執行??後的值
      }); //_selectedFilters=自FilterScreen的回傳的，否則=初始值kInitialFilter，lesson .177
    }
  } //lesson .170
  //async & await，lesson .176

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false; //變數後的!:告訴Dart不為空，變數前的!:檢查相反的bool
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false; //A & B皆Ture才為True，才回傳false
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true; //篩選後回傳.where
    }).toList(); //lesson .177

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals, //lesson.177
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals, //lesson .168
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    } //lesson .166

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen), //lesson .169 &.170
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
} //lesson .166
