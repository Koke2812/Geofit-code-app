import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/main_menu.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:geofit/database/daos/usuario_dao.dart';

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
      ),
    );
  }

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
  }
}
