import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));

class MyUser {
  String name; String acc; double balance;
  MyUser(this.name, this.acc, this.balance);
}
class Tx {
  String title; double amount; String date; bool isIn;
  Tx(this.title, this.amount, this.date, this.isIn);
}
class Bank {
  static Map<String, MyUser> users = {
    "02021157564001311000": MyUser("محمد عبدالله النعيم محمد", "02021157564001311000", 64000),
    "02040104392001310100": MyUser("اسعد محمود نور الهادي مرزوق", "02040104392001310100", 125000),
    "02201548226001311100": MyUser("ادخار فتح الحسابات عن بعد", "02201548226001311100", 50000),
    "02021157564": MyUser("محمد عبدالله النعيم محمد", "02021157564", 64000),
  };
  static List<Tx> txs = [
    Tx("عمولة خدمة العميل", 500, "2026-11-12", false),
    Tx("تسديد فاتورة كهرباء", 13500, "2026-11-12", false),
    Tx("تحويل وارد", 15000, "2026-11-12", true),
  ];
  static List<String> notifications = [];
  static MyUser? current;
  static String lastRef = "101628000251706403";
  static void notify(String msg) { notifications.insert(0, msg); }
}
Widget rtl(Widget w) => Directionality(textDirection: TextDirection.rtl, child: w);

class Splash extends StatefulWidget { @override State<Splash> createState() => _SplashState(); }
class _SplashState extends State<Splash> {
  @override
  void initState() { super.initState(); Timer(Duration(seconds: 2), () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => rtl(Login()))); }); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF0A2E1F), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 90, height: 90, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF1DB954), Color(0xFFFFD600)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Center(child: Text("O", style: TextStyle(color: Color(0xFF0A2E1F), fontSize: 65, fontWeight: FontWeight.w900)))),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("اوو-كاش", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)), Text("O-CASH", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1))]),
      ]),
      SizedBox(height: 30), CircularProgressIndicator(color: Colors.white),
    ])));
  }
}

class Login extends StatefulWidget { @override State<Login> createState() => _LoginState(); }
class _LoginState extends State<Login> {
  final accC = TextEditingController();
  final passC = TextEditingController();
  String? foundName;
  String? accError;
  bool showPass = false;

  void checkAcc(String v) {
    setState(() {
      if (v.trim().isEmpty) { accError = "لا يمكن أن يكون فارغاً"; foundName = null; }
      else { accError = null; if (Bank.users.containsKey(v.trim())) foundName = Bank.users[v.trim()]!.name; else { var f = Bank.users.values.where((u) => u.acc.contains(v.trim())).toList(); foundName = f.isNotEmpty ? f.first.name : null; } }
    });
  }

