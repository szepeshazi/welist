import 'package:animate_do/animate_do.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'login_register_navigator.dart';

class ConfirmRegistrationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Observer(builder: (context) => Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize:
        MainAxisSize
              .min,
            children: [
            Container(
                margin: EdgeInsets.all(25),
                child: Center(child: Text("Hi there!", style: Theme.of(context).textTheme.headline4))),
            Container(margin: EdgeInsets.all(25), child: Center(child: Text('''
Welcome to WeList, the ultimate tool for sharing groceries, todo lists and more.

You are one step away to start your lists - we just need your email address confirmed.

We've sent you an E-mail with a confirmation link - please activate your account by clicking the link to continue.

                  ''', style: Theme.of(context).textTheme.bodyText1))),
            ZoomIn(child: Container(
                margin: EdgeInsets.only(bottom: 25),
                color: Theme.of(context).accentColor,
                child: FlareLoading(
                name: 'assets/flares/liquid_download.flr',
                loopAnimation: 'Indeterminate',
                startAnimation: 'Indeterminate',
                endAnimation: 'Complete',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
                until: () => Future.delayed(Duration(seconds: 5)),
                onSuccess: (_) {
                  _loginRegisterNavigator.toggleResendEmailButton(false);
                },
                onError: (err, stack) {
                  print(err);
                },
              )
            )),
            if (_loginRegisterNavigator.showResendEmailButton) Container(
                margin: EdgeInsets.only(bottom: 25),
                child: ElevatedButton(child: Text("Resend E-mail"), onPressed: () {}))
          ]),
        )),
      ),
    );
  }
}
