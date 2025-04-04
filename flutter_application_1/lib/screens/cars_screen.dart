import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../service/login_service.dart';
import '../models/car.dart';

class CarsScreen extends StatefulWidget {
  final String token;

  const CarsScreen({super.key, required this.token});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  late Future<List<Car>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = _loadCars();
  }

  Future<List<Car>> _loadCars() async {
    try {
      final cars = await LoginService.getCars(widget.token);
      print('Cars loaded successfully: ${cars.length}');
      for (var car in cars) {
        print('Car: ${car.placa}, Conductor: ${car.conductor}, Image: ${car.imagen}');
      }
      return cars;
    } catch (e) {
      print('Error loading cars: $e');
      throw Exception('Failed to load cars: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Electric Cars')),
      body: FutureBuilder<List<Car>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars available'));
          }
          return _buildCarList(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildCarList(List<Car> cars) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) => _buildCarItem(cars[index]),
    );
  }

  Widget _buildCarItem(Car car) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9, // Proporción típica para imágenes JPG horizontales
            child: CachedNetworkImage(
              imageUrl: car.imagen,
              width: double.infinity,
              fit: BoxFit.contain, // Mostrar la imagen completa
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) {
                print('Image load error: $url, $error');
                return const Center(
                  child: Icon(Icons.error, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.placa,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  car.conductor,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}