  void doLogin() {
    setState(() { if (accC.text.trim().isEmpty) accError = "لا يمكن أن يكون فارغاً"; });
    if (accC.text.trim().isEmpty) return;
    var acc = accC.text.trim();
    if (Bank.users.containsKey(acc)) { Bank.current = Bank.users[acc]; } else { Bank.current = MyUser(foundName ?? "مستخدم جديد", acc, 10000); Bank.users[acc] = Bank.current!; }
    Bank.notify("تم تسجيل الدخول بنجاح - مرحباً ${Bank.current!.name}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("مرحباً ${Bank.current!.name}")));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => rtl(Home())));
  }

  @override
  Widget build(BuildContext context) {
    bool hasError = accError != null;
    return Scaffold(backgroundColor: Colors.white, body: Column(children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 45, bottom: 25, left: 16, right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0A2E1F), Color(0xFF1A3D2A), Color(0xFF0A0F0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        child: Column(children: [
          Row(children: [
            Icon(Icons.menu, color: Colors.white, size: 30),
            Expanded(child: Center(child: Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)))),
            Row(children: [Text("اللغة", style: TextStyle(color: Colors.white, fontSize: 16)), SizedBox(width: 4), Icon(Icons.language, color: Colors.white, size: 28)]),
          ]),
          SizedBox(height: 22),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("اوو-كاش", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1)),
              Text("O-CASH", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ]),
            SizedBox(width: 12),
            Container(width: 78, height: 78, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF1DB954), Color(0xFFFFD600), Color(0xFFFFA000)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Center(child: Text("O", style: TextStyle(color: Color(0xFF0A2E1F), fontSize: 55, fontWeight: FontWeight.w900)))),
          ]),
        ]),
      ),
      Expanded(child: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text("مرحباً", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 2),
        Text("قم بتسجيل الدخول إلى حسابك", style: TextStyle(color: Colors.grey[500], fontSize: 15)),
        SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (hasError) Text("لا يمكن أن يكون فارغاً", style: TextStyle(color: Colors.red, fontSize: 13)),
          Text("رقم الحساب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        SizedBox(height: 6),
        TextField(controller: accC, keyboardType: TextInputType.number, onChanged: checkAcc, decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasError ? Colors.red : Color(0xFF0A2E1F), width: 2)),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        )),
        if (foundName != null) Container(width: double.infinity, margin: EdgeInsets.only(top: 10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green[50], border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Expanded(child: Text("الاسم: $foundName", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A2E1F))))])),
        SizedBox(height: 16),
        Text("كلمة المرور", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 6),
        TextField(controller: passC, obscureText: !showPass, decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(icon: Icon(showPass ? Icons.visibility : Icons.visibility_off, color: Colors.black54), onPressed: () => setState(() => showPass = !showPass)),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        )),
        SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تواصل مع البنك لإستعادة كلمة المرور"))); }, child: Text("هل نسيت كلمة المرور ؟", style: TextStyle(color: Color(0xFF0A2E1F), decoration: TextDecoration.underline, fontSize: 15, fontWeight: FontWeight.w600)))),
        SizedBox(height: 6),
        SizedBox(width: double.infinity, height: 54, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6B7A70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))), onPressed: doLogin, child: Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)))),
        SizedBox(height: 16),
        Center(child: TextButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("الاشتراك في أوو-كاش - تواصل مع البنك"))); }, child: Text("الاشتراك في أوو-كاش", style: TextStyle(color: Color(0xFF0A2E1F), decoration: TextDecoration.underline, fontSize: 16, fontWeight: FontWeight.w600)))),
        Center(child: TextButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فتح حساب جديد"))); }, child: Text("فتح حساب", style: TextStyle(color: Color(0xFF0A2E1F), decoration: TextDecoration.underline, fontSize: 16, fontWeight: FontWeight.w600)))),
        SizedBox(height: 8),
        Center(child: Text("مساعدة", style: TextStyle(color: Colors.grey[500], fontSize: 15))),
        SizedBox(height: 14),
        Center(child: Text("الإصدار 6.0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ]))),
    ]));
  }
}

