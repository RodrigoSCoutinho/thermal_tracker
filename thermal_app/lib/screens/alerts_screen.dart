import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  // Main build method for Alerts screen
  @override
  Widget build(BuildContext context) {
    try {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Alertas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _AlertRow('Temperatura acima de 30°C', 'Hoje, 14:32'),
                    Divider(),
                    _AlertRow('Sensor desconectado', 'Ontem, 18:10'),
                    Divider(),
                    _AlertRow('Temperatura abaixo de 15°C', 'Ontem, 07:45'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint('Error in AlertsScreen: $e\n$stack');
      return Center(child: Text('Error loading Alerts screen'));
    }
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String message;
  final String time;
  const _AlertRow(this.message, this.time);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(message),
            ],
          ),
          Text(time,
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}
