import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute <T>{
  CustomRoute({
   WidgetBuilder? builder,
    RouteSettings? routeSettings,
}):super(builder: builder!, settings: routeSettings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if(settings.name == '/'){
        return child;//The page navigating to
    }
    return FadeTransition( //Custom route with fade in transition
      opacity: animation,
      child: child,);
  }
}


///General Theme that can affect all routes
class CustomPageTransitionBuilder extends PageTransitionsBuilder{

  @override
  Widget buildTransitions<T>(
      PageRoute<T> customRoute,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if(customRoute.settings.name == '/'){
      return child;//The page navigating to
    }
    return FadeTransition( //Custom route with fade in transition
      opacity: animation,
      child: child,);
  }
}