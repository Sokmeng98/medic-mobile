import 'package:flutter/material.dart';

bool rxsScreen(BuildContext context) => MediaQuery.of(context).size.height < 650;
bool xsScreen(BuildContext context) => MediaQuery.of(context).size.height >= 650;
bool rsmScreen(BuildContext context) => MediaQuery.of(context).size.height < 700;
bool smScreen(BuildContext context) => MediaQuery.of(context).size.height >= 700;
bool rmdScreen(BuildContext context) => MediaQuery.of(context).size.height < 750;
bool mdScreen(BuildContext context) => MediaQuery.of(context).size.height >= 750;
bool mdlgScreen(BuildContext context) => MediaQuery.of(context).size.height >= 750 && MediaQuery.of(context).size.height < 850;
bool rlgScreen(BuildContext context) => MediaQuery.of(context).size.height < 800;
bool lgScreen(BuildContext context) => MediaQuery.of(context).size.height >= 800;
bool rxlScreen(BuildContext context) => MediaQuery.of(context).size.height < 850;
bool xlScreen(BuildContext context) => MediaQuery.of(context).size.height >= 850;
bool r2xlScreen(BuildContext context) => MediaQuery.of(context).size.height < 950;
