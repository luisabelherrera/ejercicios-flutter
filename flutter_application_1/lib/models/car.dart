class Car {
  final String placa;
  final String conductor;
  final String imagen;

  Car({
    required this.placa,
    required this.conductor,
    required this.imagen,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        placa: json['placa'] as String,
        conductor: json['conductor'] as String,
        imagen: json['imagen'] as String,
      );
}