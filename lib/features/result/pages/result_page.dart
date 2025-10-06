import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_generator/features/result/cubit/result_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_generator/core/app_pages.dart';
import 'package:image_generator/features/result/widgets/result_error_card.dart';
import 'package:image_generator/features/result/widgets/result_loading_card.dart';
import 'package:image_generator/features/result/widgets/result_success_card.dart';

class ResultScreen extends StatefulWidget {
  final String prompt;
  const ResultScreen({required this.prompt, super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ResultCubit>().generate(widget.prompt);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateIn() {
    if (_controller.status != AnimationStatus.forward) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        title: Text(
          "Result",
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      body: Center(
        child: BlocConsumer<ResultCubit, ResultState>(
          listener: (context, state) {
            if (state is ResultSuccess) _animateIn();
          },
          builder: (context, state) {
            if (state is ResultLoading) {
              return const ResultLoadingCard();
            }

            if (state is ResultError) {
              return ResultErrorCard(
                onRetry: () =>
                    context.read<ResultCubit>().generate(widget.prompt),
              );
            }

            if (state is ResultSuccess) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ResultSuccessCard(
                  imageUrl: state.imageUrl,
                  prompt: widget.prompt,
                  onTryAnother: () =>
                      context.read<ResultCubit>().generate(widget.prompt),
                  onNewPrompt: () =>
                      context.go(AppPages.prompt, extra: widget.prompt),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
