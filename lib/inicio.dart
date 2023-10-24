import 'package:appcredito/Base%20de%20datos%20local/DB.dart';
import 'package:appcredito/login.dart';
import 'package:flutter/material.dart';

class inicio extends StatefulWidget {
  const inicio({Key? key}) : super(key: key);

  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  String _iduser = '';
  double _saldoTotal = 0;

  //------variables de prestamo
  TextEditingController _montocontrolador = TextEditingController();
  TextEditingController _mesescontrolador = TextEditingController();
  double _monto = 0;
  double _meses = 0;
  double _interes = 0;
  double _totalpres = 0;
  double _calculointeres = 0;
  String interes = '';

  //-----------------variable transacciones
  TextEditingController _numerocuentacontroller = TextEditingController();
  TextEditingController _nombrecuentacontroller = TextEditingController();
  TextEditingController _montotransarcontroller = TextEditingController();
  TextEditingController _numcicontroller = TextEditingController();
  double _numcuenta = 0;
  double _montotransar = 0;
  double _numci= 0;
  String _nombrecuenta = '';

  //------------variables Movimientos
  //Transaccion
  String _nombret = '';
  double _totalt = 0;
  double _numerocuenta = 0;
  double _numeroci = 0;

  //Prestamo
  String _cuotasp = '';
  String _interesp = '';
  double _totalp = 0;
  //global
  String _descripcion = '';
  double _montom = 0;
  double _movim = 0;
  int seleccionarItem = -1;




  TextEditingController _testmovimeintocontroller = TextEditingController();

  void hacer() {
    setState(() {
      _saldoTotal = 200000;
    });
  }

  void calculoprestamo() {
    setState(() {
      _meses = 0;
      _monto = double.parse(_montocontrolador.text);
      _meses = double.parse(_mesescontrolador.text);

      if (_meses >= 0 && _meses <= 10) {
        _interes = 0;
        interes = '0%';
      }
      if (_meses >= 11 && _meses <= 15) {
        _interes = 3;
        interes = '3%';
      }
      if (_meses >= 16 && _meses <= 19) {
        _interes = 4;
        interes = '4%';
      }
      if (_meses >= 20 && _meses <= 24) {
        _interes = 5;
        interes = '5%';
      }
      if (_meses >= 25 && _meses <= 32) {
        _interes = 8;
        interes = '8%';
      }

      _calculointeres = _monto * _interes / 100;
      _totalpres = _calculointeres + _monto;
    });
  }

  Future<void> traerdatos() async {
    try {
      final datos = await basededatos2().traerdatos();

      if (datos.isNotEmpty) {
        setState(() {
          _nombret = datos.first['NombreT'];
          _totalt = datos.first['TotalP'];
          _numerocuenta = datos.first['NumCuentaT'];
          _numeroci = datos.first['NumCiT'];
        });
      } else {
        print('No se encontraron datos en la base de datos');
      }
    } catch (a) {
      print('Error al acceder a la base de datos: $a');
    }
  }

