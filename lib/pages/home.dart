import 'package:feedback_fusion/utils/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPositiveSelected = false;
  bool _isNegativeSelected = false;
  TextEditingController _commentController = TextEditingController();

  void _selectPositive() {
    setState(() {
      _isPositiveSelected = true;
      _isNegativeSelected = false;
    });
  }

  void _selectNegative() {
    setState(() {
      _isPositiveSelected = false;
      _isNegativeSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    appBar(
      height,
    ) =>
        PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, height + 80),
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                height: height + 75,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    GlobalConfiguration().getValue<String>('appName'),
                    style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.27,
                left: 20.0,
                right: 20.0,
                child: const Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Form(
                      child: Card(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );

    return Scaffold(
        appBar: appBar(MediaQuery.of(context).size.height * 0.2),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "We'd love to hear from you",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Are you happy with the service you recently got from ${GlobalConfiguration().getValue<String>('appName')}",
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _selectPositive,
                      child: Icon(
                        Icons.thumb_up,
                        color: _isPositiveSelected ? Colors.green : Colors.grey,
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _selectNegative,
                      child: Icon(
                        Icons.thumb_down,
                        color: _isNegativeSelected ? Colors.red : Colors.grey,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add a comment',
                  ),
                  enabled: _isPositiveSelected || _isNegativeSelected,
                ),
              ],
            ),
          ),
        ));
  }
}
