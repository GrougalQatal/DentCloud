import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:muro_dentcloud/src/models/Services_models.dart';
import 'package:muro_dentcloud/src/models/business_model_gps.dart';
import 'package:muro_dentcloud/src/models/chat_model.dart';
import 'package:muro_dentcloud/src/models/follows_model.dart';
import 'package:muro_dentcloud/src/models/lista_chat_model.dart';
import 'package:muro_dentcloud/src/models/pacient_follows_model.dart';
import 'package:muro_dentcloud/src/models/search_model/business_data_search.dart';
import 'package:muro_dentcloud/src/models/search_model/contact_message.dart';
import 'package:muro_dentcloud/src/models/search_model/user_data_doctor.dart';
import 'package:muro_dentcloud/src/models/search_model/user_data_search.dart';
import 'package:muro_dentcloud/src/models/business_model.dart';

class DataProvider1{

 Future <List<UserData>> userSearch(String query)
 async {
   String url='http://54.197.83.249/PHP_REST_API/api/get/get_user_by_like.php?user_name=$query';
   final resp = await http.get(url);
   if(resp.statusCode==200)
   {
    final decodedData = json.decode(resp.body);
    final data =  UserDatas.fromJsonList(decodedData['usuarios']);
    // print(decodedData);
    // print(decodedData['usuario']);
    return data.items;
   }
 }
 


 Future<bool> deletePacienteSeguido(String correologueado,String eliminado)
async {
  String url="http://54.197.83.249/PHP_REST_API/api/delete/delete_patient_followed.php?user_email_doctor=$correologueado&user_email_patient=$eliminado";
   final resp = await http.get(url);
   if(resp.statusCode==200)
   {
      return true;
   }
   else
   {
     return false;
   }

}

 Future<List<PacientesSeguido>> getPacienteSeguido(String emailuser) async {
    String url='http://54.197.83.249/PHP_REST_API/api/get/get_patient_followed.php?email_doctor=$emailuser';
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final seguido = new PacienteSeguidosData.fromJsonList(decodedData['pacientes_seguidos']);
    return seguido.items;
 }


  static Future <List<UltimosMensaje>> getListaChat(String emailuser)
  async {
    
    String url='http://54.197.83.249/PHP_REST_API/api/get/get_recent_message.php?user_email=$emailuser';
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final listachat = new ChatData.fromJsonList(decodedData['ultimos_mensajes']);
    return listachat.items;
  }


 Future <List<Negocio>> businesSearch(String query)
 async {
   String url='http://54.197.83.249/PHP_REST_API/api/get/get_business_by_like.php?name=$query';
   final resp = await http.get(url);
   if(resp.statusCode==200)
   {
    final decodedData = json.decode(resp.body);
    final data =  BusinesData.fromJsonList(decodedData['negocios']);
    // print(decodedData);
    // print(decodedData['usuario']);
    return data.items;
   }
 }
 
