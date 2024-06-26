import 'package:feedback_fusion/components/loading_widget.dart';
import 'package:feedback_fusion/router/router.dart';
import 'package:feedback_fusion/utils/enums.dart';
import 'package:feedback_fusion/utils/values/colors.dart';
import 'package:feedback_fusion/utils/values/constants.dart';
import 'package:feedback_fusion/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _forgotPasswordFormKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(builder: (BuildContext context, UserViewModel loginViewModel, _) {
        return ConditionalSwitch.single<LoadingStatus>(
          context: context,
          valueBuilder: (BuildContext context) => loginViewModel.status,
          caseBuilders: {
            LoadingStatus.busy: (BuildContext context) => const LoadingWidget(),
            LoadingStatus.failed: (BuildContext context) => loginInterface(userViewModel: loginViewModel),
            LoadingStatus.idle: (BuildContext context) => loginInterface(userViewModel: loginViewModel),
            LoadingStatus.completed: (BuildContext context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GoRouter.of(context).replaceNamed(AppRoutes.splash);
              });
              return const SizedBox();
            },
          },
          fallbackBuilder: (BuildContext context) => const SizedBox(),
        );
      }),
    );
  }

  Widget loginInterface({required UserViewModel userViewModel}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30.0,
            ),
            _loginHeading(),
            const SizedBox(
              height: 15.0,
            ),
            _loginSubHeading(),
            Container(
              margin: const EdgeInsets.only(top: 60.0, left: 40.0, right: 40.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  _loginForm(userViewModel),
                  if (userViewModel.errorMessage != null) ...[
                    Text(
                      userViewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  TextButton(
                    child: const Text(' Forgot password?', style: TextStyle(color: AppColors.blue, fontSize: 14)),
                    onPressed: () {
                      showForgotPasswordPopUp(userViewModel);
                    },
                  ),
                  CheckboxListTile(
                    value: userViewModel.rememberMe,
                    title: const Text('Remember Me'),
                    onChanged: (newValue) {
                      userViewModel.saveRememberMeValue(newValue ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                MaterialButton(
                  textColor: AppColors.white,
                  color: AppColors.blue,
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      userViewModel.handleLogin(email: email, password: password);
                      if (!userViewModel.isSignedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(userViewModel.errorMessage ?? 'Login failed')),
                        );
                      }
                    }
                  },
                  child: const Text('Login', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: _dontHaveAnAccountText(),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _loginHeading() {
    return const Text(
      'Login',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.blue,
        fontSize: 55.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _loginSubHeading() {
    return const Text(
      'Log in to your Feedback Fusion account',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 17.0,
      ),
    );
  }

  Widget _loginForm(UserViewModel userViewModel) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormBuilderTextField(
            controller: _emailController,
            key: _emailFieldKey,
            name: 'email',
            decoration: const InputDecoration(labelText: 'Email'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('${r'[/\\' + noSpacePattern.toString()} ]'),
              ),
              LengthLimitingTextInputFormatter(40),
            ],
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'password',
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ]),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(r'\s'),
              ),
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> showForgotPasswordPopUp(UserViewModel userViewModel) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Forgot Password",
            style: TextStyle(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text(
                  'Send OTP Code to email:',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _forgotPasswordFormKey,
                  child: FormBuilderTextField(
                    key: _emailFieldKey,
                    name: 'email',
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        //checks if charcaters / , \ and spaces are present, then they get denied
                        RegExp('${r'[/\\' + noSpacePattern.toString()} ]'),
                      ),
                      LengthLimitingTextInputFormatter(40),
                    ],
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: _emailController.text,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Widget _dontHaveAnAccountText() {
    return RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Don\'t have an account?',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          TextSpan(
            text: '  Register',
            style: TextStyle(color: AppColors.blue, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
