import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sigsei/providers/proveedor_estado.dart';
import 'package:sigsei/routes/rutas.dart';
import 'package:sigsei/themes/tema.dart';

void main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle( 
    statusBarColor: Color.alphaBlend(Tema.primary.withOpacity(0.8), Colors.black),
    statusBarIconBrightness: Brightness.light
  )); 

  WidgetsFlutterBinding.ensureInitialized();

  const almacenamiento = FlutterSecureStorage();
  final tokenUsuario = await almacenamiento.read(key: "tokenUsuario");

  await initializeDateFormatting("es_ES", null);
  print(tokenUsuario);
  runApp(AppState(logueado: tokenUsuario != null));

}

class AppState extends StatelessWidget {

  final bool logueado;

  const AppState({super.key, required this.logueado});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProveedorEstado(),
        )
      ],
      child: Main(logueado: logueado),
    );

  }

}

class Main extends StatelessWidget {

  final bool logueado;

  const Main({super.key, required this.logueado});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "sigsei",
      theme: Tema.light,
      debugShowCheckedModeBanner: false,
      initialRoute: logueado ? Rutas.pantallaModulos : Rutas.pantallaAcceso,
      routes: Rutas.rutas
    );

  }

}
