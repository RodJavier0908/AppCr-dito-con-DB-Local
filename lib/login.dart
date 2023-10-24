import 'package:appcredito/Base%20de%20datos%20local/DB.dart';
import 'package:appcredito/administrarusuario.dart';
import 'package:appcredito/crearusuariologin.dart';
import 'package:appcredito/inicio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  bool crearuser = true;
  Future<void> _iniciarseccion() async {
    final usuario = _usuarioController.text;
    final codigo = _codigoController.text;
    final db = Basededatoslogin.instance;

    final user = await db.traerusuario(usuario);

    if (user != null && user['codigo'] == codigo) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => inicio()));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text(''),
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
    }

  }

  Future<void>cambairbool() async{

    final users = await Basededatoslogin.instance.traerTodosLosUsuarios();

    if (users.isNotEmpty) {
      setState(() {
        crearuser = false;
      });
    }
  }
  @override
  void initState(){
    cambairbool();
    super.initState();
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
              Text('AppCredito', style: TextStyle(
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
              ElevatedButton(onPressed:_iniciarseccion, child: Text('Acceder')),
              SizedBox(height: 30,),
              Row(
                children: [
                  SizedBox(width: 70,),
                  crearuser?Text('si no tiene una cuenta'):Text('si olvido su codigo'),
                  crearuser?TextButton(onPressed: () {
                    cambairbool();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>craerusuariologin()));
                  }, child: Text('cree una')):TextButton(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => administrarusuario(),));
                  }, child: Text('presione aquí'))

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
