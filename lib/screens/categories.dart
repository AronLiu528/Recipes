import 'package:flutter/material.dart';

import 'package:flutter_04/data/dummy_data.dart';
import 'package:flutter_04/models/meal.dart';
import 'package:flutter_04/screens/meals.dart';
import 'package:flutter_04/widgets/category_grid_item.dart';
import 'package:flutter_04/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.availableMeals,
  });

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals; //lesson .177

  void _selectCategory(BuildContext context, Category category) {
    //過濾(where)種類，'meal'>>可任意命名的變數名稱，後續不會使用到
    //.contains()<<檢查列表是否包含某個值
    //.toList()<<過濾後的值儲存為List
    //lesson .161
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    //另一種寫法：Navigator.push(context,MaterialPageRoute....替換
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title, //lesson .161
          meals: filteredMeals, //lesson .161
          onToggleFavorite: onToggleFavorite, //lesson.167 第二條傳遞
        ),
      ),
    );
  } //lesson .160

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCatgory: () {
              _selectCategory(context, category);
              //此category變數與47/49行相同，與_selectCategory方法內的不同，lesson .161
            }, //lesson .160
          ),
        //另一種寫法
        //availableCategories.map((category) => CategoryGridItem(category: category)).toList(),
        //lesson .156
      ],
    );
  }
}
