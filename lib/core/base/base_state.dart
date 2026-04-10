import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auth_flow_app/core/base/base_navigator.dart';
import 'package:auth_flow_app/core/base/base_viewmodel.dart';
import 'package:auth_flow_app/core/di/service_locator.dart';
import 'package:auth_flow_app/core/widgets/connectivity_wrapper.dart';
import 'package:auth_flow_app/core/utils/app_snackbars.dart';

abstract class BaseState<
    W extends StatefulWidget,
    VM extends BaseViewModel<N, R>,
    N extends BaseNavigator,
    R> extends State<W> implements BaseNavigator {

  late VM viewModel;

  @override
  void initState() {
    super.initState();
    // Get the ViewModel directly from GetIt — no Provider ancestor required.
    viewModel = locator<VM>();
    viewModel.setNavigator(this as N);
  }

  /// Override this method to build the actual screen's UI.
  Widget buildScreen(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // BaseState self-provides the ViewModel to its own subtree.
    // This means no ChangeNotifierProvider wrapping is needed at callsites
    // and no MultiProvider in main.dart is needed either.
    return ChangeNotifierProvider<VM>.value(
      value: viewModel,
      child: ConnectivityWrapper(
        child: buildScreen(context),
      ),
    );
  }

  // --- BaseNavigator Implementations --- //

  @override
  void showSuccessSnackbar(String message) {
    AppSnackbars.showSuccess(context, message);
  }

  @override
  void showErrorSnackbar(String message) {
    AppSnackbars.showError(context, message);
  }

  @override
  void pop() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