  void _MostrarTransaccion(String descripcion, String NombreT, String NumCuentaT, String NumCiT, double monto, String tiempo,) {
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
              Text('$descripcion', style: TextStyle(fontSize: 17),),
              Text('Nombre: $NombreT'),
              Text('N° Cuenta: $NumCuentaT'),
              Text('N° Cedula: $NumCiT'),
              Text('Monto: ${monto.toStringAsFixed(0)}'),
              Text('Tiempo: $tiempo'),
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
  void _MostrarPrestamo(String descripcion, double monto, String cuotas, String interespor, double interes, double totalp, String tiempo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
          // Evita que se cierre el diálogo al tocar fuera o usar el botón de retroceso
          return false;
        },
          child: AlertDialog(
          title: Text('Detalles '),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$descripcion', style: TextStyle(fontSize: 17),),
              Text('Monto: ${monto.toStringAsFixed(0)}'),
              Text('Cuotas: $cuotas'),
              Text('interes: $interespor ${interes.toStringAsFixed(0)}'),
              Text('Total: ${totalp.toStringAsFixed(0)}'),
              Text('Tiempo: $tiempo'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
              child: Text('Cerrar'),
            ),
          ],
          )
        );
      },
    );
  }

  DB myDatabase = DB();
  basededatos2 mybasededatos2 = basededatos2();

  @override
  void initState(){
    traermontototal();
    nombreseccion();
    super.initState();
  }

  Future<void>traermontototal() async{
    setState(() {
      procesocargando = true;
    });

    final dinerototal = await myDatabase.obtenerdinerototal();

    setState(() {
      _saldoTotal = dinerototal;
      procesocargando = false;
    });
  }

  Future<void> nombreseccion() async {
    final user = await Basededatoslogin.instance.traerTodosLosUsuarios();
      setState(() {
        _iduser = user.first['usuario'];
      });
  }


  @override
  void dispose(){
    _testmovimeintocontroller.dispose();
    super.dispose();
  }
 bool procesocargando = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppCredito'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (procesocargando)
                  CircularProgressIndicator()
                else 
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          curve: Curves.bounceIn,
                          height: 160,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                              stops: [0.1, 1],
                              begin: FractionalOffset.bottomLeft,
                              // end: FractionalOffset.bottomCenter
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Text(
                                  _iduser,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                left: 10,
                                top: 10,
                              ),
                              Positioned(
                                child: Text(
                                  'saldo',
                                  style: TextStyle(color: Colors.white),
                                ),
                                height: 20,
                                left: 20,
                                top: 75,
                              ),
                              Positioned(
                                child: Text('GUA ' + _saldoTotal.toStringAsFixed(0),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18)),
                                height: 20,
                                left: 20,
                                top: 100,
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),

                SizedBox(
                  height: 40,
                ),
                 Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(

                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(right: 200),
                              child: Text(
                                'Movimientos',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 345,
                              width: 335,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(245, 245, 245, 100),
                                      Color.fromRGBO(222, 222, 219, 100)
                                    ],
                                    stops: [0.1, 1],
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                    future: mybasededatos2.traerdatos(),
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
                                                    title: Text(items[index]['Descripcion'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.purple,),),
                                                    subtitle: Text('Monto: ${items[index]['Montom']}\nFecha: ${items[index]['Tiempo']}'),
                                                    onTap: () {

                                                      if (items[index]['Descripcion'] == 'Transaccion'){
                                                        _MostrarTransaccion(
                                                          items[index]['Descripcion'],
                                                          items[index]['NombreT'],
                                                          items[index]['NumCuentaT'],
                                                          items[index]['NumCiT'],
                                                          items[index]['Montom'],
                                                          items[index]['Tiempo'],
                                                        );
                                                      }

                                                      if(items[index]['Descripcion'] == 'Prestamos'){

                                                        _MostrarPrestamo(
                                                          items[index]['Descripcion'],
                                                          items[index]['Montom'],
                                                          items[index]['CuotasP'],
                                                          items[index]['InteresPpor'],
                                                          items[index]['InteresP'],
                                                          items[index]['TotalP'],
                                                          items[index]['Tiempo'],
                                                        );
                                                      };
                                                    },
                                                    trailing: IconButton(
                                                      icon: const Icon(Icons.delete),
                                                      onPressed: () {
                                                        setState(() {
                                                          showDialog(context: context, builder: (context){
                                                            return AlertDialog(
                                                              title: Text('Borrar Movimiento'),
                                                              actions: [
                                                                Row(
                                                                  children: [
                                                                    ElevatedButton(onPressed: () {
                                                                      setState(() {
                                                                        Navigator.of(context).pop();
                                                                      });
                                                                    }, child: Text('cancelar')),
                                                                    SizedBox(width: 15,),
                                                                    ElevatedButton(onPressed: () {
                                                                      mybasededatos2.borrardatos(items[index]['id']);
                                                                      setState(() {
                                                                        Navigator.of(context).pop();
                                                                        seleccionarItem = -1;
                                                                      });
                                                                    }, child: Text('Confirmar')),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                          ),
                                      );

                                    },
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                      const SizedBox(
                        width:30,
                      ),
                      Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 200),
                              child: Text(
                                'Prestamos',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 345,
                            width: 335,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(245, 245, 245, 100),
                                    Color.fromRGBO(222, 222, 219, 100)
                                  ],
                                  stops: [0.1, 1],
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 130,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _montocontrolador,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              // hintText: 'Cuotas',
                                                labelText: 'Monto'),
                                          ),
                                          TextFormField(
                                            controller: _mesescontrolador,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              // hintText: 'Cuotas',
                                                labelText: 'cuotas'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text('Interes: ' + interes + ' ${_calculointeres.toStringAsFixed(0)}'),
                                          Text('Total: ${_totalpres.toStringAsFixed(0)}')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Confirmar pedido?',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.blueGrey,
                                                actions: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('cancelar')),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () async{
                                                            final monto = double.parse(_montocontrolador.text);
                                                            await myDatabase.actualizamontototal(_saldoTotal + monto);
                                                            traermontototal();
                                                            calculoprestamo();
                                                              final item =  {
                                                                'Descripcion' : 'Prestamos',
                                                                'Montom' : monto,
                                                                'CuotasP' : _mesescontrolador.text,
                                                                'InteresP' : _calculointeres,
                                                                'InteresPpor' : interes,
                                                                'TotalP' : _totalpres,
                                                                'Tiempo' : DateTime.now().toLocal().toString(),
                                                            };
                                                              _montocontrolador.clear();
                                                            _mesescontrolador.clear();
                                                            await mybasededatos2.insertardatos(item);
                                                            seleccionarItem = 0;

                                                            setState(() {
                                                              interes = '';
                                                              _calculointeres = 0;
                                                              _totalpres = 0;
                                                            });
                                                            Navigator.pop(context);
                                                            FocusScope.of(context).unfocus();
                                                          },
                                                          child: Text('Aceptar')),
                                                    ],
                                                  )
                                                ],
                                              );
                                            }));
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.done),
                                        Text('Confirmar')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        calculoprestamo();
                                      },
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Icon(Icons.refresh),
                                            Text('Calcular')
                                          ],
                                        ),
                                      ))
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 200),
                              child: Text(
                                'Transaciones',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 345,
                            width: 333,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(245, 245, 245, 100),
                                    Color.fromRGBO(222, 222, 219, 100)
                                  ],
                                  stops: [0.1, 1],
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.only(left:20, right: 100),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    controller: _nombrecuentacontroller,
                                    decoration: InputDecoration(
                                        labelText: 'Nombre Titular'
                                    ),
                                  ),),

                                Padding(padding: EdgeInsets.only(left: 20, right: 100),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _numerocuentacontroller,
                                    decoration: InputDecoration(
                                        labelText: 'N° Cuenta'
                                    ),
                                  ),),

                                Padding(padding: EdgeInsets.only(left: 20, right: 100),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _numcicontroller,
                                    decoration: InputDecoration(
                                        labelText: 'N° Cedula'
                                    ),
                                  ),),

                                Padding(padding: EdgeInsets.only(left:20, right: 100),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _montotransarcontroller,
                                    decoration: InputDecoration(
                                        labelText: 'Monto'
                                    ),
                                  ),),

                                Padding(padding: EdgeInsets.only(),
                                  child: ElevatedButton(
                                    onPressed: ()async{
                                      setState(() {
                                        _nombrecuenta = _nombrecuentacontroller.text;
                                        showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                            title: Text('Seguro que quieres Tranferir a '+ _nombrecuenta, style: TextStyle(fontSize: 20),),
                                            actions: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 0,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('cancelar')),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () async{
                                                        final montot = double.parse(_montotransarcontroller.text);
                                                        if (_saldoTotal <= 0 ){
                                                          showDialog(context: context, builder: (context){
                                                            return AlertDialog(
                                                              title: Text('No tienes credito suficiente'),
                                                            );
                                                          });
                                                        }else{
                                                          await myDatabase.actualizamontototal(_saldoTotal - montot);
                                                          traermontototal();
                                                          Navigator.pop(context);
                                                          final datos =  {
                                                            'Descripcion' : 'Transaccion',
                                                            'NombreT' : _nombrecuentacontroller.text,
                                                            'NumCuentaT': _numerocuentacontroller.text,
                                                            'NumCiT': _numcicontroller.text,
                                                            'Montom' : montot,
                                                            'Tiempo' : DateTime.now().toLocal().toString(),
                                                          };
                                                          await mybasededatos2.insertardatos(datos);
                                                          _nombrecuentacontroller.clear();
                                                          _numerocuentacontroller.clear();
                                                          _numcicontroller.clear();
                                                          _montotransarcontroller.clear();
                                                          FocusScope.of(context).unfocus();
                                                        }
                                                      },
                                                      child: Text('Aceptar')),
                                                ],
                                              )

                                            ],
                                          );
                                        });
                                      });
                                    },
                                    child: Text('aceptar'),
                                  ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
