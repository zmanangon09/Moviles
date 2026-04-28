import '../model/empleado_model.dart';

class EmpleadoController {
  String procesarSueldo(String edadStr, String antigStr) {
    if (edadStr.isEmpty || antigStr.isEmpty) {
      return 'Por favor, ingrese todos los campos.';
    }

    final int? edad = int.tryParse(edadStr);
    final int? antig = int.tryParse(antigStr);
    if (edad == null || antig == null) {
      return 'Por favor, ingrese valores numéricos válidos.';
    }

    if (edad < 18 || edad > 70) {
      return 'Edad inválida. Debe ser entre 18 y 70 años.';
    }
    if (antig < 0 || antig > (edad - 18)) {
      return 'Antigüedad inválida. Debe ser entre 0 y ${edad - 18}.';
    }

    final resultado = EmpleadoModel.calcularSueldo(edad, antig);
    final int sueldo = resultado['sueldo']!;
    final int adicional = resultado['adicional']!;
    final int suma = resultado['suma']!;

    return 'Sueldo semanal: \$$sueldo\nDetalle: 35000 + $edad + 100*($suma) = \$$sueldo (adicional: \$$adicional)';
  }
}
