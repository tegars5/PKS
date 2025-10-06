import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  final String trackingNumber;

  TrackingScreen({required this.trackingNumber});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  List<TrackingStep> trackingSteps = [];

  @override
  void initState() {
    super.initState();
    loadTrackingData();
  }

  void loadTrackingData() {
    // Mock tracking data
    trackingSteps = [
      TrackingStep(
        title: 'Pesanan Dikonfirmasi',
        description: 'Pesanan Anda telah dikonfirmasi penjual',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Diproses',
        description: 'Pesanan sedang dipersiapkan',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Dikirim',
        description: 'Paket telah diserahkan ke kurir',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Dalam Perjalanan',
        description: 'Paket sedang dalam perjalanan',
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Tiba di Kota Tujuan',
        description: 'Paket telah tiba di kota tujuan',
        timestamp: null,
        isCompleted: false,
      ),
      TrackingStep(
        title: 'Diterima',
        description: 'Paket telah diterima penerima',
        timestamp: null,
        isCompleted: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lacak Paket'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Number
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nomor Resi'),
                          Text(
                            widget.trackingNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        // Copy to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nomor resi disalin')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Tracking Timeline
            Text(
              'Status Pengiriman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...trackingSteps.asMap().entries.map((entry) {
              int index = entry.key;
              TrackingStep step = entry.value;
              bool isLast = index == trackingSteps.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: step.isCompleted ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: step.isCompleted
                            ? Icon(Icons.check, size: 12, color: Colors.white)
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 60,
                          color: step.isCompleted
                              ? Colors.green
                              : Colors.grey[300],
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: step.isCompleted
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          step.description,
                          style: TextStyle(
                            color: step.isCompleted
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                        if (step.timestamp != null)
                          Text(
                            '${step.timestamp!.day}/${step.timestamp!.month}/${step.timestamp!.year} ${step.timestamp!.hour}:${step.timestamp!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class TrackingStep {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    this.timestamp,
    required this.isCompleted,
  });
}
