import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auth_flow_app/core/base/base_navigator.dart';
import 'package:auth_flow_app/core/base/base_viewmodel.dart';
import 'package:auth_flow_app/core/widgets/connectivity_wrapper.dart';
import 'package:auth_flow_app/core/utils/app_snackbars.dart';

abstract class BaseState<
    W extends StatefulWidget,
    VM extends BaseViewModel<N, R>,
    N extends BaseNavigator,
    R> extends State<W> implements BaseNavigator {
  
  late VM viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = context.read<VM>();
    viewModel.setNavigator(this as N);
  }

  /// Override this method to build the actual screen's UI.
  Widget buildScreen(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // The ConnectivityWrapper is applied at the root of every screen
    // inheriting from BaseState.
    return ConnectivityWrapper(
      child: buildScreen(context),
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
