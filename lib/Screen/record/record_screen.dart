// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/Screen/record/record_detail_page.dart';
import 'package:project_attendance_app/bloc/record_bloc.dart';
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

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  Future<void> logout() async {
    await RememberUserPrefs.clearUserInfo();
    await RememberRecordPrefs.clearRememberAbsensi();
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 250,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      headerDivider: divider,
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.only(top: 33),
          child: Text(
            "Absen Aja!",
            style: TextStyle(
                fontSize: 38, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.security,
          label: 'Akun',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.nightlight,
          label: 'Tema',
        ),
        const SidebarXItem(
          icon: Icons.info,
          label: 'Tentang Kami',
        ),
        SidebarXItem(icon: Icons.logout, label: 'Keluar', onTap: logout),
        const SidebarXItem(
          iconWidget: FlutterLogo(size: 20),
          label: 'Flutter',
        ),
      ],
      footerDivider: divider,
      footerBuilder: ((context, extended) {
        return Text(
          "Created By: Militan",
          style: TextStyle(
            color: Colors.white,
          ),
        );
      }),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return const UserPage();
          case 1:
            return const RecordDetailPage();
            return UserPage();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const canvasColor = Color(0xff3977ff);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color.fromARGB(255, 19, 41, 87);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(
  color: white.withOpacity(0.3),
  height: 5,
  thickness: 1,
);

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
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda ingin meninggalkan aplikasi?'),
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
                    backgroundColor: canvasColor,
                    title: Text(
                      _getTitleByIndex(_controller.selectedIndex),
                      style: TextStyle(color: Colors.white),
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
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
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
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              } else {
                Siswa user = snapshot.data!['user'];
                List<RecordAbsen> absensiToCard = snapshot.data!['absensi'];
                return BlocProvider(
                  create: (context) => RecordBloc()..add(LoadRecordEvent()),
                  child: BlocBuilder<RecordBloc, RecordState>(
                    builder: (context, state) {
                      if (state is RecordLoading) {
                        return Center(child: CircularProgressIndicator());
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
                          Settings(histories: (state.record)),
                          Settings(histories: state.record),
                        ].toColumn().parent(page);
                      } else {
                        return Center(child: Text('No data available'));
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
      const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('images/art.png'),
      ).padding(top: 5, right: 10),
      <Widget>[
        Text(
          user.nis,
          style: TextStyle(
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
      switch (record.kodeKeterangan) {
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
          child: Text("Lihat Detail >>"),
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
            color: Color(0xff3977ff), borderRadius: BorderRadius.circular(20))
        .elevation(
          5,
          shadowColor: Color(0xff3977ff),
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
      child: Icon(icon, size: 20, color: Color(0xFF42526F))
          .alignment(Alignment.center)
          .ripple()
          .constrained(width: 50, height: 50)
          .backgroundColor(Color(0xfff6f5f8))
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
        Text(

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
  final List<RecordAbsen> histories;
  const Settings({super.key, required this.histories});

  @override
  Widget build(BuildContext context) {
    List<SettingsItemModel> setItem = histories.map((history) {
    List<SettingsItemModel?> setItem = histories.map((history) {

      switch (history.kodeKeterangan) {
        case 'HD':
          return SettingsItemModel(
            icon: Icons.co_present,
            color: Color(0xff8D7AEE),
            title: 'Hadir',
            description: 'Tanggal: ' + history.kalenderAbsensi.toString(),
          );
        case 'SK':
          return SettingsItemModel(
            icon: Icons.sick,
            color: Color(0xffF468B7),
            title: 'Sakit',
            description: 'Tanggal: ' + history.kalenderAbsensi.toString(),
          );
        case 'ZN':
          return SettingsItemModel(
            icon: Icons.receipt,
            color: Color(0xffFEC85C),
            title: 'Izin',
            description: 'Tanggal: ' + history.kalenderAbsensi.toString(),
          );
        case 'PH':
          return SettingsItemModel(
            icon: Icons.close,
            color: Color(0xff5FD0D3),
            title: 'Alpha',
            description: 'Tanggal: ' + history.kalenderAbsensi.toString(),
          );

        default:
          return SettingsItemModel(
            icon: Icons.co_present,
            color: Color(0xff8D7AEE),
            title: 'Hadir',
            description: 'Tanggal: ' + history.kalenderAbsensi.toString(),
          );
      }
    }).toList();
    return (setItem
        .map((settingsItem) => SettingsItem(

              settingsItem.icon,
              settingsItem!.icon,

              settingsItem.color,
              settingsItem.title,
              settingsItem.description,
            ))
        .toList()
        .toColumn());
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
        .backgroundColor(Colors.white, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
          pressed ? 0 : 20,
          borderRadius: BorderRadius.circular(25),
          shadowColor: Color(0x30000000),
        ) // shadow borderRadius
        .constrained(height: 80)
        .padding(vertical: 12) // margin
        .gestures(
          onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
          onTapDown: (details) => print('tapv Down'),
          onTap: () => print('onTap'),
        )
        .scale(all: pressed ? 0.95 : 1.0, animate: true)
        .animate(Duration(milliseconds: 150), Curves.easeOut);

    final Widget icon = Icon(widget.icon, size: 20, color: Colors.white)
        .padding(all: 12)
        .decorated(
          color: widget.iconBgColor,
          borderRadius: BorderRadius.circular(30),
        )
        .padding(left: 15, right: 10);

    final Widget title = Text(
      widget.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);

    final Widget description = Text(
      widget.description,
      style: TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
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
