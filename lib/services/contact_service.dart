import 'package:flutter/material.dart';

class ContactDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEmail;

  const ContactDetailsSheet({
    super.key,
    required this.contact,
    required this.onCall,
    required this.onMessage,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: getAvatarColor(contact['nombre']),
              child: Text(
                contact['nombre']?.substring(0, 1).toUpperCase() ?? '?',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              contact['nombre'] ?? 'Sin nombre',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (contact['alias'] != null) ...[
              const SizedBox(height: 4),
              Text(
                contact['alias'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            _buildDetailItem(Icons.phone, contact['telefono'] ?? 'Sin teléfono', onCall),
            if (contact['correo'] != null)
              _buildDetailItem(Icons.email, contact['correo'], onEmail),
            if (contact['notas']?.isNotEmpty ?? false)
              _buildDetailItem(Icons.notes, contact['notas'], null),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.message,
                  'Mensaje',
                  Colors.blue,
                  onMessage,
                ),
                _buildActionButton(
                  Icons.phone,
                  'Llamar',
                  Colors.green,
                  onCall,
                ),
                _buildActionButton(
                  Icons.video_call,
                  'Video',
                  Colors.purple,
                  () {}, 
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: text == 'Sin teléfono' || text == 'Sin nombre' 
                      ? Colors.grey 
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          iconSize: 28,
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  static Color getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }
}