 Future<List<Siguiendo>> followsearch(String emailUser, String query) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_followers_by_like.php?user_email=$emailUser&name=$query';
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final decodedData = jsonDecode(resp.body);
      // print(decodedData['siguiendo']);
      final follows = Follow.fromJsonList(decodedData['siguiendo']);
      // print('here');
      // print(follows.items.length);
      return follows.items;
    } else {
      return new List();
    }
  }
  Future <bool> ingresarMensajes(
    String emisor,String receptor,String mensaje, String fotopath)async
  {
     DateTime now = new DateTime.now();
    var url2 = Uri.parse(
        "http://54.197.83.249/PHP_REST_API/api/post/post_insert_message.php?user_email=$emisor&user_email_recep=$receptor&message_content=$mensaje&message_date=$now");
    var request = http.MultipartRequest('POST', url2);
    if (fotopath != null) {
      var pic = await http.MultipartFile.fromPath("archivo", fotopath);
      request.files.add(pic);
    }
    var response = await request.send();
    if(response.statusCode==200)
    {
     return true;
    }
    else
    {
     return false;
    }
    
  }

  Future<bool> actualizarBusines(
     String businessRuc,
      String businessName,
      String businessPhone,
      String province,
      String canton,
      String businessLocation,
      String fotopath,
      String fotourl,
      double latitud,
      double longitud
  )
  async {
    var url=Uri.parse('http://54.197.83.249/PHP_REST_API/api/put/put_business_data.php?business_ruc=$businessRuc&business_name=$businessName&business_phone=$businessPhone&province=$province&canton=$canton&business_location=$businessLocation&business_photo=$fotourl&length=$longitud&latitude=$latitud');
    var request = http.MultipartRequest('POST', url);
    if (fotopath != null) {
      var pic = await http.MultipartFile.fromPath("archivo", fotopath);
      request.files.add(pic);
    }
    var response = await request.send();
    if(response.statusCode==200)
    {
     return true;
    }
    else
    {
     return false;
    }
  }
  Future<bool> actualizarUsuario(
   String email,
   String password,
   String nombre,
   String apellido,
   DateTime fecha,
   String telefono,
   String sexo,
   String profesion,
   String provincia,
   String canton,
   String fotourl,
   String fotopath
  )
  async {
    var url=Uri.parse('http://54.197.83.249/PHP_REST_API/api/put/put_update_user.php?user_email=$email&password=$password&user_names=$nombre&user_last_names=$apellido&birthdate=$fecha&cellphone=$telefono&sex=$sexo&doctor_profession=$profesion&province_resident=$provincia&city_resident=$canton&url_photo=$fotourl');
    var request = http.MultipartRequest('POST', url);
    if (fotopath != null) {
      var pic = await http.MultipartFile.fromPath("archivo", fotopath);
      request.files.add(pic);
    }
    var response = await request.send();
    if(response.statusCode==200)
    {
     return true;
    }
    else
    {
     return false;
    }
  }

    Future<List<ChatSeleccionado>> obtenerChat(
      String sala) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_select_by_chat.php?room_id=$sala';
    final resp = await http.get(url);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    final mensaje =
        new MensajeriaData.fromJsonList(decodedData['chat_seleccionado']);
    return mensaje.items;
  }
  

  Future <bool> ingresarPreguntas(List<PreguntasFrecuente> lista, String id)
  async {
    for(var item in lista)
    {
      String url ="http://54.197.83.249/PHP_REST_API/api/post/post_frequent_questions.php?frequent_questions_service_id=$id&frequent_questions_description=${item.descripcion}&frequent_questions_reply=${item.respuesta}";
    final resp = await http.get(url);
    if(resp.statusCode!=200)
    {
      return false;
    }
    }
    return true;

  }
  
  Future<bool> actualizarPreguntas(List<PreguntasServicios> lista)
  async {
    for(var item in lista)
    {
       String url ="http://54.197.83.249/PHP_REST_API/api/put/put_frequent_questions.php?frequent_question_id=${item.preguntasFrecuenteId}&frequent_question_drescription=${item.descripcion}&frequent_question_reply=${item.respuesta}";
      final resp = await http.get(url);
     if(resp.statusCode==200)
    {
      return true;
    }
    }
    return false;

  }


  Future<List<NegocioDataGps>> negocioGps(String ciudad)
  async {
     String url ='http://54.197.83.249/PHP_REST_API/api/get/get_business_by_city.php?city=$ciudad';
     final resp = await http.get(url);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    final mensaje =
        new BusinessDataGps.fromJsonList(decodedData['negocios']);
    return mensaje.items;

  }

  Future<bool> ingresarempleado(DoctorDato doctor,String businessruc,String rol)
  async {
   String url='http://54.197.83.249/PHP_REST_API/api/post/post_doctor_works.php?user_data=${doctor.correo}&business_ruc=$businessruc&role=$rol';
  final resp = await http.get(url);
  if(resp.statusCode==200){
   return true;
  }
  return false;

  }
  Future <List<DoctorDato>> doctorSearch( String query)
  async {
     String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_doctor_by_name.php?doctor_names=$query';
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final decodedData = jsonDecode(resp.body);
      // print(decodedData['siguiendo']);
      final follows = DoctorDataPrincipal.fromJsonList(decodedData['doctor_datos']);
      return follows.items;
    } else {
      return new List();
    }

  } 

  
  
  
  Future<bool> deleteServices(String ruc, String idServicio) async {
    String url =
        'http://54.197.83.249/PHP_REST_API/api/delete/delete_business_services.php?business_ruc=$ruc&service_id=$idServicio';
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future <bool> actualizarServicios(String idServicio,String ruc, String descripcion, String duration,String fotopath, String urlImage)
  async {
    var url=Uri.parse('http://54.197.83.249/PHP_REST_API/api/put/put_business_services.php?service_id=$idServicio&service_description=$descripcion&service_duration=$duration&service_cost=10&service_business_ruc=$ruc&service_url_image=$urlImage');
    var url2=Uri.parse('http://54.197.83.249/PHP_REST_API/api/put/put_business_services.php?service_id=$idServicio&service_description=$descripcion&service_duration=$duration&service_cost=10&service_business_ruc=$ruc');
    if(fotopath!=null)
    {
      var request = http.MultipartRequest('POST', url2);
      var pic = await http.MultipartFile.fromPath("archivo", fotopath);
      request.files.add(pic);
      final streamResponse = await request.send();
      final resp = await http.Response.fromStream(streamResponse);
      if(resp.statusCode==200)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    else
    {
       var request = http.MultipartRequest('POST', url);
       final streamResponse = await request.send();
       final resp = await http.Response.fromStream(streamResponse);
       if(resp.statusCode==200)
       {
         return true;

       }
       else
       {
         return false;
       }
    }
  }
  Future <String> ingresarServicios(String ruc, String descripcion, String duration,String fotopath, String correo)
  async {
    var url=Uri.parse('http://54.197.83.249/PHP_REST_API/api/post/post_business_services.php?service_business_ruc=$ruc&service_description=$descripcion&service_duration=$duration&doctor_email=$correo');
    var request = http.MultipartRequest('POST', url);
    var pic = await http.MultipartFile.fromPath("archivo", fotopath);
    request.files.add(pic);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse);
    if(resp.statusCode!=200)
    {
      return null;
    }
    else
    {
      final respData = json.decode(resp.body);
      final service=RespIdService.fromJsonList(respData['respuesta_obtenida']);
      return service.items[0].idServicio;
    }
  }

  Future<List< ContactoElement>> listaContactoSeguido(String email,String query)
  async {
     String url =
        'http://54.197.83.249/PHP_REST_API/api/get/get_contact_by_like.php?user_email=$email&user_name=$query';
    final resp = await http.get(url);
    List<dynamic> items = new List();
    items.add(resp.body);
    final decodedData = json.decode(resp.body);
    final mensaje =
        new ContactoData.fromJsonList(decodedData['contactos']);
    return mensaje.items;

  }



}
