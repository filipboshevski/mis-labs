import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lab4/models/exam.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/exam_provider.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  AddExamScreenState createState() => AddExamScreenState();
}

class AddExamScreenState extends State<AddExamScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController locationController;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    locationController = TextEditingController();
    selectedLocation = const LatLng(42.0041004, 21.4097594);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new exam'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            ListTile(
              title: Text('Date: ${selectedDate.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate:  DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),
            SizedBox(
              height: 400,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: selectedLocation!,
                  initialZoom: 15.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      selectedLocation = point;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (selectedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: selectedLocation!,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && selectedLocation != null) {
                  final exam = Exam(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    date: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    coordinates: selectedLocation!,
                    location: locationController.text,
                  );

                  context.read<ExamProvider>().addExam(exam);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

}