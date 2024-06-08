// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/bar_chart.dart';
import 'package:project_attendance_app/Screen/record/chart.dart';
import 'package:project_attendance_app/Screen/record/indicator.dart';
import 'package:project_attendance_app/Screen/record/record_detail_page.dart';
import 'package:project_attendance_app/bloc/record_bloc.dart';
import 'package:project_attendance_app/coba.dart';
import 'package:project_attendance_app/user/authentication/login_layout.dart';
import 'package:project_attendance_app/user/fragments/detail_absen.dart';
import 'package:project_attendance_app/user/fragments/profile_screen.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:styled_widget/styled_widget.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda ingin meninggalkan aplikasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Iya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: Colors.blue,
                    title: Text(
                      'Dashboard',
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          _key.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : null,
            drawer: DrawerNavigation(),
            body: UserPage(),
          );
        },
      ),
    );
  }
}

// Scaffold(
//   appBar: AppBar(
//     leading: Padding(
//       padding: EdgeInsets.only(left: 20.0),
//       child: IconButton(
//         onPressed: () {},
//         icon: SvgPicture.asset(
//           'images/burger.svg',
//         ),
//       ),
//     ),
//     backgroundColor: Color(0xff3977ff),
//     title: Text(
//       "Home",
//       style: TextStyle(color: Colors.white),
//     ),
//   ),
//   body: SafeArea(child: UserPage()),
// );

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  Future<Map<String, dynamic>> getUserAndAbsensi() async {
    final results = await Future.wait([
      RememberUserPrefs.readUserInfo(),
      RememberRecordPrefs.getRememberAbsensi(),
    ]);

    Object user = results[0] ??
        Siswa(
            nis: '',
            siswaPassword: '',
            nama: '',
            tmpt_lahir: '',
            tgl_lahir: '',
            alamat: '',
            phone: '');
    Object absensi = results[1] ?? [];

    return {
      'user': user,
      'absensi': absensi,
    };
  }

  void handleActionSelected(BuildContext context, String actionName) {
    BlocProvider.of<RecordBloc>(context).add(FilterRecordEvent(actionName));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    final page = ({required Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();

    return GetBuilder(
        init: CurrentUser(),
        initState: (CurrentUser) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return FutureBuilder<Map<String, dynamic>>(
            future: getUserAndAbsensi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                Siswa user = snapshot.data!['user'];
                List<RecordAbsen> absensiToCard = snapshot.data!['absensi'];
                return BlocProvider(
                  create: (context) => RecordBloc()..add(LoadRecordEvent()),
                  child: BlocBuilder<RecordBloc, RecordState>(
                    builder: (context, state) {
                      if (state is RecordLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecordError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is RecordLoaded) {
                        return <Widget>[
                          UserCard(
                            user: user,
                            histories: absensiToCard,
                          ),
                          ActionsRow(
                            onActionSelected: (actionName) =>
                                handleActionSelected(context, actionName),
                          ),
                          <Widget>[
                            const <Widget>[
                              Text(
                                'Record',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              PieChartSample3(),
                            ]
                                .toColumn(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround)
                                .padding(horizontal: 20, vertical: 10)
                                .decorated(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20))
                                .elevation(
                                  5,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                )
                                .alignment(Alignment.topCenter),
                            const SizedBox(
                              height: 25,
                            ),
                            const <Widget>[
                              Text(
                                'Record',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              BarChartRecord(),
                            ]
                                .toColumn(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround)
                                .padding(horizontal: 20, vertical: 10)
                                .decorated(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20))
                                .elevation(
                                  5,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                )
                                .alignment(Alignment.topCenter),
                            const SizedBox(
                              height: 25,
                            ),
                            <Widget>[
                              <Widget>[
                                const Indicator(
                                  color: Color(0xff5FD0D3),
                                  text: 'Hadir',
                                  isSquare: false,
                                ),
                                const Indicator(
                                  color: Color(0xff8D7AEE),
                                  text: 'Sakit',
                                  isSquare: false,
                                ),
                                const Indicator(
                                  color: Color(0xffFEC85C),
                                  text: 'Izin',
                                  isSquare: false,
                                ),
                                const Indicator(
                                  color: Color(0xffF468B7),
                                  text: 'Alpha',
                                  isSquare: false,
                                ),
                              ].toRow(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround),
                            ]
                                .toColumn(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround)
                                .padding(horizontal: 20, vertical: 10)
                                .decorated(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20))
                                .elevation(
                                  5,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                )
                                .alignment(Alignment.topCenter),
                          ].toColumn().parent(page),
                        ].toColumn().parent(page);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              }
            },
          );
        });
  }
}

class UserCard extends StatefulWidget {
  final Siswa user;
  final histories;
  const UserCard({super.key, required this.user, required this.histories});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Widget _buildUserRow(Siswa user) {
    return <Widget>[
      GestureDetector(
        onTap: () {
          Get.to(() => const ProfileScreen());
        },
        child: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('images/art.png'),
        ).padding(top: 5, right: 10),
      ),
      <Widget>[
        Text(
          user.nis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: 5),
        Text(
          user.nama,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow();
  }

  Widget _buildUserStats(List<RecordAbsen> histories) {
    int hadir = 0;
    int sakit = 0;
    int izin = 0;
    int alpha = 0;

    for (var record in histories) {
      switch (record.kd_ket) {
        case 'HD':
          hadir++;
          break;
        case 'SK':
          sakit++;
          break;
        case 'ZN':
          izin++;
          break;
        case 'PH':
          alpha++;
          break;
      }
    }

    return <Widget>[
      _buildUserStatsItem(hadir.toString(), 'Hadir'),
      _buildUserStatsItem(sakit.toString(), 'Sakit'),
      _buildUserStatsItem(izin.toString(), 'Izin'),
      _buildUserStatsItem(alpha.toString(), 'Alpha'),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) => <Widget>[
        Text(value).fontSize(20).textColor(Colors.white).padding(bottom: 5),
        Text(text).textColor(Colors.white.withOpacity(0.6)).fontSize(12),
      ].toColumn();

  Widget _buildProfileViewButton() {
    return <Widget>[
      ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => const DetailAbsen()));
          },
          child: const Text("Lihat Detail >>"),
          style: ElevatedButton.styleFrom(side: BorderSide.none)),
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      _buildUserRow(widget.user),
      _buildUserStats(widget.histories),
      _buildProfileViewButton()
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(horizontal: 20, vertical: 10)
        .decorated(
            color: const Color(0xff3977ff),
            borderRadius: BorderRadius.circular(20))
        .elevation(
          5,
          shadowColor: const Color(0xff3977ff),
          borderRadius: BorderRadius.circular(20),
        )
        .alignment(Alignment.center);
  }
}

class ActionsRow extends StatelessWidget {
  final Function(String) onActionSelected;

  ActionsRow({required this.onActionSelected});

  Widget _buildActionItem(String name, IconData icon) {
    final Widget actionIcon = GestureDetector(
      onTap: () {
        switch (name) {
          case "Hadir":
            onActionSelected('HD');
            break;
          case "Sakit":
            onActionSelected('SK');
            break;
          case "Izin":
            onActionSelected('ZN');
            break;
          case "Alpha":
            onActionSelected('PH');
            break;
        }
      },
      child: Icon(icon, size: 20, color: const Color(0xFF42526F))
          .alignment(Alignment.center)
          .ripple()
          .constrained(width: 50, height: 50)
          .backgroundColor(const Color(0xfff6f5f8))
          .clipOval()
          .padding(bottom: 5),
    );

    final Widget actionText = Text(
      name,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 12,
      ),
    );

    return <Widget>[
      actionIcon,
      actionText,
    ].toColumn().padding(bottom: 15);
  }

  @override
  Widget build(BuildContext context) => <Widget>[
        const Text(
          'Hanya tampilkan: ',
          style: TextStyle(
            color: Color(0xFF42526F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).padding(vertical: 15, left: 20),
        [
          _buildActionItem(
            'Hadir',
            Icons.co_present,
          ),
          _buildActionItem('Sakit', Icons.sick),
          _buildActionItem('Izin', Icons.receipt),
          _buildActionItem('Alpha', Icons.close),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
}
