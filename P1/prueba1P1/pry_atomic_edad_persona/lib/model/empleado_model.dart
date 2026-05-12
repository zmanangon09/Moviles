
class EmpleadoModel {
  // Calcula el sueldo semanal según la fórmula:
  // 35000 + edad + 100 * (1 + 2 + ... + antiguedad)
  // Usamos la progresión: suma 1..n = n*(n+1)/2
  static Map<String, int> calcularSueldo(int edad, int antiguedad) {
    final int sumaProgresion = (antiguedad * (antiguedad + 1)) ~/ 2;
    final int adicional = 100 * sumaProgresion;
    final int sueldo = 35000 + edad + adicional;
    return {'sueldo': sueldo, 'adicional': adicional, 'suma': sumaProgresion};
  }
}