class Home extends StatelessWidget {
  Widget gridBtn(BuildContext c, IconData icon, String title, Widget p) {
    return InkWell(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => rtl(p))), child: Container(decoration: BoxDecoration(color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(14)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 26, backgroundColor: Color(0xFF062E22), child: Icon(icon, color: Colors.yellow, size: 28)), SizedBox(height: 10), Text(title, style: TextStyle(fontWeight: FontWeight.bold))])));
  }
  @override
  Widget build(BuildContext context) {
    var u = Bank.current!;
    return Scaffold(
      drawer: Drawer(child: Container(color: Color(0xFF062E22), child: ListView(padding: EdgeInsets.only(top: 60), children: [
        ListTile(title: Text("البريد الالكتروني", style: TextStyle(color: Colors.white)), leading: Icon(Icons.email, color: Colors.yellow)),
        ListTile(title: Text("الإشعارات (${Bank.notifications.length})", style: TextStyle(color: Colors.white)), leading: Icon(Icons.notifications, color: Colors.yellow), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => rtl(NotificationsPage())))),
        ListTile(title: Text("الإعدادات", style: TextStyle(color: Colors.white)), leading: Icon(Icons.settings, color: Colors.yellow), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => rtl(SettingsPage())))),
        ListTile(title: Text("أسعار العملات", style: TextStyle(color: Colors.white)), leading: Icon(Icons.currency_exchange, color: Colors.yellow)),
        ListTile(title: Text("تحديد المواقع", style: TextStyle(color: Colors.white)), leading: Icon(Icons.location_on, color: Colors.yellow)),
        ListTile(title: Text("الملف الشخصي", style: TextStyle(color: Colors.white)), leading: Icon(Icons.person, color: Colors.yellow)),
      ]))),
      appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("الرئيسية"), centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => rtl(Login())))),
        actions: [Stack(children: [IconButton(icon: Icon(Icons.notifications, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => rtl(NotificationsPage())))), if (Bank.notifications.isNotEmpty) Positioned(right: 8, top: 8, child: Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text("${Bank.notifications.length}", style: TextStyle(color: Colors.white, fontSize: 10))))])],
      ),
      body: Column(children: [
        Container(color: Color(0xFF062E22), padding: EdgeInsets.all(16), child: Column(children: [
          Row(children: [CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("اهلا بك ${u.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("آخر تسجيل دخول ناجح : 15-11-2026 11:05 م", style: TextStyle(color: Colors.white70, fontSize: 11))]))]),
          SizedBox(height: 14),
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1A5C3A), borderRadius: BorderRadius.circular(16)), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("ادخار اونلاين", style: TextStyle(color: Colors.white)), Icon(Icons.circle, color: Colors.white, size: 12)]),
            Text(u.acc, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)), SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("الرصيد الحالي\n${u.balance} SDG", style: TextStyle(color: Colors.white), textAlign: TextAlign.center), Text("الرصيد المتوفر\n${u.balance} SDG", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)]),
          ])),
        ])),
        Expanded(child: GridView.count(crossAxisCount: 2, padding: EdgeInsets.all(14), childAspectRatio: 1.4, crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
          gridBtn(context, Icons.swap_horiz, "تحويل", TransferMenu()),
          gridBtn(context, Icons.article, "الطلبات البنكية", RequestsPage()),
          gridBtn(context, Icons.receipt_long, "دفع الفواتير", BillsMenu()),
          gridBtn(context, Icons.account_circle, "حساباتي", StatementPage()),
          gridBtn(context, Icons.credit_card, "فيزا", VisaPage()),
          gridBtn(context, Icons.settings, "الإعدادات", SettingsPage()),
        ])),
      ]),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("الإشعارات"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: Bank.notifications.isEmpty ? Center(child: Text("لا توجد إشعارات")) : ListView.builder(itemCount: Bank.notifications.length, itemBuilder: (_, i) => ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF062E22), child: Icon(Icons.notifications, color: Colors.yellow)), title: Text(Bank.notifications[i]), subtitle: Text("الآن"))));
  }
}

class TransferMenu extends StatelessWidget {
  Widget row(BuildContext c, String t, IconData i, Widget p) {
    return InkWell(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => rtl(p))), child: Container(margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(14)), child: Row(children: [Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Icon(i, color: Color(0xFF062E22))), SizedBox(width: 12), Expanded(child: Text(t, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))), Icon(Icons.arrow_back_ios, color: Colors.grey)])));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("تحويل"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(padding: EdgeInsets.all(16), children: [
      row(context, "حساباتي", Icons.person, StatementPage()),
      row(context, "التحويل الي عميل داخل البنك", Icons.account_balance, TransferInternal()),
      row(context, "التحويل الى بنك اخر بيبان", Icons.swap_horiz, TransferInternal()),
      row(context, "حسابات المستفيدين", Icons.group, TransferInternal()),
      row(context, "التحويل باستخدام QR", Icons.qr_code, QRPage()),
      row(context, "الايصالات السابقة", Icons.history, StatementPage()),
    ]));
  }
}

