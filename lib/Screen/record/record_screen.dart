// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_detail_page.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/bloc/record_bloc/record_bloc.dart';
import 'package:project_attendance_app/bloc/theme_bloc/app_colors.dart';
import 'package:project_attendance_app/bloc/theme_bloc/theme_bloc.dart';
import 'package:project_attendance_app/coba.dart';
import 'package:project_attendance_app/user/authentication/login_layout.dart';
import 'package:project_attendance_app/user/fragments/detail_absen.dart';
import 'package:project_attendance_app/user/fragments/profile_screen.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/service/guru_service.dart';
import 'package:project_attendance_app/user/userPreferences/current_siswa.dart';
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';
import 'package:project_attendance_app/user/userPreferences/siswa_preference.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:http/http.dart' as http;

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
                    backgroundColor: Theme.of(context)
                        .appBarTheme
                        .backgroundColor, // Use theme here
                    title: Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          _key.currentState?.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context)
                              .appBarTheme
                              .foregroundColor, // Use theme here
                        ),
                      ),
                    ),
                  )
                : null,
            drawer: DrawerNavigation(),
            body: UserPage(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Dispatch the ToggleThemeEvent when the button is pressed
                context.read<ThemeBloc>().add(ToggleThemeEvent());
              },
              child: Icon(Icons.brightness_medium),
              backgroundColor: Theme.of(context).primaryColor, // Use theme here
            ),
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
  final CurrentSiswa _rememberCurrentSiswa = Get.put(CurrentSiswa());

  Future<Map<String, dynamic>> getUser() async {
    final results = await Future.wait([
      RememberUserPrefs.readUserInfo(),
    ]);

    print(results);

    Object user = results[0] ??
        // Siswa(
        //     nis: '',
        //     siswaPassword: '',
        //     nama: '',
        //     tmpt_lahir: '',
        //     tgl_lahir: '',
        //     alamat: '',
        //     phone: '',
        //     role: '');
        Guru(
          nip: '',
          nik: '',
          nuptk: '',
          nama: '',
          jkel: '',
          alamat: '',
          tmpt_lahir: '',
          tgl_lahir: '',
          guru_status: '',
          phone: '',
          agama: '',
          guru_password: '',
          guru_email: '',
          verifikasi_kode: '',
          role: '',
        );
    return {
      'user': user,
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
        init: CurrentSiswa(),
        initState: (CurrentSiswa) {
          _rememberCurrentSiswa.getUserInfo();
        },
        builder: (controller) {
          return FutureBuilder<Map<String, dynamic>>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                return BlocProvider(
                  create: (context) => RecordBloc()..add(LoadRecordEvent()),
                  child: BlocBuilder<RecordBloc, RecordState>(
                    builder: (context, state) {
                      if (state is RecordLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecordError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is RecordLoaded) {
                        return Scaffold(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          body: <Widget>[
                            UserCard(
                              user: snapshot.data!['user'],
                            ),
                            ActionsRow(
                              onActionSelected: (actionName) =>
                                  handleActionSelected(context, actionName),
                            ),
                            Settings(
                              user: snapshot.data!['user'],
                            ),
                          ].toColumn().parent(page),
                        );
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
  final User user;

  UserCard({Key? key, required this.user}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late Future<List<String>> data;

  @override
  void initState() {
    super.initState();
    data = UserService.getCountRecordsInfo(widget.user);
  }

  Widget _buildUserRow(User user) {
    String id;
    String name;

    if (user is Guru) {
      id = user.nip;
      name = user.nama;
    } else if (user is Siswa) {
      id = user.nis;
      name = user.nama;
    } else {
      // Handle unknown user type
      throw Exception('Unknown user type');
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => const ProfileScreen());
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('images/art.png'),
          ).padding(top: 5, right: 10),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ).padding(bottom: 5),
            Text(
              id,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserStats(List<String> records) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildUserStatsItem(records[0], 'Hadir'),
        _buildUserStatsItem(records[1], 'Sakit'),
        _buildUserStatsItem(records[2], 'Izin'),
        _buildUserStatsItem(records[3], 'Alpha'),
      ],
    ).padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ).padding(bottom: 5),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _buildProfileViewButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
      },
      child: const Text("Lihat Profil >>"),
      style: ElevatedButton.styleFrom(side: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // atau widget loading lainnya
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUserRow(widget.user),
              _buildUserStats(snapshot.data!),
              _buildProfileViewButton(),
            ],
          )
              .padding(horizontal: 20, vertical: 10)
              .decorated(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              )
              .elevation(
                5,
                shadowColor: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}

class ActionsRow extends StatelessWidget {
  final Function(String) onActionSelected;

  ActionsRow({required this.onActionSelected});

  Widget _buildActionItem(String name, IconData icon, BuildContext context) {
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
      child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.tertiary)
          .alignment(Alignment.center)
          .ripple()
          .constrained(width: 50, height: 50)
          .backgroundColor(
            Theme.of(context).colorScheme.secondaryContainer,
          )
          .clipOval()
          .padding(bottom: 5),
    );

    final Widget actionText = Text(
      name,
      style: Theme.of(context).textTheme.labelSmall,
    );

    return <Widget>[
      actionIcon,
      actionText,
    ].toColumn().padding(bottom: 15);
  }

  @override
  Widget build(BuildContext context) => <Widget>[
        Text(
          'Hanya tampilkan: ',
          style: Theme.of(context).textTheme.titleSmall,
        ).padding(vertical: 15, left: 20),
        [
          _buildActionItem('Hadir', Icons.co_present, context),
          _buildActionItem('Sakit', Icons.sick, context),
          _buildActionItem('Izin', Icons.receipt, context),
          _buildActionItem('Alpha', Icons.close, context),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
}

class SettingsItemModel {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const SettingsItemModel({
    required this.color,
    required this.description,
    required this.icon,
    required this.title,
  });
}

const List<SettingsItemModel> settingsItems = [
  SettingsItemModel(
    icon: Icons.co_present,
    color: Color(0xff8D7AEE),
    title: 'Hadir',
    description: 'Ensure your harvesting address',
  ),
  SettingsItemModel(
    icon: Icons.sick,
    color: Color(0xffF468B7),
    title: 'Sakit',
    description: 'System permission change',
  ),
  SettingsItemModel(
    icon: Icons.receipt,
    color: Color(0xffFEC85C),
    title: 'Izin',
    description: 'Basic functional settings',
  ),
  SettingsItemModel(
    icon: Icons.close,
    color: Color(0xff5FD0D3),
    title: 'Alpa',
    description: 'Take over the news in time',
  ),
];

class Settings extends StatelessWidget {
  User user;
  Settings({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecordAbsen>>(
      future: UserService.getTopFiveRecords(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Atau widget lain untuk menampilkan proses loading
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<RecordAbsen>? histories = snapshot.data;
          if (histories != null && histories.isNotEmpty) {
            List<SettingsItemModel> setItem = histories.map((history) {
              switch (history.kd_ket) {
                case 'HD':
                  return SettingsItemModel(
                    icon: Icons.co_present,
                    color: const Color(0xff8D7AEE),
                    title: 'Hadir',
                    description: 'Tanggal: ' + history.record.toString(),
                  );
                case 'SK':
                  return SettingsItemModel(
                    icon: Icons.sick,
                    color: const Color(0xffF468B7),
                    title: 'Sakit',
                    description: 'Tanggal: ' + history.record.toString(),
                  );
                case 'ZN':
                  return SettingsItemModel(
                    icon: Icons.receipt,
                    color: const Color(0xffFEC85C),
                    title: 'Izin',
                    description: 'Tanggal: ' + history.record.toString(),
                  );
                case 'PH':
                  return SettingsItemModel(
                    icon: Icons.close,
                    color: const Color(0xff5FD0D3),
                    title: 'Alpha',
                    description: 'Tanggal: ' + history.record.toString(),
                  );
                default:
                  return SettingsItemModel(
                    icon: Icons.co_present,
                    color: const Color(0xff8D7AEE),
                    title: 'Hadir',
                    description: 'Tanggal: ' + history.record.toString(),
                  );
              }
            }).toList();

            return Column(
              children: setItem
                  .map((settingsItem) => SettingsItem(
                        settingsItem.icon,
                        settingsItem.color,
                        settingsItem.title,
                        settingsItem.description,
                      ))
                  .toList(),
            );
          } else {
            return Text('Tidak ada data absensi');
          }
        }
      },
    );
  }
}

class SettingsItem extends StatefulWidget {
  SettingsItem(this.icon, this.iconBgColor, this.title, this.description);

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    settingsItem({required Widget child}) => Styled.widget(child: child)
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Theme.of(context).colorScheme.tertiaryContainer,
            animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
          pressed ? 0 : 20,
          borderRadius: BorderRadius.circular(25),
          shadowColor: const Color(0x30000000),
        ) // shadow borderRadius
        .constrained(height: 80)
        .padding(vertical: 12) // margin
        .gestures(
          onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
          onTapDown: (details) => print('tapv Down'),
          onTap: () => print('onTap'),
        )
        .scale(all: pressed ? 0.95 : 1.0, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);

    final Widget icon =
        Icon(widget.icon, size: 20, color: Theme.of(context).canvasColor)
            .padding(all: 12)
            .decorated(
              color: widget.iconBgColor,
              borderRadius: BorderRadius.circular(30),
            )
            .padding(left: 15, right: 10);

    final Widget title = Text(
      widget.title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);

    final Widget description = Text(
      widget.description,
      style: Theme.of(context).textTheme.labelSmall,
    );

    return settingsItem(
      child: <Widget>[
        icon,
        <Widget>[
          title,
          description,
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
    );
  }
}
