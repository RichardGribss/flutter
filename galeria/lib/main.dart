import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeria de Fotos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PhotoGalleryScreen(),
    );
  }
}

class PhotoItem {
  final Color color;
  final String size;
  bool isFavorite;

  PhotoItem({
    required this.color,
    required this.size,
    this.isFavorite = false,
  });
}

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final List<PhotoItem> photos = [
    PhotoItem(color: Colors.blue, size: '650 × 450'),
    PhotoItem(color: Colors.grey, size: '150 × 210'),
    PhotoItem(color: Colors.yellow, size: '150 × 210'),
    PhotoItem(color: Colors.green, size: '150 × 210'),
    PhotoItem(color: Colors.purple, size: '150 × 210'),
    PhotoItem(color: Colors.cyan, size: '150 × 210'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de fotos'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return _buildPhotoItem(photos[index], index);
        },
      ),
    );
  }

  Widget _buildPhotoItem(PhotoItem photo, int index) {
    return Container(
      decoration: BoxDecoration(
        color: photo.color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          // Texto de tamanho centralizado
          Center(
            child: Text(
              photo.size,
              style: TextStyle(
                color: _getContrastColor(photo.color),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Botão de favorito no canto superior direito
          Positioned(
            top: 8.0,
            right: 8.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  photo.isFavorite = !photo.isFavorite;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  photo.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: photo.isFavorite ? Colors.red : Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para garantir que o texto seja legível na cor de fundo
  Color _getContrastColor(Color backgroundColor) {
    // Algoritmo simples para determinar se deve usar texto branco ou preto
    int brightness = ((backgroundColor.red * 299) +
            (backgroundColor.green * 587) +
            (backgroundColor.blue * 114)) ~/
        1000;
    return brightness > 128 ? Colors.black : Colors.white;
  }
}