import 'package:flutter/material.dart';
import 'package:nnz/src/controller/category_controller.dart';
import 'package:get/get.dart';
import 'package:nnz/src/model/hot_list.dart';
import 'package:nnz/src/pages/share/sharing_perform.dart';

class HoemCategoryList extends StatefulWidget {
  final String categoryName;

  const HoemCategoryList({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  _HoemCategoryList createState() => _HoemCategoryList();
}

class _HoemCategoryList extends State<HoemCategoryList> {
  final controller = Get.put(CategoryController());

  late List<HotList> hotList;

  Future<void> getList() async {
    await controller.getHotList(widget.categoryName);
    hotList = controller.hotList;
    print(hotList);
    print(hotList.runtimeType);
    // items = showList.content;
    // print();
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const CircularProgressIndicator();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: hotList
                  .map(
                    (item) => Container(
                      width: 110,
                      height: 150,
                      margin: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(
                                () => SharePerformDetail(showIds: item.id)),
                            child: Container(
                              width: 110,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 253, 253),
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: NetworkImage(item.poster),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}
