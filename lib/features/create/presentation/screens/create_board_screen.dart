import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/saved/presentation/providers/saved_provider.dart';
import 'package:pinterest_clone/core/common/custom_button.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/common/custom_text_field.dart';
import 'package:pinterest_clone/features/saved/presentation/widgets/board_card.dart';

class CreateBoardScreen extends ConsumerStatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  ConsumerState<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends ConsumerState<CreateBoardScreen> {
  final TextEditingController _boardNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSecret = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _boardNameController.addListener(() {
      setState(() {
        _hasText = _boardNameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _boardNameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(boardsProvider.notifier).createBoard(_boardNameController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        actionsPadding: EdgeInsets.only(right: 12),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.lightBackground,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create board',
          style: TextStyle(
            color: AppColors.lightBackground,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          CustomButton.solid(
            context: context,
            text: 'Create',
            onPressed: _hasText ? _handleCreate : null,
            radius: 14,
            textColor: _hasText
                ? AppColors.lightBackground
                : AppColors.lightTextDisabled,
            backgroundColor: _hasText
                ? AppColors.pinterestRed
                : AppColors.darkCard,
            fontWeight: FontWeight.w500,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                BoardCard(),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _boardNameController,
                  hintText: 'Name your board',
                  textInputAction: TextInputAction.next,
                  contentPadding: EdgeInsets.all(10),
                  borderRadius: 14,
                  labelText: 'Board Name',
                  labelStyle: TextStyle(color: AppColors.darkTextSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.darkTextSecondary),
                  ),
                  suffixIcon: _hasText
                      ? IconButton(
                          icon: const Icon(Icons.highlight_off, size: 20),
                          onPressed: () {
                            _boardNameController.clear();
                          },
                        )
                      : null,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'[a-zA-Z0-9]').hasMatch(value)) {
                      return "Please enter a vallid board name with at least one letter or number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildToggleTile(
                  title: "Make this board secret",
                  subtitle: "Only you and collaborator will see this board",
                  value: _isSecret,
                  onChanged: (val) => setState(() => _isSecret = val),
                  isToggle: true,
                ),

                const SizedBox(height: 20),

                // Group Board Tile
                _buildToggleTile(
                  title: "Group board",
                  subtitle: "Invite collaborators to join this board",
                  value: false,
                  onChanged: (_) {}, // Navigate to add collaborators?
                  isToggle: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isToggle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (isToggle)
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.lightBackground,
              activeTrackColor: const Color.fromARGB(255, 163, 132, 248),
              inactiveTrackColor: AppColors.darkBackground,
            ),
          )
        else
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.darkBorder,
            child: const Icon(Icons.person_add, color: Colors.white, size: 18),
          ),
        if (!isToggle) SizedBox(width: 10),
      ],
    );
  }
}
