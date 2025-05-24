import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Simulação do SharedPreferences para armazenamento local
class LocalStorage {
  static Map<String, String> _storage = {};
  
  static Future<void> setString(String key, String value) async {
    await Future.delayed(Duration(milliseconds: 10)); // Simula delay
    _storage[key] = value;
  }
  
  static Future<String?> getString(String key) async {
    await Future.delayed(Duration(milliseconds: 10)); // Simula delay
    return _storage[key];
  }
  
  static Future<void> remove(String key) async {
    await Future.delayed(Duration(milliseconds: 10)); // Simula delay
    _storage.remove(key);
  }
}

// Modelo do Produto
class Product {
  String id;
  String name;
  double purchasePrice;
  double salePrice;
  int quantity;
  String category;
  String description;
  String imageUrl;
  bool isActive;
  bool isOnPromotion;
  double discount;

  Product({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.quantity,
    required this.category,
    required this.description,
    this.imageUrl = '',
    this.isActive = true,
    this.isOnPromotion = false,
    this.discount = 0.0,
  });

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'quantity': quantity,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'isOnPromotion': isOnPromotion,
      'discount': discount,
    };
  }

  // Criar objeto a partir do JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      purchasePrice: json['purchasePrice'].toDouble(),
      salePrice: json['salePrice'].toDouble(),
      quantity: json['quantity'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      isOnPromotion: json['isOnPromotion'] ?? false,
      discount: json['discount']?.toDouble() ?? 0.0,
    );
  }
}

// Serviço de gerenciamento de produtos
class ProductService {
  static const String _key = 'products';

  // Salvar produtos
  static Future<void> saveProducts(List<Product> products) async {
    List<Map<String, dynamic>> productsJson = 
        products.map((product) => product.toJson()).toList();
    String jsonString = jsonEncode(productsJson);
    await LocalStorage.setString(_key, jsonString);
  }

  // Carregar produtos
  static Future<List<Product>> loadProducts() async {
    String? jsonString = await LocalStorage.getString(_key);
    if (jsonString == null) {
      return [];
    }
    
    List<dynamic> productsJson = jsonDecode(jsonString);
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  // Adicionar novo produto
  static Future<void> addProduct(Product product) async {
    List<Product> products = await loadProducts();
    products.add(product);
    await saveProducts(products);
  }

  // Remover produto
  static Future<void> removeProduct(String productId) async {
    List<Product> products = await loadProducts();
    products.removeWhere((product) => product.id == productId);
    await saveProducts(products);
  }
}

// Página Principal
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade300, Colors.purple.shade600],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Sistema de Produtos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductRegistrationPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.add_circle, size: 24),
                        label: Text(
                          'Cadastrar Produto',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.list_alt, size: 24),
                        label: Text(
                          'Lista de Produtos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de Cadastro de Produto
class ProductRegistrationPage extends StatefulWidget {
  @override
  _ProductRegistrationPageState createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String _selectedCategory = 'Eletrônicos';
  bool _isActive = true;
  bool _isOnPromotion = false;
  double _discount = 0.0;
  bool _isLoading = false;

  final List<String> _categories = [
    'Eletrônicos',
    'Roupas',
    'Casa',
    'Esportes',
    'Livros',
    'Outros'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        backgroundColor: Colors.purple.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informações do Produto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Nome do Produto
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nome do Produto',
                              prefixIcon: Icon(Icons.shopping_bag),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o nome do produto';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Preço de Compra
                          TextFormField(
                            controller: _purchasePriceController,
                            decoration: InputDecoration(
                              labelText: 'Preço de compra',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o preço de compra';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Por favor, insira um valor válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Preço de Venda
                          TextFormField(
                            controller: _salePriceController,
                            decoration: InputDecoration(
                              labelText: 'Preço de venda',
                              prefixIcon: Icon(Icons.sell),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o preço de venda';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Por favor, insira um valor válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Quantidade em Estoque
                          TextFormField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                              labelText: 'Quantidade em Estoque',
                              prefixIcon: Icon(Icons.inventory),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira a quantidade';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Por favor, insira um número válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Descrição
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Descrição',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 16),

                          // Categoria
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Categoria',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 16),

                          // URL da Imagem
                          TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              labelText: 'URL da Imagem',
                              prefixIcon: Icon(Icons.image),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Switches
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text('Produto Ativo'),
                                    Switch(
                                      value: _isActive,
                                      onChanged: (value) {
                                        setState(() {
                                          _isActive = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text('Produto em Promoção'),
                                    Switch(
                                      value: _isOnPromotion,
                                      onChanged: (value) {
                                        setState(() {
                                          _isOnPromotion = value;
                                        });
                                      },
                                      activeColor: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Desconto
                          Text('Desconto (%): ${_discount.toInt()}%'),
                          Slider(
                            value: _discount,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: '${_discount.toInt()}%',
                            onChanged: (value) {
                              setState(() {
                                _discount = value;
                              });
                            },
                            activeColor: Colors.purple,
                          ),
                          SizedBox(height: 24),

                          // Botão Cadastrar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () {
                                if (_formKey.currentState!.validate()) {
                                  _registerProduct();
                                }
                              },
                              child: Text(
                                'Cadastrar Produto',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _registerProduct() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Criar um novo produto
      Product newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        purchasePrice: double.parse(_purchasePriceController.text),
        salePrice: double.parse(_salePriceController.text),
        quantity: int.parse(_quantityController.text),
        category: _selectedCategory,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        isActive: _isActive,
        isOnPromotion: _isOnPromotion,
        discount: _discount,
      );

      // Salvar o produto localmente
      await ProductService.addProduct(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Produto cadastrado com sucesso!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Limpar os campos após cadastro
      _clearForm();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Erro ao cadastrar produto: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _purchasePriceController.clear();
    _salePriceController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    setState(() {
      _isActive = true;
      _isOnPromotion = false;
      _discount = 0.0;
      _selectedCategory = 'Eletrônicos';
    });
  }
}

// Página de Lista de Produtos
class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> loadedProducts = await ProductService.loadProducts();
      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar produtos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await ProductService.removeProduct(productId);
      await _loadProducts(); // Recarregar a lista
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text('Produto removido com sucesso!'),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover produto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        backgroundColor: Colors.purple.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum produto cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione seu primeiro produto!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Nome: ${product.name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade700,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteDialog(product),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Preço de compra: R\$ ${product.purchasePrice.toStringAsFixed(2)}'),
                          Text('Preço de venda: R\$ ${product.salePrice.toStringAsFixed(2)}'),
                          Text('Quantidade: ${product.quantity}'),
                          Text('Categoria: ${product.category}'),
                          if (product.description.isNotEmpty)
                            Text('Descrição: ${product.description}'),
                          SizedBox(height: 16),
                          
                          // Container da imagem (placeholder)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: product.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Colors.grey.shade600,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey.shade600,
                                ),
                          ),
                          SizedBox(height: 16),

                          // Status do produto
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: product.isActive ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      product.isActive ? Icons.check_circle : Icons.cancel,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      product.isActive ? 'Produto Ativo: Sim' : 'Produto Ativo: Não',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: product.isOnPromotion ? Colors.orange : Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      product.isOnPromotion ? Icons.local_fire_department : Icons.block,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      product.isOnPromotion ? 'Em Promoção: Sim' : 'Em Promoção: Não',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.percent,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Desconto: ${product.discount.toInt()}%',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir o produto "${product.name}"?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(product.id);
              },
            ),
          ],
        );
      },
    );
  }
}
