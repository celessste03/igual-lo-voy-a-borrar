import 'dart:async';
import 'package:flutter/material.dart';
import 'contact_details_sheet.dart';

class CallScreen extends StatefulWidget {
  final Map<String, dynamic> contact;

  const CallScreen({super.key, required this.contact});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late int _counter;
  late Timer _timer;
  bool _isCallActive = true;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    _counter = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCallActive) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _hangUp() {
    setState(() {
      _isCallActive = false;
    });
    _timer.cancel();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final contactName = widget.contact['nombre'] ?? 'Sin nombre';
    final phoneNumber = widget.contact['telefono'] ?? 'Sin teléfono';
    final alias = widget.contact['alias'];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2E40),
              Color(0xFF0D1C2B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                _isCallActive ? 'Llamando...' : 'Llamada finalizada',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 70,
                backgroundColor: ContactDetailsSheet.getAvatarColor(contactName),
                child: Text(
                  contactName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                contactName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (alias != null) ...[
                const SizedBox(height: 4),
                Text(
                  alias,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                phoneNumber,
                style: TextStyle(
                  color: phoneNumber == 'Sin teléfono' 
                      ? Colors.white54 
                      : Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _formatTime(_counter),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCallButton(
                      icon: Icons.mic,
                      activeIcon: Icons.mic_off,
                      isActive: _isMuted,
                      onPressed: _toggleMute,
                      label: 'Silenciar',
                    ),
                    _buildCallButton(
                      icon: Icons.volume_up,
                      activeIcon: Icons.volume_off,
                      isActive: _isSpeakerOn,
                      onPressed: _toggleSpeaker,
                      label: 'Altavoz',
                    ),
                    _buildCallButton(
                      icon: Icons.videocam,
                      activeIcon: Icons.videocam_off,
                      isActive: false,
                      onPressed: () {},
                      label: 'Video',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _hangUp,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required IconData activeIcon,
    required bool isActive,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.blue : Colors.white,
              size: 28,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}