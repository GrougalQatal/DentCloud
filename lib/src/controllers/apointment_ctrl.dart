import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muro_dentcloud/src/models/event_model.dart';

class EventosCtrl {
  static Future<List<EventosModelo>> listarEventos(String emailDoctor) async {
    final response = await http.get(
        "http://54.197.83.249/PHP_REST_API/api/get/get_accepted_appointmen_by_doctor.php?email_doctor=$emailDoctor");
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['cita_acceptada']
          .map<EventosModelo>((json) => EventosModelo.fromJson(json))
          .toList();
    }
    return null;
  }

  static Future<List<EventosModeloUsuario>> listarEventosUsuarios(
      String emailUsuario) async {
    final response = await http.get(
        "http://54.197.83.249/PHP_REST_API/api/get/get_accepted_appointmen_by_patients.php?email_patients=$emailUsuario");
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['cita_acceptada']
          .map<EventosModeloUsuario>(
              (json) => EventosModeloUsuario.fromJson(json))
          .toList();
    }
    return null;
  }

  static Future<List<EventosModeloHold>> listarEventosPendientes(
      String emailDoctor) async {
    final response = await http.get(
        "http://54.197.83.249/PHP_REST_API/api/get/get_on_hold_appointment_by_doctor.php?email_doctor=$emailDoctor");
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
      return parsed['cita_en_espera']
          .map<EventosModeloHold>((json) => EventosModeloHold.fromJson(json))
          .toList();
    }
    return null;
  }

  static Future<bool> registrarEventos(
      String ruc,
      String emailDoc,
      String emailUser,
      String service,
      String descripcion,
      DateTime fecha) async {
    final response = await http.post(
        "http://54.197.83.249/PHP_REST_API/api/post/post_medical_appointment.php?business_ruc=$ruc&user_email_doctor=$emailDoc&user_email_patient=$emailUser&business_service=$service&commentary=$descripcion&date_time=$fecha");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> actualizarEventosApproved(
      String id, DateTime fecha) async {
    final response = await http.post(
        "http://54.197.83.249/PHP_REST_API/api/put/put_appointment_state.php?id_appointment=$id&state=approved&date_time=$fecha");
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Si");
      return true;
    } else {
      print(response.statusCode);
      print("No");
      return false;
    }
  }

  static Future<bool> actualizarEventosDatos(
      String id, String idservicio, DateTime fecha) async {
    final response = await http.post(
        "http://54.197.83.249/PHP_REST_API/api/put/put_appointment.php?id_appointment=$id&business_service=$idservicio&date_time=$fecha");
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Si");
      return true;
    } else {
      print(response.statusCode);
      print("No");
      return false;
    }
  }

  static Future<bool> actualizarEventosDenied(String id) async {
    DateTime time = new DateTime.now();
    final response = await http.post(
        "http://54.197.83.249/PHP_REST_API/api/put/put_appointment_state.php?id_appointment=$id&state=denied");
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Si");
      return true;
    } else {
      print(response.statusCode);
      print("No");
      return false;
    }
  }
}
