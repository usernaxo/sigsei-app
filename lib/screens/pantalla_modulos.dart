import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigsei/helpers/modulo.dart';
import 'package:sigsei/models/usuario.dart';
import 'package:sigsei/themes/tema.dart';
import 'package:sigsei/widgets/barra_usuario.dart';

class PantallaModulos extends StatelessWidget {
  
  const PantallaModulos({super.key});

  @override
  Widget build(BuildContext context) {

    Future<Usuario?> obtenerUsuario() async {

      const almacenamiento = FlutterSecureStorage();

      String? usuario = await almacenamiento.read(key: "usuario");

      if (usuario != null) {

        return Usuario.fromJson(usuario);
        
      }

      return null;

    }
    
    List<Modulo> modulos = [
      Modulo(
        titulo: "Indicadores de Inventarios",
        descripcion: "Seleccione esta opción para visualizar los indicadores de gestión de inventarios",
        ruta: "pantalla_indicadores",
        icono: Icons.inventory_rounded
      ),
      Modulo(
        titulo: "Otro módulo",
        descripcion: "Descripción de otro módulo aquí",
        ruta: "pantalla_indicadores",
        icono: Icons.settings_rounded
      ),
      Modulo(
        titulo: "Otro módulo",
        descripcion: "Descripción de otro módulo aquí",
        ruta: "pantalla_indicadores",
        icono: Icons.settings_rounded
      ),
      Modulo(
        titulo: "Otro módulo",
        descripcion: "Descripción de otro módulo aquí",
        ruta: "pantalla_indicadores",
        icono: Icons.settings_rounded
      ),
      Modulo(
        titulo: "Otro módulo",
        descripcion: "Descripción de otro módulo aquí",
        ruta: "pantalla_indicadores",
        icono: Icons.settings_rounded
      )
    ];

    return Scaffold(
      body: FutureBuilder(
        future: obtenerUsuario(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator());

          } else if (snapshot.hasError) {

            return const Center(child: Text("Error"));

          } else if (snapshot.hasData) {

            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: CurvaFondoInferior(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Tema.primary,
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      BarraUsuario(usuario: snapshot.data!, botonRetroceso: false),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.arrow_drop_down_rounded),
                                Text.rich(
                                  TextSpan(
                                    text: "Módulos ",
                                    children: [
                                      TextSpan(
                                        text: "SIG",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        )
                                      )
                                    ]
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    child: Divider()
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: modulos.length,
                            itemBuilder: (context, index) {

                              return Card(
                                child: ListTile(
                                  leading: Icon(modulos[index].icono),
                                  trailing: const Icon(Icons.arrow_right_rounded),
                                  title: Text(modulos[index].titulo),
                                  subtitle: Text(modulos[index].descripcion),
                                  onTap: () {

                                    Navigator.pushNamed(context, modulos[index].ruta, arguments: {
                                      "modulo" : modulos[index],
                                      "usuario" : snapshot.data
                                    });
                              
                                  }

                                ),
                              );
                
                            },
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ]
            );

          }

          return Container();

        },
      )
    );

  }

}

class CurvaFondoInferior extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    Path path = Path();

    path.moveTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      0,
      size.height * 0.7,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}
