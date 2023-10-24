import 'package:appcredito/Base%20de%20datos%20local/DB.dart';
import 'package:appcredito/login.dart';
import 'package:flutter/material.dart';

class administrarusuario extends StatefulWidget {
  const administrarusuario({super.key});

  @override
  State<administrarusuario> createState() => _administrarusuarioState();
}

class _administrarusuarioState extends State<administrarusuario> {
  int seleccionarItem = -1;
  void _Mostrarcuenta(String usuario, String codigo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Text('Detalles '),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nombre: $usuario'),
                  Text('codigo: $codigo'),

                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            )
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Text('AppCredito', style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, color: Colors.blueGrey
            ),),
            SizedBox(height: 100,),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Basededatoslogin.instance.traerTodosLosUsuarios(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final items = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                      itemCount: items!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation:  7,
                          child: ListTile(
                            title: Text(items[index]['usuario'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.purple,),),
                            onTap: () {

                                _Mostrarcuenta(
                                  items[index]['usuario'],
                                  items[index]['codigo'],

                                );

                            },

                          ),
                        );
                      }
                  ),
                );

              },
            ),
            SizedBox(height: 100,),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
            }, child: Text('volver')),
            SizedBox(height: 150,),
          ],
        ),
      ),
    );
  }
}
