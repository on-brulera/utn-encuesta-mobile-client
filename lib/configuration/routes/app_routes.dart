import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final appRoutes = GoRouter(
  initialLocation: '/${LoginScreen.screenName}',
  routes: [    
    GoRoute(
      path: '/${LoginScreen.screenName}',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${HomeDocenteScreen.screenName}',
      builder: (context, state) => const HomeDocenteScreen(),
    ),
  ],
);
