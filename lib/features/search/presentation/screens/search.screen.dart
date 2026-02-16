import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/common/custom_text_field.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  int _currentCarouselIndex = 0;

  final List<Map<String, String>> _carouselItems = [
    {
      'image': 'assets/images/keychain.jpg',
      'query': 'keychain',
      'title': 'Charming keepsake',
      'desc': 'Customize your keychains',
    },
    {
      'image': 'assets/images/outfits.jpg',
      'query': 'outfits',
      'title': 'Style it',
      'desc': 'Turn basic into iconic',
    },
    {
      'image': 'assets/images/photo_emb.jpg',
      'query': 'photo embroidery',
      'title': 'Cool craft',
      'desc': 'The art of photo-embroidery',
    },
    {
      'image': 'assets/images/quotes.jpg',
      'query': 'motivational quotes',
      'title': 'Go for it',
      'desc': 'Quotes to recharge your motivation',
    },
    {
      'image': 'assets/images/iftar.jpg',
      'query': 'iftar recipe',
      'title': 'Festive foods',
      'desc': 'Go-to iftar recipe',
    },
    {
      'image': 'assets/images/home_decor.jpg',
      'query': 'home decor',
      'title': 'Home sweet home',
      'desc': 'Design your home your way',
    },
    {
      'image': 'assets/images/scents.jpg',
      'query': 'scents',
      'title': 'Layering up',
      'desc': 'Scent stacking is the trend to try',
    },
  ];

  final List<Map<String, String>> _ideasConfig = [
    {
      'type': 'photography',
      'query': 'photography',
      'title': 'Easy photography ideas',
    },
    {'type': 'art_sketch', 'query': 'art sketches', 'title': 'Art sketches'},
    {
      'type': 'men_outfit',
      'query': 'men outfit',
      'title': 'Men fashion casual outfits',
    },
    {'type': 'anime', 'query': 'anime', 'title': 'Anime Wallpapers'},
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _buildCarousel(h, w),
                  const SizedBox(height: 10),
                  _buildCarouselIndicators(context),
                  ..._ideasConfig.map((config) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          context.push('/search_result/${config['query']}');
                        },
                        child: _buildIdeas(
                          height: h * 0.2,
                          title: config['title']!,
                          type: config['type']!,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => context.push('/search_input'),
                child: AbsorbPointer(
                  child: CustomTextField(
                    hintText: 'Search for ideas',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Transform.scale(
                        scale: 0.8,
                        child: Image.asset(
                          'assets/icons/search_off.png',
                          height: 24,
                          width: 24,
                          color: AppColors.lightBackground,
                        ),
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: AppColors.lightBackground,
                    ),
                    fillColor: AppColors.darkBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.darkTextTertiary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.darkTextTertiary),
                    ),
                    enabled: true,
                    readOnly: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(double h, double w) {
    return CarouselSlider(
      options: CarouselOptions(
        height: h * 0.4,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselIndex = index;
          });
        },
      ),
      items: _carouselItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => context.push('/search_result/${item['query']}'),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item['image']!, fit: BoxFit.cover),
                  Positioned(
                    bottom: 10,
                    left: 16,
                    child: SizedBox(
                      height: 100,
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightBackground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              item['desc']!,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 28,
                                color: AppColors.lightBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCarouselIndicators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _carouselItems.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                .withOpacity(_currentCarouselIndex == entry.key ? 0.9 : 0.4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIdeas({
    required double height,
    required String title,
    required String type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ideas for you',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightBackground,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightBackground,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkTextTertiary.withOpacity(0.55),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/search_off.png',
                    height: 18,
                    width: 18,
                    color: AppColors.lightBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,
          child: Card(
            color: AppColors.darkBackground,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Image.asset(
                      'assets/images/$type${index + 1}.jpeg',
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
