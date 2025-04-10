import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactForm extends StatefulWidget {
  final Map<String, dynamic>? contactToEdit;
  final VoidCallback? onContactSaved;

  const ContactForm({Key? key, this.contactToEdit, this.onContactSaved}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _aliasController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.contactToEdit != null) {
      _nameController.text = widget.contactToEdit!['nombre'] ?? '';
      _phoneController.text = widget.contactToEdit!['telefono'] ?? '';
      _emailController.text = widget.contactToEdit!['correo'] ?? '';
      _aliasController.text = widget.contactToEdit!['alias'] ?? '';
      _notesController.text = widget.contactToEdit!['notas'] ?? '';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final contactData = {
        'nombre': _nameController.text,
        'telefono': _phoneController.text,
        'correo': _emailController.text.isNotEmpty ? _emailController.text : null,
        'alias': _aliasController.text.isNotEmpty ? _aliasController.text : null,
        'notas': _notesController.text.isNotEmpty ? _notesController.text : null,
      };

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuario no autenticado');

      if (widget.contactToEdit == null) {
        // Crear nuevo contacto
        await Supabase.instance.client
            .from('contactos')
            .insert({...contactData, 'user_id': userId});
      } else {
        // Actualizar contacto existente
        await Supabase.instance.client
            .from('contactos')
            .update(contactData)
            .eq('id', widget.contactToEdit!['id']);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.contactToEdit == null
                ? 'Contacto creado'
                : 'Contacto actualizado'),
          ),
        );
        widget.onContactSaved?.call();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
          ),
          TextFormField(
            controller: _aliasController,
            decoration: const InputDecoration(labelText: 'Alias'),
          ),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notas'),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.contactToEdit == null
                      ? 'Agregar Contacto'
                      : 'Actualizar Contacto'),
                ),
        ],
      ),
    );
  }
}
