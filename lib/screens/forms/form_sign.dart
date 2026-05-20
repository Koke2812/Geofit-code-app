import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/main_menu.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:geofit/database/daos/usuario_dao.dart';

<<<<<<< HEAD
// ─────────────────────────────────────────────
// Pantalla: Iniciar sesión
// ─────────────────────────────────────────────
class FormSign extends StatefulWidget {
  const FormSign({super.key});

  @override
  State<FormSign> createState() => FormSignEstado();
}

class FormSignEstado extends State<FormSign> {
  // ── Clave del formulario ──
  final claveFormulario = GlobalKey<FormState>();

  // ── Servicios ──
  final UsuarioDAO usuarioDAO = UsuarioDAO();

  // ── Controladores de texto ──
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();

  // ── Visibilidad de contraseña ──
  bool ocultarContrasena = true;

  // ── Validación con expresión regular ──
  final RegExp expresionRegular = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{1,10}$');

  bool esValido(String valor) => expresionRegular.hasMatch(valor);

  // ── SnackBar personalizado ──

  void mostrarSnackBar(String mensaje, {Color color = AppColors.error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.white, size: 20),
            const SizedBox(width: AppDimensions.paddingSmall),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        margin: const EdgeInsets.all(AppDimensions.snackBarMargin),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,

      // ── AppBar ──
      appBar: AppBar(
        title: Text(traducciones.signIn),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            label: Text(traducciones.goBack, style: AppTextStyles.formButton),
          ),
        ],
      ),

      // ── Cuerpo ──
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingBody),
        child: Form(
          key: claveFormulario,
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Campo: Usuario
              construirCampoTexto(
                etiqueta: traducciones.nameUser,
                controlador: controladorUsuario,
                textoAyuda: traducciones.maxCharsHint,
                ocultar: false,
              ),

              const SizedBox(height: 20),

              // Campo: Contraseña
              construirCampoTexto(
                etiqueta: traducciones.password,
                controlador: controladorContrasena,
                textoAyuda: traducciones.maxCharsHint,
                ocultar: ocultarContrasena,
                esContrasena: true,
                alternarVisibilidad: () => setState(() => ocultarContrasena = !ocultarContrasena),
              ),

              const SizedBox(height: 40),

              // Botón: Iniciar sesión
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightSmall,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!esValido(controladorUsuario.text)) {
                      mostrarSnackBar(traducciones.userInvalid);
                      return;
                    }
                    if (!esValido(controladorContrasena.text)) {
                      mostrarSnackBar(traducciones.passInvalid);
                      return;
                    }

                    if (claveFormulario.currentState!.validate()) {
                      final usuario = await usuarioDAO.getUsuario(
                        controladorUsuario.text,
                        controladorContrasena.text,
                      );

                      if (usuario != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MainMenu(usuario: usuario)),
                        );
                      } else {
                        mostrarSnackBar(traducciones.userOrPassWrong, color: AppColors.warning);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(
                    traducciones.signInButton,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
=======
class FormSign extends StatefulWidget {
  const FormSign({super.key});
  @override
  State<FormSign> createState() => FormSignState();
}

class FormSignState extends State<FormSign> {
  final formKey = GlobalKey<FormState>();
  final UsuarioDAO usuarioDAO = UsuarioDAO();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool obscurePass = true;
  final RegExp regExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{1,10}$');
  bool isValid(String value) => regExp.hasMatch(value);

  void mostrarSnackBar(String mensaje, {Color color = AppColors.error}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.warning_amber_rounded, color: AppColors.white, size: 20), const SizedBox(width: AppDimensions.paddingSmall), Expanded(child: Text(mensaje))]),
      backgroundColor: color, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
      margin: const EdgeInsets.all(AppDimensions.snackBarMargin), duration: const Duration(seconds: 3)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text(t.signIn), actions: [
        TextButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          label: Text(t.goBack, style: AppTextStyles.formButton)),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingBody),
        child: Form(key: formKey, child: Column(children: [
          const SizedBox(height: 30),
          buildCustomTextField(label: t.nameUser, controller: userController, helper: t.maxCharsHint, obscure: false),
          const SizedBox(height: 20),
          buildCustomTextField(label: t.password, controller: passController, helper: t.maxCharsHint, obscure: obscurePass, isPassword: true,
            toggleVisibility: () => setState(() => obscurePass = !obscurePass)),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, height: AppDimensions.buttonHeightSmall, child: ElevatedButton(
            onPressed: () async {
              if (!isValid(userController.text)) { mostrarSnackBar(t.userInvalid); return; }
              if (!isValid(passController.text)) { mostrarSnackBar(t.passInvalid); return; }
              if (formKey.currentState!.validate()) {
                final usuario = await usuarioDAO.getUsuario(userController.text, passController.text);
                if (usuario != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu(usuario: usuario)));
                } else { mostrarSnackBar(t.userOrPassWrong, color: AppColors.warning); }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(t.signInButton, style: const TextStyle(color: AppColors.white)),
          )),
        ])),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
      ),
    );
  }

<<<<<<< HEAD
  // ── Widget reutilizable: campo de texto con validación visual ──

  Widget construirCampoTexto({
    required String etiqueta,
    required TextEditingController controlador,
    required bool ocultar,
    String? textoAyuda,
    bool esContrasena = false,
    VoidCallback? alternarVisibilidad,
  }) {
    final traducciones = AppLocalizations.of(context)!;

    bool cumpleRegex = esValido(controlador.text);
    Color colorBorde = cumpleRegex ? AppColors.primary : AppColors.error;
    if (controlador.text.isEmpty) colorBorde = AppColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: AppTextStyles.labelBold),
        const SizedBox(height: 8),
        TextFormField(
          controller: controlador,
          obscureText: ocultar,
          onChanged: (valor) => setState(() {}),
          decoration: InputDecoration(
            hintText: textoAyuda,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorde, width: AppDimensions.borderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorde, width: AppDimensions.borderWidthFocused),
            ),
            suffixIcon: esContrasena
                ? IconButton(
                    icon: Icon(ocultar ? Icons.visibility_off : Icons.visibility),
                    onPressed: alternarVisibilidad,
                  )
                : null,
          ),
          validator: (valor) {
            if (!esValido(valor!)) return traducciones.reqNotMet;
            return null;
          },
        ),
      ],
    );
=======
  Widget buildCustomTextField({required String label, required TextEditingController controller, required bool obscure, String? helper, bool isPassword = false, VoidCallback? toggleVisibility}) {
    final t = AppLocalizations.of(context)!;
    bool regexOk = isValid(controller.text);
    Color borderColor = regexOk ? AppColors.primary : AppColors.error;
    if (controller.text.isEmpty) borderColor = AppColors.grey;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.labelBold),
      const SizedBox(height: 8),
      TextFormField(controller: controller, obscureText: obscure, onChanged: (val) => setState(() {}),
        decoration: InputDecoration(hintText: helper,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: AppDimensions.borderWidth)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: AppDimensions.borderWidthFocused)),
          suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: toggleVisibility) : null),
        validator: (value) { if (!isValid(value!)) return t.reqNotMet; return null; }),
    ]);
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
  }
}
