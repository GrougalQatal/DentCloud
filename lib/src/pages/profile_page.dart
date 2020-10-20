import 'package:flutter/material.dart';
import 'package:muro_dentcloud/src/controllers/users_ctrl.dart';
import 'package:muro_dentcloud/src/models/current_user_model.dart';
import 'package:muro_dentcloud/src/providers/data_provider.dart';
import 'package:muro_dentcloud/src/resource/preferencias_usuario.dart';
import 'package:muro_dentcloud/src/widgets/cards.dart';
import 'package:muro_dentcloud/src/widgets/drawer_appbar.dart';
import 'package:muro_dentcloud/src/widgets/horizontal_scroll_view.dart';
import 'package:muro_dentcloud/src/widgets/profile_appbar.dart';

class ProfilePage extends StatefulWidget {
  final CurrentUsuario currentuser;
  const ProfilePage({Key key, this.currentuser}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final prefs = new PreferenciasUsuario();
  final publicacionesProvider = new DataProvider();
  bool businessProfile = false;
  bool currentProfile = false;
  bool externalUserProfile = false;
  // ScrollController _scrollController = new ScrollController();
  // List<int> _publicaciones = new List();
  // int _ultimoItem = 0;
  // bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    CurrentUsuario userinfo = ModalRoute.of(context).settings.arguments;
    // print(userinfo.publicaciones);
    return Scaffold(
      drawer: NavDrawer(),
      body: FutureBuilder(
          future: publicacionesProvider
              .getPublicacionesByUser(userinfo.publicaciones),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            return CustomScrollView(
              slivers: [
                ProfileAppBar(
                  userinfo: userinfo,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  sliver: SliverToBoxAdapter(
                    child: prefs.thisProfileType == true && prefs.thisProfileType == true
                      ? Rooms(userinfo: userinfo)
                      : Container()
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 10,
                  ),
                ),
                publicaciones(userinfo, _screenSize, snapshot),

                // SliverPublicaciones(),
              ],
            );
          }),
    );
  }

  Widget publicaciones(
      CurrentUsuario userinfo, Size _screenSize, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
        print(snapshot.data.length);
        return CardWidgetPublicaciones(publicaciones: snapshot.data, id: index);
      }, childCount: snapshot.data.length));
    } else {
      return SliverToBoxAdapter(
        child: Container(
          height: _screenSize.height * 4,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
