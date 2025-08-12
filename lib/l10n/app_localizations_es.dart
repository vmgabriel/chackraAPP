// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => 'Bienvenido';

  @override
  String get start_session_to_continue => 'Inicia Sesion para Continuar';

  @override
  String get email => 'Correo Electronico';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get are_you_forget_the_password => '¿Olvidaste tu Contraseña?';

  @override
  String get insert_your_password => 'Inserta Tu Contraseña';

  @override
  String get please_insert_your_password => 'Por favor, Ingresa la Contraseña';

  @override
  String field_require_least(String gender, String field, num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.selectLogic(field, {
      'male': 'El',
      'female': 'La',
      'other': 'Con',
    });
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString caracteres',
      one: '1 caracter',
    );
    return '$_temp0 $field debe tener al menos $_temp1';
  }

  @override
  String get please_insert_your_email => 'Por Favor, Ingresa tu Email';

  @override
  String get please_insert_a_valid_email =>
      'Por favor, ingresa un correo válido';

  @override
  String get im_new => 'Soy Nuevo, Quiero Registrarme';

  @override
  String get repeat_password => 'Repetir Contraseña';

  @override
  String get register => 'Registrar';

  @override
  String get username => 'Alias';

  @override
  String get name => 'Nombre';

  @override
  String get last_name => 'Apellido';

  @override
  String get phone => 'Numero de Telefono';

  @override
  String get complete_the_form => 'Completa el Formulario para Registrarte';

  @override
  String get on_building => 'En Construccion';

  @override
  String get soon_view_will_be_complete =>
      'Muy Pronto tendrás esta funcionalidad';

  @override
  String get home => 'Principal';

  @override
  String get home_view => 'Vista Principal';

  @override
  String get show_notifications => 'Mostrar Notificaciones';

  @override
  String get menu => 'Menu';

  @override
  String get tasks => 'Tareas';

  @override
  String get edit_profile => 'Editar Perfil';

  @override
  String get biography => 'Biografía';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get profile => 'Perfil';

  @override
  String get configurations => 'Configurations';

  @override
  String get help_and_contact => 'Ayuda y Contacto';

  @override
  String get logout => 'Cerrar Sesion';

  @override
  String get preferences => 'Preferencias';

  @override
  String get dark_mode => 'Modo Oscuro';

  @override
  String get account => 'Cuenta';

  @override
  String get change_password => 'Cambiar Contraseña';

  @override
  String get authentication_with_biometric => 'Autenticación con Biometria';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get idiom => 'Lenguaje';

  @override
  String get boards => 'Boards';

  @override
  String get search => 'Buscador';

  @override
  String get search_in_board => 'Buscar en Tablero';

  @override
  String get loading_boards => 'Cargando Tableros...';

  @override
  String get not_found_boards_with_query =>
      'Ningun tablero encontrado con la consulta';

  @override
  String get not_found_boards => 'Ningun Tablero Encontrado';

  @override
  String get loading => 'Cargando';

  @override
  String get all_loaded => 'Toda la Informacion Cargada';

  @override
  String get username_is_required_message => 'Campo Username Debe llenarse';

  @override
  String get it_may_not_have_spaces => 'No Debe Contener Espacios';

  @override
  String get it_may_not_have_special_characters =>
      'No Debe Contener Caracteres Especiales';

  @override
  String get it_may_not_be_clear => 'No Debe estar Vacio';

  @override
  String get it_may_be_number => 'Debe ser un numero';

  @override
  String get invalid_authentication => 'Autenticacion Invalida';

  @override
  String get error_in_server_or_internet => 'Error en el servidor o internet';

  @override
  String get data_not_valid => 'Datos no Validos';

  @override
  String get server_connection => 'Error en la Conexion con el Servidor';

  @override
  String get username_already_exists => 'Username Ya Existe';

  @override
  String get email_already_exists => 'Email Ya Existe';

  @override
  String get created_correctly => 'Creado Correctamente';
}