class QRPage extends StatefulWidget { @override State<QRPage> createState() => _QRState(); }
class _QRState extends State<QRPage> {
  final codeC = TextEditingController(); String? found;
  @override
  Widget build(BuildContext context) {
    var u = Bank.current!;
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("التحويل باستخدام QR"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
      Text("QR الخاص بي", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), SizedBox(height: 12),
      Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(12)), child: Column(children: [
        GridView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12), itemCount: 144, itemBuilder: (_, i) { var r = Random(i * 7 + 3); bool black = r.nextBool(); return Container(margin: EdgeInsets.all(1), color: black ? Colors.black : Colors.white); }),
        SizedBox(height: 8), Text(u.acc, style: TextStyle(fontWeight: FontWeight.bold)), Text(u.name),
      ])),
      SizedBox(height: 20), Text("امسح QR أو اكتب رقم الحساب", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 8),
      TextField(controller: codeC, onChanged: (v) { setState(() { found = Bank.users.containsKey(v.trim()) ? Bank.users[v.trim()]!.name : null; }); }, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: "02040104392001310100")),
      if (found != null) Container(margin: EdgeInsets.only(top: 10), padding: EdgeInsets.all(12), width: double.infinity, decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)), child: Text("الاسم: $found ✅", style: TextStyle(fontWeight: FontWeight.bold))),
      SizedBox(height: 16),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF062E22)), onPressed: () { if (found == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اكتب رقم حساب صحيح"))); return; } Navigator.push(context, MaterialPageRoute(builder: (_) => rtl(TransferInternal(prefilledAcc: codeC.text.trim())))); }, child: Text("متابعة للتحويل", style: TextStyle(color: Colors.white)))),
    ])));
  }
}

class TransferInternal extends StatefulWidget { final String? prefilledAcc; TransferInternal({this.prefilledAcc}); @override State<TransferInternal> createState() => _TIState(); }
class _TIState extends State<TransferInternal> {
  late TextEditingController accC; final phoneC = TextEditingController(); final noteC = TextEditingController(); final amtC = TextEditingController(); String? verifiedName;
  @override
  void initState() { super.initState(); accC = TextEditingController(text: widget.prefilledAcc ?? ""); if (widget.prefilledAcc != null && Bank.users.containsKey(widget.prefilledAcc)) verifiedName = Bank.users[widget.prefilledAcc]!.name; }
  void checkName(String v) { setState(() { verifiedName = Bank.users.containsKey(v.trim()) ? Bank.users[v.trim()]!.name : null; }); }
  @override
  Widget build(BuildContext context) {
    var u = Bank.current!;
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("التحويل الي عميل داخل البنك"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text("من حساب", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 6),
      Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("ادخار اونلاين"), Text(u.acc)])), Icon(Icons.keyboard_arrow_down)])),
      SizedBox(height: 14), Text("الرصيد المتوفر: ${u.balance} SDG", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 14), Text("رقم العميل - اكتب وسيظهر الاسم مباشرة", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 6),
      TextField(controller: accC, keyboardType: TextInputType.number, onChanged: checkName, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: "02040104392001310100", suffixIcon: Icon(Icons.search))),
      SizedBox(height: 10),
      Container(width: double.infinity, padding: EdgeInsets.all(14), decoration: BoxDecoration(color: verifiedName != null ? Colors.green[50] : Colors.grey[200], border: Border.all(color: verifiedName != null ? Colors.green : Colors.grey), borderRadius: BorderRadius.circular(10)), child: Text(verifiedName != null ? "اسم العميل: $verifiedName ✅" : "اسم العميل سيظهر هنا...", style: TextStyle(fontWeight: FontWeight.bold, color: verifiedName != null ? Color(0xFF062E22) : Colors.grey))),
      SizedBox(height: 12), Text("رقم الهاتف المحمول (اختياري)", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 6), TextField(controller: phoneC, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      SizedBox(height: 12), Text("المبلغ", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 6), TextField(controller: amtC, keyboardType: TextInputType.number, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: "SDG")),
      SizedBox(height: 12), Text("التعليق (اختياري)", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 6), TextField(controller: noteC, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      SizedBox(height: 18),
      SizedBox(width: double.infinity, height: 52, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF062E22)), onPressed: () {
        if (verifiedName == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اكتب رقم حساب صحيح أولاً"))); return; }
        double amt = double.tryParse(amtC.text) ?? 0; if (amt <= 0) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ادخل المبلغ"))); return; } if (amt > u.balance) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("رصيدك غير كافي"))); return; }
        var target = Bank.users[accC.text.trim()]!; u.balance -= amt; target.balance += amt; Bank.txs.insert(0, Tx("تحويل الى ${target.name}", amt, "2026-11-16", false)); Bank.notify("تم تحويل $amt SDG الى $verifiedName بنجاح ✅"); Bank.notify("وصلتك $amt SDG من ${u.name}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم التحويل بنجاح ✅ - وصلك إشعار"), backgroundColor: Colors.green, duration: Duration(seconds: 3)));
        Navigator.push(context, MaterialPageRoute(builder: (_) => rtl(ReceiptPage(amount: amt, toName: target.name, toAcc: target.acc, fromAcc: u.acc))));
      }, child: Text("تحويل", style: TextStyle(color: Colors.white)))),
    ])));
  }
}

