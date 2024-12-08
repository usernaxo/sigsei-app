import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/helpers/modal_mensaje.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/themes/tema.dart';

class PantallaAcceso extends StatefulWidget {

  const PantallaAcceso({super.key});

  @override
  State<PantallaAcceso> createState() => _PantallaAccesoState();

}

class _PantallaAccesoState extends State<PantallaAcceso> {

  final GlobalKey<FormState> claveFormulario = GlobalKey<FormState>();

  String? email;
  String? clave;

  @override
  Widget build(BuildContext context) {

    final provedor = Provider.of<ProveedorEstado>(context);

    Future<void> iniciarSesion() async {

      if (claveFormulario.currentState?.validate() ?? false) {

        claveFormulario.currentState?.save();

        ModalMensaje(titulo: "Validando Usuario", tipoMensaje: ModalMensaje.cargando).mostrar(context);

        final respuestaIniciarSesion = await provedor.iniciarSesion(email!, clave!);

        Navigator.pop(context);

        if (respuestaIniciarSesion["success"]) {

          Navigator.pushReplacementNamed(context, "pantalla_modulos");
          
        } else {

          ModalMensaje(titulo: respuestaIniciarSesion["message"], tipoMensaje: ModalMensaje.advertencia).mostrar(context);

        }

      }

    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CurvaFondoSuperior(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Tema.primary,
              ),
            ),
          ),
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
          Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/sei.png",
                              color: Tema.primary,
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "Consultores",
                              style: TextStyle(
                                color: Tema.primary,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        Form(
                          key: claveFormulario,
                          child: Column(
                            children: [
                              const Divider(),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text("Ingrese email y clave para acceder")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  initialValue: "igomez@seiconsultores.cl",
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Email",
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      size: 15,
                                    )
                                  ),
                                  onSaved: (value) => email = value,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                child: TextFormField(
                                  obscureText: true,
                                  initialValue: "ignaciosei2024",
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Clave",
                                    prefixIcon: Icon(
                                      Icons.lock_rounded,
                                      size: 15,
                                    )
                                  ),
                                  onSaved: (value) => clave = value,
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    label: provedor.estaCargando ? const Text("Validando...") : const Text("Acceder"),
                                    icon: provedor.estaCargando ? null : const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 15,
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 1.5
                                      ),
                                    ),
                                    onPressed: provedor.estaCargando ? null : () => iniciarSesion()
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );

  }
}

class CurvaFondoSuperior extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width,
      size.height * 0.3
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

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
