import 'package:feedback_fusion/services/repositories/auth/auth_repository.dart';
import 'package:feedback_fusion/services/repositories/storage/local_storage_repository.dart';
import 'package:feedback_fusion/utils/service_locator.dart';
import 'package:feedback_fusion/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ...viewModelProviders,
];

List<SingleChildWidget> viewModelProviders = [
  ChangeNotifierProvider(
    create: (context) => UserViewModel(
      authRepository: serviceLocator<AuthRepository>(),
      localStorageRepository: serviceLocator<LocalStorageRepository>(),
    ),
  ),
];
