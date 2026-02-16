import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/common/custom_text_field.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({super.key});

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Auto focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.push('/search_result/${query.trim()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.darkTextTertiary,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      hintText: 'Search for ideas',
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSearch,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/icons/search_off.png',
                          height: 24,
                          width: 24,
                          color: AppColors.lightBackground,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.camera_alt,
                        color: AppColors.lightBackground,
                      ),
                      fillColor: AppColors.darkBackground,
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: const BorderSide(
                          color: AppColors.darkTextPrimary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.lightBackground,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
