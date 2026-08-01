import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
  final _api = ApiService();
  final _textController = TextEditingController();
  String? _toxicityResult;
  String? _imageResult;
  bool _loading = false;

  Future<void> _checkToxicity() async {
    setState(() { _loading = true; _toxicityResult = null; });
    try {
      final result = await _api.analyzeToxicity(_textController.text.trim());
      setState(() {
        _toxicityResult = 'Toxicity: ${result['toxicity_percentage'] ?? result['toxicity']}%';
      });
    } catch (error) {
      setState(() { _toxicityResult = error.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() { _loading = true; _imageResult = null; });
    try {
      final result = await _api.analyzeImage(File(file.path));
      setState(() {
        _imageResult = 'Image label: ${result['label']} (${result['unsafe_probability']}%)';
      });
    } catch (error) {
      setState(() { _imageResult = error.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: [
          const Text('AI Analysis', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Use AI to analyze text toxicity and unsafe images.'),
          const SizedBox(height: 24),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Enter a suspicious message'),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loading ? null : _checkToxicity, child: const Text('Analyze Text')),
          const SizedBox(height: 12),
          if (_toxicityResult != null) Text(_toxicityResult!, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loading ? null : _pickImage, child: const Text('Analyze Image')),
          const SizedBox(height: 12),
          if (_imageResult != null) Text(_imageResult!, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
