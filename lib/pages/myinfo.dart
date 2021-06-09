import 'package:flutter/material.dart';
import 'package:flutter_study/util/themeutil.dart';

class MyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> {
  Color themeColor = ThemeUtils.currentColorTheme;
  var titleTextStyle = TextStyle(fontSize: 16.0);
  var titles = [" 账户", " 帮助", " 推荐扫描AI", " 关于我们", " 设置"];

  var userAvatar;
  var userName;
  var icons = [
    Icon(Icons.account_circle),
    Icon(Icons.help_outline),
    Icon(Icons.thumb_up_outlined),
    Icon(Icons.supervisor_account_outlined),
    Icon(Icons.settings_outlined)
  ];

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      itemCount: titles.length * 2,
      itemBuilder: (context, i) => renderRow(i),
    );
    return listView;
  }

  renderRow(i) {
    final tiles = titles.map(
      (title) {
        return new ListTile(
          title: new Text(title, style: TextStyle(fontSize: 16.0)),
        );
      },
    );

    if (i == 0) {
      var avatarContainer = Container(
        color: themeColor,
        height: 200.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? Image.asset(
                      "lib/assets/images/myinfo/ic_avatar_default.png",
                      width: 60.0,
                    )
                  : Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: NetworkImage(userAvatar), fit: BoxFit.cover),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
              Text(
                userName == null ? "点击头像登录" : userName,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
      return GestureDetector(
        onTap: () {
          // DataUtils.isLogin().then((isLogin) {
          //   if (isLogin) {
          //     // 已登录，显示用户详细信息
          //     _showUserInfoDetail();
          //   } else {
          //     // 未登录，跳转到登录页面
          //     _login();
          //   }
          // });
          Navigator.pushNamed(context, "login");
        },
        child: avatarContainer,
      );
    }
    --i;
    if (i.isOdd) {
      return Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;
    String title = titles[i];
    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        children: <Widget>[
          icons[i],
          Expanded(
              child: Text(
            title,
            style: titleTextStyle,
          )),
          Icon(Icons.chevron_right),
        ],
      ),
    );
    return InkWell(
      child: listItemContent,
      onTap: () {
        // _handleListItemClick(title);
//        Navigator
//            .of(context)
//            .push(MaterialPageRoute(builder: (context) => CommonWebPage(title: "Test", url: "https://my.oschina.net/u/815261/blog")));
      },
    );
  }
}
