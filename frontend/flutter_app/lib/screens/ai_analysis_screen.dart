import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/glass_card.dart';

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
  final Set<String> _shownAlerts = {};

  Future<void> _checkToxicity() async {
    if (_textController.text.trim().isEmpty) {
      setState(() => _toxicityResult = 'Enter text to analyze.');
      return;
    }
    setState(() { _loading = true; _toxicityResult = null; });
    try {
      final result = await _api.analyzeToxicity(_textController.text.trim());
      if (!mounted) return;
      final classification = result['classification'] ?? 'unknown';
      final score = result['toxicity_percentage'] ?? 0;
      setState(() {
        _toxicityResult = '${classification.toString().toUpperCase()} • $score%\n${result['alert_message'] ?? 'Analysis complete.'}';
      });
      final alertKey = '${_textController.text.trim().toLowerCase()}::$classification';
      if (result['should_alert'] == true && _shownAlerts.add(alertKey)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: classification == 'spam' ? Colors.orange.shade800 : Colors.red.shade800,
            content: Text('Safety alert: ${result['alert_message']}'),
          ),
        );
      }
    } catch (error) {
      if (mounted) setState(() { _toxicityResult = error.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() { _loading = true; _imageResult = null; });
    try {
      final result = await _api.analyzeImage(file);
      if (!mounted) return;
      setState(() {
        _imageResult = 'Image label: ${result['label']} (${result['unsafe_probability']}%)';
      });
    } catch (error) {
      if (mounted) setState(() { _imageResult = error.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Analysis', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Inspect messages and images with enterprise-grade AI models using real-time results.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 22),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Text Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    hintText: 'Enter suspicious message',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _loading ? null : _checkToxicity,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Analyze Text'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    ),
                    const SizedBox(width: 14),
                    if (_loading) const CircularProgressIndicator(),
                  ],
                ),
                if (_toxicityResult != null) ...[
                  const SizedBox(height: 16),
                  Text(_toxicityResult!, style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Image Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                const Text('Upload a photo to inspect for unsafe content and threat markers.', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _pickImage,
                  icon: const Icon(Icons.image_search),
                  label: const Text('Scan Image'),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
                if (_imageResult != null) ...[
                  const SizedBox(height: 16),
                  Text(_imageResult!, style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 14),
                _InsightRow(label: 'Model', value: 'BERT / CNN / GRU'),
                _InsightRow(label: 'Average Confidence', value: '89%'),
                _InsightRow(label: 'Detection Latency', value: '1.4s'),
                _InsightRow(label: 'Active Scans', value: '4 simultaneous jobs'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String label;
  final String value;

  const _InsightRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
