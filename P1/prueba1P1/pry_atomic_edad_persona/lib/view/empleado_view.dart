import 'package:flutter/material.dart';
import '../controller/empleado_controller.dart';

class Label extends StatelessWidget{
  final String text;
  //constructor
  Label(this.text,{super.key});

  @override
  Widget build(BuildContext context) =>
      Text(text,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);

}
  //NumberField
class NumberField extends StatelessWidget{
    final TextEditingController controller;
    final String hint;
    NumberField({super.key, required this.controller, required this.hint});
    @override
    Widget build(BuildContext context) =>TextField(
      controller:controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(),
      ),
    );
}
  //Button
class Button extends StatelessWidget{
    final String text;
    final VoidCallback onPressed;
    Button({super.key, required this.text, required this.onPressed});
    @override
    Widget build(BuildContext context) =>
        ElevatedButton(
            onPressed: onPressed,
            child: Text(text)
        );
}

//resultado
class ResultText extends StatelessWidget{
  final String text;
  ResultText(this.text,{super.key});
  @override
  Widget build(BuildContext context) =>
      Text(
        text,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

      );


}

//molecula
class EdadAntigInput extends StatelessWidget{
  final TextEditingController edadC, antigC;
  EdadAntigInput({super.key, required this.edadC, required this.antigC});
  @override
  Widget build(BuildContext context) =>
      Row(
        children: [
          Expanded (child: NumberField(controller: edadC, hint: 'Edad')),
          SizedBox(width: 10),
          Expanded (child: NumberField(controller: antigC, hint: 'Antiguedad (años)')),
        ],
      );
}
//organismos

class EdadCard extends StatefulWidget{
  EdadCard({super.key});
  @override
  State<EdadCard> createState() => _EdadCardState();

}

class _EdadCardState extends State<EdadCard>{
  final _ctrlEdad = TextEditingController();
  final _ctrlAnt = TextEditingController();
  String _resultado = '';
  final _controller = EmpleadoController();
  void _calcular (){
    setState((){
      _resultado = _controller.procesarSueldo(
          _ctrlEdad.text,
          _ctrlAnt.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Label("Ingrese su edad y antiguedad en XYZ:"),
            SizedBox(height: 10,),
            EdadAntigInput(
                edadC: _ctrlEdad,
                antigC: _ctrlAnt
            ),
            SizedBox(height: 10,),
            Button(text: "Calcular Sueldo", onPressed: _calcular),
            SizedBox(height: 10,),
            Label(_resultado),

          ],
        ),
      ),
    );
  }
}
//pagina a llamar
class EdadPage extends StatelessWidget {
  EdadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Edad"),
      ),
      body: Center(
        child: EdadCard(),
      ),
    );
  }


}


