import 'package:flutter/material.dart';

void main() {
  runApp(CartaoVisita());
}

class CartaoVisita extends StatelessWidget {
  CartaoVisita({super.key});

  final controlerNome = TextEditingController(text: 'Richard');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartão de Visita',
      home: CardPage(),
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Cartão de Visita'),
      ),
      body: Center(
        child: Card(
          shadowColor: Colors.teal,
          margin: const EdgeInsets.all(16.0),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //Column - Coluna
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://p2.trrsf.com/image/fget/cf/2000/0/images.terra.com/2024/08/12/776563842-6b53c7c4f561a27acb7234f057eb0893.jpg'),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Richard G.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Analista de sistemas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const Divider(
                  height: 30,
                  thickness: 1,
                ),

                const Text(
                  'Hard Skills',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    SkillChip(
                      label: 'Flutter',
                    ),
                    SkillChip(
                      label: 'Firebase',
                    ),
                    SkillChip(
                      label: 'Dart',
                    ),
                    SkillChip(
                      label: 'SQL',
                    ),
                    SkillChip(
                      label: 'Java',
                    ),
                    SkillChip(
                      label: 'PHP',
                    ),
                    SkillChip(
                      label: 'Rest API',
                    ),
                  ],
                ),

                // Row - Linha
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        enviarEmail();
                      },
                      label: const Text('Enviar Email'),
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ligar();
                      },
                      child: const Text('Ligar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void enviarEmail() {
  print('Deve enviar um e-mail mim.');
}

void ligar() {
  print('Deve ligar para mim.');
}

// Criando um componente
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.teal.shade600,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }
}
