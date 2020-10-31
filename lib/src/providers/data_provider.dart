import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:muro_dentcloud/src/models/apointments_model.dart';
import 'package:muro_dentcloud/src/models/business_model.dart';
import 'package:muro_dentcloud/src/models/current_user_model.dart';
import 'package:muro_dentcloud/src/models/drougs_model.dart';
import 'package:muro_dentcloud/src/models/follows_model.dart';
import 'package:muro_dentcloud/src/models/list_message_model.dart';
import 'package:muro_dentcloud/src/models/publications_model.dart';
import 'package:muro_dentcloud/src/models/search_contact_model.dart';
import 'package:muro_dentcloud/src/resource/preferencias_usuario.dart';

class DataProvider {
  // String _apiKey = '';
  String _url = '54.197.83.249';
  // String _language = 'es-ES';
  //! PROVIDER DE TODAS LAS PRUBLICACIONES
  //? Future que espera la respuesta del http para seguir con la ejecucion.
  Future<List<Publicacion>> getPublicaciones() async {
    final url = Uri.http(_url, 'PHP_REST_API/api/get/get_publications.php');
    //? Solicitud http.get + url
    final resp = await http.get(url);
    //? decodificacion de la data json.decode
    final decodedData = json.decode(resp.body);
    // print(decodedData);
    final publicaciones =
        new Publicaciones.fromJsonList(decodedData['publicaciones']);
    // print(publicaciones.items[0].usuario);
    // print(publicaciones.items);
    return publicaciones.items;
  }

  Future<List<Publicacion>> getPublicacionesByUser(
      List<UserPublicacion> id) async {
    List<Publicacion> public = new List();
    for (var pub in id) {
      // print(pub);
      // print(pub.idPublicacion);
      String url =
          'http://54.197.83.249/PHP_REST_API/api/get/get_publications_by_id.php?id_publication=${pub.idPublicacion}';
      final resp = await http.get(url);
      // print(resp);
      //? decodificacion de la data json.decode
      final decodedData = json.decode(resp.body);
      final publicaciones =
          new PublicacionesByUser.fromJsonList(decodedData['publicaciones']);
      public..add(publicaciones.items[0]);
      // print(publicaciones.items[0]);
    }
    // print(public);
    return public;
  }

  Future<List<Publicacion>> getPublicacionesByRuc(
      List<PublicacionesNegocio> id) async {
    List<Publicacion> public = new List();
    for (var pub in id) {
      // print(pub);
      // print(pub.idPublicacion);
      String url =
          'http://54.197.83.249/PHP_REST_API/api/get/get_publications_by_id.php?id_publication=${pub.idPublicacion}';
      final resp = await http.get(url);
      // print(resp);
      //? decodificacion de la data json.decode
      final decodedData = json.decode(resp.body);
      final publicaciones =
          new PublicacionesByUser.fromJsonList(decodedData['publicaciones']);
      public..add(publicaciones.items[0]);
      // print(publicaciones.items[0]);
    }
    // print(public);
    return public;
  }

  //!PROVIDER DE DATOS PARA LA AGENDA
  Future<List<EventModel>> eventosPorCorreo(emailDoctor) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_accepted_appointmen_by_doctor.php?email_doctor=$emailDoctor';

    final resp = await http.get(url);
    print(resp);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    // print(decodedData);
    final eventos = new Eventos.fromJsonList(decodedData['cita_acceptada']);

    return eventos.items;
  }

  Future<bool> loginUsuario(String email, String password) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_select_by_login.php?user_email=$email&password=$password';
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      String url2 =
          'http://54.197.83.249/PHP_REST_API/api/get/get_user_data_principal.php?user_email=$email';
      final resp2 = await http.get(url2);
      final decodedData = json.decode(resp2.body);
      CurrentUsuarios.fromJsonList(decodedData['usuario']);
      // print(decodedData);
      final currentUserData = new PreferenciasUsuario();
      currentUserData.currentCorreo = email;
      currentUserData.currentPassword = password;
      return true;
    } else {
      return false;
    }
  }

  Future<List<CurrentUsuario>> userData(String email) async {
    String url2 =
        'http://54.197.83.249/PHP_REST_API/api/get/get_user_data_principal.php?user_email=$email';
    final resp2 = await http.get(url2);
    final decodedData = json.decode(resp2.body);
    final data = CurrentUsuarios.fromJsonList(decodedData['usuario']);
    // print(decodedData);
    // print(decodedData['usuario']);
    return data.items;
  }

  Future<List<NegocioData>> businessData(String ruc) async {
    String url2 =
        'http://54.197.83.249/PHP_REST_API/api/get/get_business_data_by_ruc.php?business_ruc=$ruc';
    final resp2 = await http.get(url2);
    final decodedData = json.decode(resp2.body);
    final data = Business.fromJsonList(decodedData['negocio_datos']);
    print(decodedData['negocio_datos']);
    print(data.items);
    // print(decodedData['usuario']);
    return data.items;
  }

  Future<bool> registrarEventos(String ruc, String email, String user,
      String name, String description, String date) async {
    String url2 =
        "http://54.197.83.249/PHP_REST_API/api/post/post_medical_appointment.php?business_ruc=$ruc&user_email_doctor=$email&user_email_patient=$user&business_service_name=$name&commentary=$description&date_time=$date";
    final resp = await http.get(url2);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ListaChat>> getListChat(emailuser) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_list_message_content.php?user_email=$emailuser';
    final resp = await http.get(url);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    final listachat = new ListaChatData.fromJsonList(decodedData['lista_chat']);
    return listachat.items;
  }

  Future<List<BusquedaNombre>> buscar_chat(emailuser, String query) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_contact_by_name.php?user_email=$emailuser&busqueda=$query';
    final resp = await http.get(url);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    final busqueda = new Busqueda.fromJsonList(decodedData['busqueda_nombre']);
    return busqueda.items;
  }

  Future<List<Siguiendo>> follow(String emailUser) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_followers_by_user.php?user_email=$emailUser';
    final resp = await http.get(url);

    final decodedData = jsonDecode(resp.body);
    // print(decodedData['siguiendo']);
    final follows = Follow.fromJsonList(decodedData['siguiendo']);
    // print('here');
    // print(follows.items.length);
    return follows.items;
  }

  Future<List<Medicamento>> drougs(String medicina) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_drug_data.php?drug_name=$medicina';
    final resp = await http.get(url);
    final decodedData = jsonDecode(resp.body);
    final drougs = Drougs.fromJsonList(decodedData['medicamento']);
    return drougs.items;
  }



  Future<List<Siguiendo>> follow_search(String emailUser,String query) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_followers_by_like.php?user_email=$emailUser&name=$query';
    final resp = await http.get(url);
   
   if(resp.statusCode==200)
   {
     final decodedData = jsonDecode(resp.body);
    // print(decodedData['siguiendo']);
    final follows = Follow.fromJsonList(decodedData['siguiendo']);
    // print('here');
    // print(follows.items.length);
    return follows.items;

   }
   else
   {
     return new List();
   }
    
  }
}