class ReceiptPage extends StatelessWidget {
  final double amount; final String toName; final String toAcc; final String fromAcc;
  ReceiptPage({required this.amount, required this.toName, required this.toAcc, required this.fromAcc});
  Widget _r(String k, String v) => Padding(padding: EdgeInsets.only(bottom: 14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(k, style: TextStyle(color: Colors.grey[700])), Expanded(child: Text(v, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w500)))]));
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF00838F), body: SafeArea(child: Column(children: [
      Container(padding: EdgeInsets.all(16), child: Row(children: [Icon(Icons.close, color: Colors.white), Spacer(), Text("اوو-كاش O-CASH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)), Spacer(), Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Center(child: Text("O", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green))))])),
      Expanded(child: Container(margin: EdgeInsets.all(12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Text("SDG${amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))), SizedBox(height: 16),
        _r("الرقم المرجعي", Bank.lastRef), _r("من", fromAcc), _r("اسم المستفيد", toName), _r("إلى", toAcc), _r("الرسوم", "SDG0.00"), _r("المبلغ الإجمالي", "SDG${amount.toStringAsFixed(2)}"), _r("التاريخ", "05/11/2026"),
        Spacer(), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00838F)), onPressed: () { Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => rtl(Home())), (_) => false); }, child: Text("تم", style: TextStyle(color: Colors.white)))),
      ]))),
    ])));
  }
}

class RequestsPage extends StatelessWidget {
  Widget row(BuildContext c, String t) => InkWell(onTap: () { Bank.notify("تم استلام طلبك: $t"); ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text("تم استلام طلبك: $t ✅"))); }, child: Container(margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFFF0F0F0), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(t, style: TextStyle(color: Color(0xFF062E22), fontWeight: FontWeight.w600))), Icon(Icons.arrow_back_ios, color: Colors.grey)])));
  @override
  Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("خدمات الطلبات"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(padding: EdgeInsets.all(16), children: [row(context, "طلب كشف حساب"), row(context, "طلب دفتر شيكات"), row(context, "طلب بطاقة الصراف الآلي"), row(context, "وقف طلب بطاقة الصراف الآلي")])); }
}

class StatementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var u = Bank.current!;
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("بيان مصغر"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: Column(children: [
      Padding(padding: EdgeInsets.all(16), child: Row(children: [Text("بيان"), Spacer(), Text(u.acc)])),
      Expanded(child: ListView.builder(itemCount: Bank.txs.length, itemBuilder: (_, i) { var t = Bank.txs[i]; return Container(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6), padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)), child: Row(children: [CircleAvatar(backgroundColor: t.isIn ? Colors.green : Colors.orange, child: Icon(t.isIn ? Icons.add : Icons.remove, color: Colors.white)), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.title), Text("2026-11-12", style: TextStyle(fontSize: 11, color: Colors.grey))])), Text("${t.amount}", style: TextStyle(fontWeight: FontWeight.bold))])); })),
    ]));
  }
}

