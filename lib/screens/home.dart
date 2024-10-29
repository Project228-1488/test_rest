import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:test_rest/bloc/rec_combo_bloc.dart';
import 'package:test_rest/constants/app_colors.dart';
import 'package:test_rest/constants/app_size.dart';
import 'package:test_rest/constants/app_texts.dart';
import 'package:test_rest/model/rec_combo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  String searchQuery = '';
  List<RecCombo> filteredItems = [];

  bool isLoading = true;

  final List<String> categories = ['Hottest', 'Popular', 'New Combo', 'Top'];

  final List<RecCombo> items = [
    RecCombo(
      name: AppTexts.kCombo1,
      imagePath: 'assets/images/rec1.png',
      price: '2,000',
    ),
    RecCombo(
      name: AppTexts.kCombo2,
      imagePath: 'assets/images/rec2.png',
      price: '8,000',
    ),
  ];

  final Map<String, List<RecCombo>> categoryItems = {
    'Hottest': [
      RecCombo(
          name: 'Quinoa fruit salad',
          imagePath: 'assets/images/rec1.png',
          price: '2,500'),
      RecCombo(
          name: 'Tropical fruit salad',
          imagePath: 'assets/images/rec2.png',
          price: '3,500'),
      RecCombo(
          name: 'Melon fruit salad',
          imagePath: 'assets/images/rec3.png',
          price: '5,500'),
    ],
    'Popular': [
      RecCombo(
          name: 'Combo P1',
          imagePath: 'assets/images/rec4.png',
          price: '1,500'),
      RecCombo(
          name: 'Combo P2',
          imagePath: 'assets/images/rec5.png',
          price: '4,500'),
      RecCombo(
          name: 'Combo P3',
          imagePath: 'assets/images/rec1.png',
          price: '2,500'),
    ],
    'New Combo': [
      RecCombo(
          name: 'Combo N1',
          imagePath: 'assets/images/rec2.png',
          price: '8,500'),
      RecCombo(
          name: 'Combo N2',
          imagePath: 'assets/images/rec3.png',
          price: '4,500'),
      RecCombo(
          name: 'Combo N3',
          imagePath: 'assets/images/rec4.png',
          price: '2,500'),
    ],
    'Top': [
      RecCombo(
          name: 'Combo T1',
          imagePath: 'assets/images/rec5.png',
          price: '5,500'),
      RecCombo(
          name: 'Combo T2',
          imagePath: 'assets/images/rec1.png',
          price: '1,500'),
      RecCombo(
          name: 'Combo T3',
          imagePath: 'assets/images/rec2.png',
          price: '7,500'),
    ],
  };

  void showBasket() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 240,
            height: 200,
            child: Center(
              child: Text(
                AppTexts.kBasketText,
                style: TextStyle(
                  color: AppColors.kTextColor,
                  fontFamily: 'BrandonGrotesque',
                  fontSize: AppSize.kFontHeadlineLargeSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void showAddedToBasketDialog(String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 240,
            height: 200,
            child: Center(
              child: Text(
                '$itemName Added',
                style: TextStyle(
                  color: AppColors.kTextColor,
                  fontFamily: 'BrandonGrotesque',
                  fontSize: AppSize.kFontHeadlineLargeSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void showSearchResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text("Search Results",
                  style: TextStyle(
                      fontFamily: 'BrandonGrotesque',
                      fontSize: AppSize.kFontBodyLargeSize,
                      color: AppColors.kTextColor,
                      fontWeight: FontWeight.bold))),
          content: SizedBox(
            width: 300,
            height: 200,
            child: BlocBuilder<RecComboBloc, RecComboState>(
              builder: (context, state) {
                if (state is RecCombosLoaded) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        leading:
                            Image.asset(item.imagePath, width: 40, height: 40),
                        title: Text(item.name),
                        subtitle: Text(item.price),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close,
                    color: AppColors.kTextColor,
                    size: AppSize.kFontHeadlineLargeSize),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildCategoryTabs() {
    return TabBar(
      controller: tabController,
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(width: 4.0, color: Colors.orange),
        insets: EdgeInsets.only(
            left: AppSize.kSmallPadding, right: AppSize.kSmallPadding),
      ),
      tabs: categories.asMap().entries.map((entry) {
        int index = entry.key;
        String category = entry.value;
        return Tab(
          child: Text(
            category,
            style: TextStyle(
              color: AppColors.kTextColor,
              fontFamily: 'BrandonGrotesque',
              fontSize: AppSize.kFontHeadlineMediumSize,
              fontWeight: tabController.index == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildComboItems(List<RecCombo> items) {
    final colors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
    ];

    if (isLoading) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            items.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.kSmallPadding),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                color: Colors.grey.shade300,
                enabled: isLoading,
                child: Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          RecCombo item = entry.value;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.kSmallPadding),
            child: GestureDetector(
              onTap: () {
                showAddedToBasketDialog(item.name);
              },
              child: Container(
                padding: EdgeInsets.all(AppSize.kSmallPadding),
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border, color: Colors.orange),
                      ],
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(item.imagePath),
                    ),
                    SizedBox(height: AppSize.kSmallPadding),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.kFontLabelLargeSize,
                      ),
                    ),
                    SizedBox(height: AppSize.kSmallPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/naira.svg',
                          height: 12,
                          width: 12,
                          color: Colors.orange,
                        ),
                        SizedBox(width: AppSize.kSmallPadding),
                        Text(
                          item.price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSize.kFontLabelLargeSize,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: AppSize.kMediumPadding),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.orange, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSearchField() {
    return Container(
      width: 260,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          SizedBox(width: AppSize.kSmallPadding),
          const Icon(Icons.search, color: AppColors.kTextColor),
          SizedBox(width: AppSize.kSmallPadding),
          Expanded(
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                context
                    .read<RecComboBloc>()
                    .add(SearchRecCombos(query: searchQuery, items: items));
                if (searchQuery.isNotEmpty) {
                  showSearchResultsDialog();
                }
              },
              decoration: const InputDecoration(
                hintText: AppTexts.kSearch,
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: 'BrandonGrotesque',
                fontSize: AppSize.kFontHeadlineMediumSize,
                color: AppColors.kTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilteredItems() {
    return Expanded(
      child: BlocBuilder<RecComboBloc, RecComboState>(
        builder: (context, state) {
          if (state is RecCombosLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSize.kSmallPadding),
                  child: Container(
                    padding: EdgeInsets.all(AppSize.kSmallPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(item.imagePath),
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item.price),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    filteredItems = items;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecComboBloc()..add(LoadRecCombos(items: items)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const Drawer(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: AppSize.kLargePadding,
                bottom: AppSize.kMediumPadding,
                left: AppSize.kMediumPadding,
                right: AppSize.kMediumPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            height: 42.0,
                            alignment: Alignment.center,
                            child: const Icon(Icons.menu,
                                color: AppColors.kTextColor),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: showBasket,
                      child: Container(
                          height: 42.0,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_basket_outlined,
                                  color: Colors.orange),
                              Text(AppTexts.kBasket,
                                  style: TextStyle(
                                    fontFamily: 'BrandonGrotesque',
                                    fontSize: AppSize.kFontHeadlineMediumSize,
                                  ))
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.kMediumPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppTexts.kNickname,
                        style: TextStyle(
                          fontFamily: 'BrandonGrotesque',
                          fontSize: AppSize.kFontHeadlineLargeSize,
                        )),
                    Text(AppTexts.kTitle1,
                        style: TextStyle(
                          fontFamily: 'BrandonGrotesque',
                          fontSize: AppSize.kFontHeadlineLargeSize,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppTexts.kTitle2,
                        style: TextStyle(
                          fontFamily: 'BrandonGrotesque',
                          fontSize: AppSize.kFontHeadlineLargeSize,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(height: AppSize.kMediumPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSearchField(),
                    const Icon(Icons.filter_alt_outlined,
                        color: AppColors.kTextColor)
                  ],
                ),
                SizedBox(height: AppSize.kMediumPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppTexts.kComboTitle,
                        style: TextStyle(
                          fontFamily: 'BrandonGrotesque',
                          fontSize: AppSize.kFontHeadlineLargeSize,
                          color: AppColors.kTextColor,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
                SizedBox(height: AppSize.kMediumPadding),
                BlocBuilder<RecComboBloc, RecComboState>(
                  builder: (context, state) {
                    if (state is RecCombosLoaded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: state.items.map((item) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.kSmallPadding,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showAddedToBasketDialog(item.name);
                              },
                              child: Container(
                                padding: EdgeInsets.all(AppSize.kSmallPadding),
                                width: 140,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.favorite_border,
                                            color: Colors.orange),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(item.imagePath),
                                    ),
                                    SizedBox(height: AppSize.kSmallPadding),
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSize.kFontLabelLargeSize,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.kSmallPadding),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/naira.svg',
                                          height: 12,
                                          width: 12,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(width: AppSize.kSmallPadding),
                                        Text(
                                          item.price,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                AppSize.kFontLabelLargeSize,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        SizedBox(width: AppSize.kMediumPadding),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Colors.orange, size: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: AppSize.kMediumPadding),
                buildCategoryTabs(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: categories
                        .map((category) =>
                            buildComboItems(categoryItems[category]!))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
