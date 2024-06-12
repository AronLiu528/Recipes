import 'package:flutter/material.dart';
//import 'package:flutter_04/main.dart';

import 'package:flutter_04/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({super.key, required this.category,required this.onSelectCatgory});

  final Category category;
  final void Function() onSelectCatgory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCatgory,//lesson .160
      splashColor: Theme.of(context).primaryColor, //陰影效果，lesson .157
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.5),
              category.color.withOpacity(1.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    ); //lesson .157
  }
}
