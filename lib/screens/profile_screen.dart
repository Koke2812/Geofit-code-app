import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/locale_notifier.dart';
import 'package:geofit/database/daos/usuario_dao.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';

// ─────────────────────────────────────────────
// Pantalla: Perfil del usuario
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  final Usuario? usuario;

  const ProfileScreen({super.key, this.usuario});

  @override
  State<ProfileScreen> createState() => ProfileScreenEstado();
}

class ProfileScreenEstado extends State<ProfileScreen> {
  // ── Controladores de texto ──
  late TextEditingController controladorUsuario;
  late TextEditingController controladorContrasena;

  // ── Estado de la UI ──
  bool contrasenaOculta = true;

  // ── Servicios ──
  final UsuarioDAO usuarioDAO = UsuarioDAO();
  final ImagePicker selectorImagenes = ImagePicker();

  // ── Foto de perfil ──
  String? rutaFoto;

  // ── Ciclo de vida ──

  @override
  void initState() {
    super.initState();
    controladorUsuario = TextEditingController(text: widget.usuario?.usuario ?? "");
    controladorContrasena = TextEditingController(text: widget.usuario?.contrasena ?? "");
    rutaFoto = widget.usuario?.fotoPath;
  }

  @override
  void dispose() {
    controladorUsuario.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }

  // ── Opciones de foto ──

  void mostrarOpcionesFoto() {
    final traducciones = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (contexto) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                traducciones.changeProfilePhoto,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Opción: Cámara
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: Text(traducciones.takePhoto),
                subtitle: Text(traducciones.useDeviceCamera),
                onTap: () {
                  Navigator.pop(contexto);
                  tomarFoto(ImageSource.camera);
                },
              ),

              // Opción: Galería
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.fatColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: AppColors.fatColor),
                ),
                title: Text(traducciones.chooseGallery),
                subtitle: Text(traducciones.selectExistingImage),
                onTap: () {
                  Navigator.pop(contexto);
                  tomarFoto(ImageSource.gallery);
                },
              ),

              // Opción: Eliminar foto (solo si existe)
              if (rutaFoto != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: AppColors.error),
                  ),
                  title: Text(traducciones.deletePhoto),
                  onTap: () {
                    Navigator.pop(contexto);
                    setState(() => rutaFoto = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Captura / selección de foto ──

  Future<void> tomarFoto(ImageSource origen) async {
    try {
      final XFile? imagen = await selectorImagenes.pickImage(
        source: origen,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (imagen == null) return;

      final directorioApp = await getApplicationDocumentsDirectory();
      final directorioFotos = Directory('${directorioApp.path}/fotos_perfil');

      if (!await directorioFotos.exists()) {
        await directorioFotos.create(recursive: true);
      }

      final nombreArchivo =
          'perfil_${widget.usuario?.id ?? 0}_${DateTime.now().millisecondsSinceEpoch}${p.extension(imagen.path)}';
      final rutaDestino = '${directorioFotos.path}/$nombreArchivo';

      await File(imagen.path).copy(rutaDestino);

      setState(() => rutaFoto = rutaDestino);

      if (widget.usuario?.id != null) {
        await usuarioDAO.updateFotoPath(widget.usuario!.id!, rutaDestino);
      }
    } catch (e) {
      /* Error silencioso */
    }
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(traducciones.myProfile, style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),

      // ── Cuerpo ──
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingBody),
        child: Column(
          children: [
            // ── Avatar con cámara ──
            GestureDetector(
              onTap: mostrarOpcionesFoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: AppDimensions.avatarRadius,
                    backgroundColor: AppColors.avatarBg,
                    backgroundImage:
                        rutaFoto != null && File(rutaFoto!).existsSync()
                            ? FileImage(File(rutaFoto!))
                            : null,
                    child: rutaFoto == null || !File(rutaFoto!).existsSync()
                        ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: AppDimensions.borderWidth),
                      ),
                      child: const Icon(Icons.camera_alt, color: AppColors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              traducciones.tapToChangePhoto,
              style: TextStyle(color: AppColors.greyHint, fontSize: 12),
            ),

            const SizedBox(height: 20),

            // ── Campo: Usuario ──
            construirCampoPerfil(
              etiqueta: traducciones.user,
              controlador: controladorUsuario,
              icono: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // ── Campo: Contraseña ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(traducciones.password, style: AppTextStyles.greyLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: controladorContrasena,
                  obscureText: contrasenaOculta,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        contrasenaOculta ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.grey,
                      ),
                      onPressed: () => setState(() => contrasenaOculta = !contrasenaOculta),
                    ),
                    filled: true,
                    fillColor: AppColors.greyLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Selector de idioma ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(traducciones.language, style: AppTextStyles.greyLabel),
                const SizedBox(height: 8),
                ValueListenableBuilder<Locale>(
                  valueListenable: localeNotifier,
                  builder: (contexto, idiomaActual, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: idiomaActual.languageCode,
                          items: const [
                            DropdownMenuItem(
                              value: 'es',
                              child: Row(
                                children: [
                                  Text('🇪🇸', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 10),
                                  Text('Español'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'en',
                              child: Row(
                                children: [
                                  Text('🇬🇧', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 10),
                                  Text('English'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (valor) {
                            if (valor != null) {
                              localeNotifier.value = Locale(valor);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ── Botón guardar ──
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                ),
                onPressed: () async {
                  if (widget.usuario == null) return;

                  final usuarioActualizado = Usuario(
                    id: widget.usuario!.id,
                    usuario: controladorUsuario.text,
                    contrasena: controladorContrasena.text,
                    saldo: widget.usuario!.saldo,
                    dietaPagada: widget.usuario!.dietaPagada,
                    fotoPath: rutaFoto,
                  );

                  await usuarioDAO.updateUsuario(usuarioActualizado);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(traducciones.profileUpdated)),
                  );

                  Navigator.pop(context, usuarioActualizado);
                },
                child: Text(traducciones.saveChanges, style: AppTextStyles.buttonWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Widget reutilizable: campo de perfil ──

  Widget construirCampoPerfil({
    required String etiqueta,
    required TextEditingController controlador,
    required IconData icono,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: AppTextStyles.greyLabel),
        const SizedBox(height: 8),
        TextField(
          controller: controlador,
          decoration: InputDecoration(
            prefixIcon: Icon(icono, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
