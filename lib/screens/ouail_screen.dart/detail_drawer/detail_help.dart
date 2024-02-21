import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _messageController = TextEditingController();

  List<Map<String, dynamic>> messages = [
    {'sender': 'admin', 'text': 'Bonjour, comment puis-je vous aider ?'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // st appelée lorsque l'utilisateur appuie sur le bouton "Envoyer". Elle récupère le texte
    String message = _messageController.text;
    messages.add({'sender': 'user', 'text': message});
    _messageController.clear();
    // Envoyer le message à l'application ou effectuer d'autres actions nécessaires
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // afficher les messages de manière séquentielle
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> message = messages[index];
                return Container(
                  alignment: message['sender'] == 'admin'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: message['sender'] == 'admin'
                        ? Colors.blue[200]
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: message['sender'] == 'admin'
                              ? Colors.black
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Envoyer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
