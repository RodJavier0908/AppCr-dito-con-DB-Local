import 'package:appcredito/Base%20de%20datos%20local/DB.dart';
import 'package:appcredito/login.dart';
import 'package:flutter/material.dart';
class craerusuariologin extends StatefulWidget {
  const craerusuariologin({super.key});

  @override
  State<craerusuariologin> createState() => _craerusuariologinState();
}

class _craerusuariologinState extends State<craerusuariologin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  Future<void> _crearcuentausuario() async {
    final usuario = _usuarioController.text;
    final codigo = _codigoController.text;
    final DB = Basededatoslogin.instance;

    final user = await DB.traerusuario(usuario);

    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registro fallido'),
            content: Text('El usuario ya existe.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {

      await DB.crearUserio({'usuario': usuario, 'codigo': codigo});

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registro exitoso'),
            content: Text('El usuario se ha registrado correctamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text('Crear Usuario', style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w600, color: Colors.blueGrey
              ),),
              SizedBox(height: 100,),
              Padding(padding: EdgeInsets.only(left: 70, right: 70),
                child: TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                      labelText: 'Usuario'
                  ),
                ),),
              SizedBox(height: 20,),
              Padding(padding: EdgeInsets.only(left: 70, right: 70),
                child: TextField(
                  controller: _codigoController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'contraseña'
                  ),
                ),),
              SizedBox(height: 50,),
              ElevatedButton(onPressed:_crearcuentausuario, child: Text('Crear')),
            ],
          ),
        ),
      ),
    );
  }
}
