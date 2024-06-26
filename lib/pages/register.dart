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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _fistNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide'); //hides keyboard
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fistNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(builder: (BuildContext context, UserViewModel userViewModel, _) {
        return ConditionalSwitch.single<LoadingStatus>(
          context: context,
          valueBuilder: (BuildContext context) => userViewModel.status,
          caseBuilders: {
            LoadingStatus.busy: (BuildContext context) => const LoadingWidget(),
            LoadingStatus.failed: (BuildContext context) => _signUpInterface(userViewModel: userViewModel),
            LoadingStatus.idle: (BuildContext context) => _signUpInterface(userViewModel: userViewModel),
            LoadingStatus.completed: (BuildContext context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GoRouter.of(context).replaceNamed(AppRoutes.home);
              });
              return const SizedBox();
            },
          },
          fallbackBuilder: (BuildContext context) => const SizedBox(),
        );
      }),
    );
  }

  Widget _signUpInterface({required UserViewModel userViewModel}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30.0,
            ),
            _registerHeading(),
            const SizedBox(
              height: 10.0,
            ),
            _registerSubHeading(),
            Container(
                margin: const EdgeInsets.only(top: 15.0, left: 40.0, right: 40.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    _signUpForm(userViewModel),
                    if (userViewModel.errorMessage != null) ...[
                      Text(
                        userViewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    CheckboxListTile(
                      value: userViewModel.rememberMe,
                      title: const Text('Remember Me'),
                      onChanged: (newValue) {
                        userViewModel.saveRememberMeValue(newValue ?? false);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                  ],
                )),
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
                      userViewModel.handleRegistration({
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'firstName': _fistNameController.text,
                        'lastName': _lastNameController.text,
                      });
                      if (!userViewModel.isSignedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(userViewModel.errorMessage ?? 'Registration failed')),
                        );
                      }
                    }
                  },
                  child: const Text('Register', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextButton(
                  child: _alreadyHaveAnAccountText(),
                  onPressed: () {
                    GoRouter.of(context).replaceNamed(
                      AppRoutes.login,
                    );
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _registerHeading() {
    return const Text(
      'Register',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.blue,
        fontSize: 55.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _registerSubHeading() {
    return const Text(
      'Sign up to your Feedback Fusion account',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 17.0,
      ),
    );
  }

  Widget _signUpForm(UserViewModel registerViewModel) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormBuilderTextField(
            controller: _fistNameController,
            name: 'firstName',
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(numberPattern.toString()),
              ),
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          FormBuilderTextField(
            controller: _lastNameController,
            name: 'lastName',
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(numberPattern.toString()),
              ),
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          FormBuilderTextField(
            controller: _emailController,
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
                //checks if charcaters / , \ and spaces are present, then they get denied
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
            // onChanged: (value) {
            //   _credentials[LoginFormField.password] = value;
            // },
            // onSaved: (value) {
            //   _credentials[LoginFormField.password] = value;
            // },
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

  Widget _alreadyHaveAnAccountText() {
    return RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Already have an account?',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          TextSpan(
            text: '  Login',
            style: TextStyle(color: AppColors.blue, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
