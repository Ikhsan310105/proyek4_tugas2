import 'package:flutter/material.dart';
import 'package:tugas2/pages/home/home_page_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1
  final manager = HomePageManager();

  // 2
  @override
  void initState() {
    super.initState();
    manager.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 214, 214),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "WeatherApp",
          style: TextStyle(
              fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        // 3
        child: ValueListenableBuilder<LoadingStatus>(
          valueListenable: manager.loadingNotifier,
          builder: (context, loadingStatus, child) {
            switch (loadingStatus) {
              case Loading():
                return const CircularProgressIndicator();
              case LoadingError():
                // 4
                return ErrorWidget(
                  errorMessage: loadingStatus.message,
                  onRetry: manager.loadWeather,
                );
              case LoadingSuccess():
                // 5
                return WeatherWidget(
                  manager: manager,
                  weather: loadingStatus.weather,
                );
            }
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        TextButton(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.manager,
    required this.weather,
  });
  final HomePageManager manager;
  final String weather;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // 6
            child: TextButton(
              onPressed: manager.convertTemperature,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: manager.buttonNotifier,
                builder: (context, buttonText, child) {
                  return Text(
                    buttonText,
                    style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white, // Text color
                        ) ??
                        const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 7
              ValueListenableBuilder<String>(
                valueListenable: manager.temperatureNotifier,
                builder: (context, temperature, child) {
                  return Text(
                    temperature,
                    style: const TextStyle(fontSize: 56),
                  );
                },
              ),
              Text(
                weather,
                style: textTheme.headlineMedium,
              ),
              Text(
                'Bandung, Indonesia',
                style: textTheme.headlineSmall,
              ),
              Text(
                'Muhammad Ikhsan',
                style: textTheme.headlineSmall,
              ),
              Text(
                '221511058',
                style: textTheme.headlineSmall,
              ),
              Text(
                'D3-2B',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
