import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart'; // Import package csv

class HistoryScreen extends StatelessWidget {
  final List<String> historyList;

  const HistoryScreen({super.key, required this.historyList});

  Future<void> _downloadCSV(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CSV export is not supported on web.'),
        ),
      );
      return;
    }
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await _generateAndSaveCSV(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. Cannot save CSV.'),
        ),
      );
    }
  }

  Future<void> _generateAndSaveCSV(BuildContext context) async {
    // Convert historyList to List<List<String>> for CSV content
    final csvContent = historyList.map((item) => item.split('=')).toList();

    // Get the directory for storing CSV file
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Unable to access storage directory.'),
        ),
      );
      return;
    }
    final filePath = '${directory.path}/history.csv';

    // Create and write CSV file
    final csvFile = File(filePath);
    String csvString = const ListToCsvConverter().convert(csvContent);
    await csvFile.writeAsString(csvString);

    // Show a snackbar to inform user about successful saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV saved to $filePath'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            onPressed: () async {
              await _downloadCSV(context);
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final historyItem = historyList[index];
          final parts = historyItem.split('=');
          final expression = parts[0].trim();
          final result = parts[1].trim();
          return Dismissible(
            key: Key('$expression$result'),
            onDismissed: (direction) {
              historyList.removeAt(index);
            },
            background: Container(
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expression,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(result),
                ],
              ),
              onTap: () {
                Navigator.pop(context, expression);
              },
            ),
          );
        },
      ),
    );
  }
}
