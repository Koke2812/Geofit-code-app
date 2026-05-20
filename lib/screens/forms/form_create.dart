import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/screens/main_menu.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:geofit/database/daos/usuario_dao.dart';
import 'package:geofit/models/usuario.dart';

<<<<<<< HEAD
// ─────────────────────────────────────────────
// Pantalla: Crear cuenta
// ─────────────────────────────────────────────
class FormCreate extends StatefulWidget {
  const FormCreate({super.key});

  @override
  State<FormCreate> createState() => FormCreateEstado();
}

class FormCreateEstado extends State<FormCreate> {
  // ── Clave del formulario ──
  final claveFormulario = GlobalKey<FormState>();

  // ── Servicios ──
  final UsuarioDAO usuarioDAO = UsuarioDAO();

  // ── Controladores de texto ──
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();
  final TextEditingController controladorConfirmarContrasena = TextEditingController();

  // ── Visibilidad de contraseñas ──
  bool ocultarContrasena = true;
  bool ocultarConfirmacion = true;

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
        title: Text(traducciones.createAccount),
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

              const SizedBox(height: 20),

              // Campo: Confirmar contraseña
              construirCampoTexto(
                etiqueta: traducciones.repeatPassword,
                controlador: controladorConfirmarContrasena,
                textoAyuda: traducciones.mustMatchPassword,
                ocultar: ocultarConfirmacion,
                esContrasena: true,
                esCampoConfirmacion: true,
                alternarVisibilidad: () => setState(() => ocultarConfirmacion = !ocultarConfirmacion),
              ),

              const SizedBox(height: 40),

              // Botón: Crear cuenta
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
                    if (controladorContrasena.text != controladorConfirmarContrasena.text) {
                      mostrarSnackBar(traducciones.passNoMatch);
                      return;
                    }

                    if (claveFormulario.currentState!.validate()) {
                      final existente = await usuarioDAO.getUsuarioByName(controladorUsuario.text);

                      if (existente != null) {
                        mostrarSnackBar(traducciones.userAlreadyExists, color: AppColors.warning);
                        return;
                      }

                      final nuevoUsuario = Usuario(
                        usuario: controladorUsuario.text,
                        contrasena: controladorContrasena.text,
                      );

                      await usuarioDAO.insertUsuario(nuevoUsuario);

                      final usuarioCreado = await usuarioDAO.getUsuario(
                        controladorUsuario.text,
                        controladorContrasena.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: AppColors.white, size: 20),
                              const SizedBox(width: AppDimensions.paddingSmall),
                              Text(traducciones.accountCreated),
                            ],
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          margin: const EdgeInsets.all(AppDimensions.snackBarMargin),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MainMenu(usuario: usuarioCreado)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(
                    traducciones.createAccountButton,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
=======
class FormCreate extends StatefulWidget {
  const FormCreate({super.key});
  @override
  State<FormCreate> createState() => FormCreateState();
}

class FormCreateState extends State<FormCreate> {
  final formKey = GlobalKey<FormState>();
  final UsuarioDAO usuarioDAO = UsuarioDAO();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool obscurePass = true;
  bool obscureConfirm = true;
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
      appBar: AppBar(title: Text(t.createAccount), actions: [
        TextButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          label: Text(t.goBack, style: AppTextStyles.formButton)),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingBody),
        child: Form(key: formKey, child: Column(children: [
          buildCustomTextField(label: t.nameUser, controller: userController, helper: t.maxCharsHint, obscure: false),
          const SizedBox(height: 20),
          buildCustomTextField(label: t.password, controller: passController, helper: t.maxCharsHint, obscure: obscurePass, isPassword: true,
            toggleVisibility: () => setState(() => obscurePass = !obscurePass)),
          const SizedBox(height: 20),
          buildCustomTextField(label: t.repeatPassword, controller: confirmPassController, helper: t.mustMatchPassword, obscure: obscureConfirm, isPassword: true, isConfirmField: true,
            toggleVisibility: () => setState(() => obscureConfirm = !obscureConfirm)),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, height: AppDimensions.buttonHeightSmall, child: ElevatedButton(
            onPressed: () async {
              if (!isValid(userController.text)) { mostrarSnackBar(t.userInvalid); return; }
              if (!isValid(passController.text)) { mostrarSnackBar(t.passInvalid); return; }
              if (passController.text != confirmPassController.text) { mostrarSnackBar(t.passNoMatch); return; }
              if (formKey.currentState!.validate()) {
                final existente = await usuarioDAO.getUsuarioByName(userController.text);
                if (existente != null) { mostrarSnackBar(t.userAlreadyExists, color: AppColors.warning); return; }
                final nuevoUsuario = Usuario(usuario: userController.text, contrasena: passController.text);
                await usuarioDAO.insertUsuario(nuevoUsuario);
                final usuarioCreado = await usuarioDAO.getUsuario(userController.text, passController.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: [const Icon(Icons.check_circle, color: AppColors.white, size: 20), const SizedBox(width: AppDimensions.paddingSmall), Text(t.accountCreated)]),
                  backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                  margin: const EdgeInsets.all(AppDimensions.snackBarMargin)));
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu(usuario: usuarioCreado)));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(t.createAccountButton, style: const TextStyle(color: AppColors.white)),
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
    bool esCampoConfirmacion = false,
    VoidCallback? alternarVisibilidad,
  }) {
    final traducciones = AppLocalizations.of(context)!;

    bool cumpleRegex = esValido(controlador.text);
    bool coincide = esCampoConfirmacion
        ? (controlador.text == controladorContrasena.text && controlador.text.isNotEmpty)
        : true;

    Color colorBorde = (cumpleRegex && coincide) ? AppColors.primary : AppColors.error;
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
            if (esCampoConfirmacion && valor != controladorContrasena.text) {
              return traducciones.noMatch;
            }
            return null;
          },
        ),
      ],
    );
=======
  Widget buildCustomTextField({required String label, required TextEditingController controller, required bool obscure, String? helper, bool isPassword = false, bool isConfirmField = false, VoidCallback? toggleVisibility}) {
    final t = AppLocalizations.of(context)!;
    bool regexOk = isValid(controller.text);
    bool matchOk = isConfirmField ? (controller.text == passController.text && controller.text.isNotEmpty) : true;
    Color borderColor = (regexOk && matchOk) ? AppColors.primary : AppColors.error;
    if (controller.text.isEmpty) borderColor = AppColors.grey;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.labelBold),
      const SizedBox(height: 8),
      TextFormField(controller: controller, obscureText: obscure, onChanged: (val) => setState(() {}),
        decoration: InputDecoration(hintText: helper,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: AppDimensions.borderWidth)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: AppDimensions.borderWidthFocused)),
          suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: toggleVisibility) : null),
        validator: (value) {
          if (!isValid(value!)) return t.reqNotMet;
          if (isConfirmField && value != passController.text) return t.noMatch;
          return null;
        }),
    ]);
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
  }
}
