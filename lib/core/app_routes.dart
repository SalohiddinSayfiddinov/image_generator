import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_generator/core/app_pages.dart';
import 'package:image_generator/data/mockapi.dart';
import 'package:image_generator/features/prompt/pages/prompt_page.dart';
import 'package:image_generator/features/result/cubit/result_cubit.dart';
import 'package:image_generator/features/result/pages/result_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: AppPages.prompt,
    routes: [
      GoRoute(
        path: AppPages.prompt,
        builder: (context, state) => PromptScreen(),
      ),
      GoRoute(
        path: AppPages.result,
        builder: (context, state) {
          final String prompt = state.extra as String;
          return BlocProvider(
            create: (context) => ResultCubit(Mockapi()),
            child: ResultScreen(prompt: prompt),
          );
        },
      ),
    ],
  );
}