class BillsMenu extends StatelessWidget {
  Widget row(BuildContext c, String t, Widget p) => InkWell(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => rtl(p))), child: Container(margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(t, style: TextStyle(fontWeight: FontWeight.w600))), Icon(Icons.arrow_back_ios, color: Colors.grey)]));
  @override
  Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("دفع الفواتير"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(padding: EdgeInsets.all(16), children: [row(context, "دفع الفواتير", BillsPayPage()), row(context, "الدفعيات السابقة", BillsHistoryPage()), row(context, "الفواتير المفضلة", BillsFavPage())])); }
}
class BillsPayPage extends StatefulWidget { @override State<BillsPayPage> createState() => _BillsPayState(); }
class _BillsPayState extends State<BillsPayPage> {
  String type = "كهرباء"; final numC = TextEditingController(); final amtC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var u = Bank.current!;
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("دفع الفواتير"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Wrap(spacing: 8, children: ["كهرباء", "موية", "رصيد", "انترنت", "جامعة"].map((e) => ChoiceChip(label: Text(e), selected: type == e, onSelected: (_) => setState(() => type = e), selectedColor: Color(0xFF062E22), labelStyle: TextStyle(color: type == e ? Colors.white : Colors.black))).toList()),
      SizedBox(height: 16), Text("رقم العداد / الرقم", style: TextStyle(fontWeight: FontWeight.bold)), TextField(controller: numC, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      SizedBox(height: 12), Text("المبلغ", style: TextStyle(fontWeight: FontWeight.bold)), TextField(controller: amtC, keyboardType: TextInputType.number, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: "SDG")),
      SizedBox(height: 18),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF062E22)), onPressed: () {
        if (numC.text.isEmpty || amtC.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اكمل البيانات"))); return; }
        double amt = double.tryParse(amtC.text) ?? 0; if (amt > u.balance) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("رصيدك غير كافي"))); return; }
        u.balance -= amt; Bank.txs.insert(0, Tx("دفع فاتورة $type - ${numC.text}", amt, "2026-11-16", false)); Bank.notify("تم دفع فاتورة $type بقيمة $amt SDG ✅");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم الدفع بنجاح ✅ - وصلك إشعار"), backgroundColor: Colors.green)); Navigator.pop(context);
      }, child: Text("دفع الآن", style: TextStyle(color: Colors.white)))),
    ])));
  }
}
class BillsHistoryPage extends StatelessWidget { @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("الدفعيات السابقة"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(children: [ListTile(title: Text("كهرباء - 041234567"), subtitle: Text("13-11-2026"), trailing: Text("2,000 SDG")), ListTile(title: Text("موية - 098765"), subtitle: Text("12-11-2026"), trailing: Text("1,500 SDG"))])); } }
class BillsFavPage extends StatelessWidget { @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("الفواتير المفضلة"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(children: [ListTile(title: Text("كهرباء البيت"), subtitle: Text("041234567"), leading: Icon(Icons.star, color: Colors.amber)), ListTile(title: Text("رصيد أمي"), subtitle: Text("0912345678"), leading: Icon(Icons.star, color: Colors.amber))])); } }

class VisaPage extends StatelessWidget { @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("فيزا"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [Container(width: double.infinity, height: 180, padding: EdgeInsets.all(18), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Color(0xFF062E22)]), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("VISA", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)), Spacer(), Text("5312 **** **** 1234", style: TextStyle(color: Colors.white, fontSize: 20)), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("OKASH USER", style: TextStyle(color: Colors.white70)), Text("12/28", style: TextStyle(color: Colors.white70))])])), SizedBox(height: 16), ListTile(title: Text("رصيد البطاقة"), subtitle: Text("12,500 SDG"), leading: Icon(Icons.account_balance_wallet, color: Color(0xFF062E22)))]))); } }

class SettingsPage extends StatefulWidget { @override State<SettingsPage> createState() => _SState(); }
class _SState extends State<SettingsPage> {
  bool finger = true;
  Widget row(String t) => Container(margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFFF0F0F0), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(t, style: TextStyle(color: Color(0xFF062E22), fontWeight: FontWeight.w600))), Icon(Icons.arrow_back_ios, color: Colors.grey)]));
  @override
  Widget build(BuildContext context) { return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF062E22), title: Text("الإعدادات"), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.white), onPressed: () => Navigator.pop(context))), body: ListView(padding: EdgeInsets.all(16), children: [row("تغيير كلمة المرور للدخول"), row("تغيير كلمة المرور للعمليات المالية"), row("تغيير اسم الدخول"), row("إدارة حسابي"), row("إدارة المستفيدين"), row("تغيير اللغة"), Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF062E22)), bottom: BorderSide(color: Color(0xFF062E22)))), child: Row(children: [Expanded(child: Text("معرف البصمة")), Switch(value: finger, onChanged: (v) => setState(() => finger = v))])), ListTile(title: Text("تسجيل الخروج", style: TextStyle(color: Colors.red)), leading: Icon(Icons.logout, color: Colors.red), onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => rtl(Login())), (_) => false))])); }
}
