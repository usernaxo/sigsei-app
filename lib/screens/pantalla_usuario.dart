import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/models/usuario_datos.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/pantalla_general/barra_usuario.dart';
import 'package:sigsei/widgets/pantalla_general/menu_usuario.dart';

class PantallaUsuario extends StatefulWidget {

  const PantallaUsuario({super.key});

  @override
  PantallaUsuarioState createState() => PantallaUsuarioState();

}

class PantallaUsuarioState extends State<PantallaUsuario> {

  final GlobalKey<ScaffoldState> clavePantallaUsuario = GlobalKey<ScaffoldState>();

  late Future<UsuarioDatos?> usuarioDatos;

  @override
  void initState() {

    super.initState();

    final proveedorEstado = Provider.of<ProveedorEstado>(context, listen: false);

    usuarioDatos = proveedorEstado.obtenerDatosUsuario();

  }

  @override
  void dispose() {

    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {

    final argumentos = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Usuario usuario = argumentos["usuario"];

    Widget construirFila(IconData icono, String clave, String valor, {Color colorIcono = Colors.black, bool esPrimeraFila = false}) {

      return Padding(
        padding: esPrimeraFila ? EdgeInsets.zero : const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Tema.primaryLight,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Icon(
                    icono,
                    size: 15,
                    color: colorIcono,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    clave,
                    style: TextStyle(
                      color: Tema.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10
                  ),
                ),
              ),
            )
          ],
        ),
      );

    }

    return Scaffold(
      key: clavePantallaUsuario,
      resizeToAvoidBottomInset: false,
      drawer: MenuUsuario(usuario: usuario),
      body: SafeArea(
        child: Column(
          children: [
            BarraUsuario(usuario: usuario, claveMenu: clavePantallaUsuario, botonRetroceso: true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Tema.primaryLight,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      foregroundColor: Tema.primary,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 25,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usuario.obtenerNombre!,
                              style: TextStyle(
                                color: Tema.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                            Text(
                              usuario.obtenerEmail!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: usuarioDatos,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
            
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Tema.primary,
                            strokeWidth: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Obteniendo Datos")
                      ],
                    ),
                  );
            
                } else if (snapshot.hasError) {
            
                  return const Center(child: Text("Error"));
            
                } else if (!snapshot.hasData) {
            
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Tema.primaryLight,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Tema.secondaryLight,
                          width: 1.5
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Sin datos de usuario",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500
                            ),
                          ),
                          Text(
                            "Reintente",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  );
            
                } else {

                  final usuarioObtenido = snapshot.data!;

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_drop_down_rounded),
                                const SizedBox(width: 5),
                                const Text(
                                  "Datos Personales"
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    child: Divider(color: Tema.secondaryLight)
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  construirFila(Icons.person_pin_circle_rounded, "Nombres: ", usuarioObtenido.obtenerNombres!, esPrimeraFila: true, colorIcono: Colors.teal.shade200),
                                  construirFila(Icons.person_pin_circle_rounded, "Apellidos: ", usuarioObtenido.obtenerApellidos!, colorIcono: Colors.teal.shade200),
                                  construirFila(Icons.cake_rounded, "Fecha de nacimiento: ", usuarioObtenido.obtenerFechaNacimiento!, colorIcono: Colors.deepPurple.shade200),
                                  construirFila(Icons.male_rounded, "Género: ", usuarioObtenido.obtenerGenero!, colorIcono: Colors.pink.shade200),
                                  construirFila(Icons.flag_rounded, "Nacionalidad: ", usuarioObtenido.obtenerNacionalidad!, colorIcono: Colors.orange.shade200),
                                  construirFila(Icons.phone_rounded, "Teléfono de contacto: ", usuarioObtenido.obtenerTelefonoContacto!, colorIcono: Colors.blue.shade200),
                                  construirFila(Icons.phone_forwarded_rounded, "Teléfono de emergencia: ", usuarioObtenido.obtenerTelefonoEmergencia!, colorIcono: Colors.blue.shade200),
                                  construirFila(Icons.email_rounded, "Email: ", usuarioObtenido.obtenerEmail!, colorIcono: Colors.deepOrange.shade200),
                                  construirFila(Icons.alternate_email_rounded, "Email personal: ", usuarioObtenido.obtenerEmailPersonal!, colorIcono: Colors.deepOrange.shade200),
                                  construirFila(Icons.home_rounded, "Dirección: ", usuarioObtenido.obtenerDireccion!, colorIcono: Colors.green.shade200),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.arrow_drop_down_rounded),
                                const SizedBox(width: 5),
                                const Text(
                                  "Datos Bancarios"
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    child: Divider(color: Tema.secondaryLight)
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  construirFila(Icons.account_balance_rounded, "Numero de cuenta: ", usuarioObtenido.obtenerNumeroCuenta!, esPrimeraFila: true, colorIcono: Colors.teal.shade200)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
            
                }

              },
            )
          ]
        ),
      )
    );

  }

}
