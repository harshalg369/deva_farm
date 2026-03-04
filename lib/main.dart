import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(DevaFarmApp());
}

class DevaFarmApp extends StatefulWidget {
  @override
  State<DevaFarmApp> createState() => _DevaFarmAppState();
}

class _DevaFarmAppState extends State<DevaFarmApp> {
  bool darkMode = false;

  void toggleTheme() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: Colors.green.shade50,
            ),
      home: SplashScreen(toggleTheme: toggleTheme, darkMode: darkMode),
    );
  }
}

//////////////////////////////////////////////////////////
// SPLASH
//////////////////////////////////////////////////////////

class SplashScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool darkMode;

  SplashScreen({required this.toggleTheme, required this.darkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(
            toggleTheme: widget.toggleTheme,
            darkMode: widget.darkMode,
          ),
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(controller),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, size: 120, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "DEVA FARM",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Smart Waste Management",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// LOGIN
//////////////////////////////////////////////////////////

class LoginPage extends StatelessWidget {
  final Function toggleTheme;
  final bool darkMode;

  LoginPage({required this.toggleTheme, required this.darkMode});

  final user = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Deva Farm Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: user,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: pass,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainScreen(
                        toggleTheme: toggleTheme,
                        darkMode: darkMode,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// MAIN SCREEN
//////////////////////////////////////////////////////////

class MainScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool darkMode;

  MainScreen({required this.toggleTheme, required this.darkMode});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      DashboardPage(),
      GraphPage(),
      PickupPage(),
      ProfilePage(widget.toggleTheme),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.green,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: "Pickup",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// DASHBOARD
//////////////////////////////////////////////////////////

class DashboardPage extends StatelessWidget {
  Widget card(String title, String value, IconData icon) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  int predictWaste(int waste) {
    return waste + 500; // simple AI demo prediction
  }

  @override
  Widget build(BuildContext context) {
    int prediction = predictWaste(5200);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Waste Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            card("Organic Waste", "5200 kg", Icons.eco),
            card("Compost Produced", "3400 kg", Icons.recycling),
            card("Biogas Generated", "1200 m3", Icons.energy_savings_leaf),
            card("CO₂ Saved", "2.5 Tons", Icons.cloud),
            SizedBox(height: 20),
            Text(
              "AI Prediction Next Month: $prediction kg",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// ANALYTICS GRAPH
//////////////////////////////////////////////////////////

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Waste Analytics",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 40, title: "Organic"),
                  PieChartSectionData(value: 30, title: "Crop"),
                  PieChartSectionData(value: 20, title: "Plastic"),
                  PieChartSectionData(value: 10, title: "Other"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// PICKUP PAGE
//////////////////////////////////////////////////////////

class PickupPage extends StatelessWidget {
  final name = TextEditingController();
  final waste = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Waste Pickup Request",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          TextField(
            controller: name,
            decoration: InputDecoration(labelText: "Farmer Name"),
          ),

          TextField(
            controller: waste,
            decoration: InputDecoration(labelText: "Waste Amount"),
          ),

          SizedBox(height: 20),

          ElevatedButton(
            child: Text("Request Pickup"),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Pickup Requested")));
            },
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// PROFILE
//////////////////////////////////////////////////////////

class ProfilePage extends StatelessWidget {
  final Function toggleTheme;

  ProfilePage(this.toggleTheme);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 80),
        CircleAvatar(radius: 50, child: Icon(Icons.person, size: 40)),
        SizedBox(height: 10),
        Text(
          "Devdat Sorathiya",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text("Rajkot - Farm Owner"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => toggleTheme(),
          child: Text("Toggle Dark Mode"),
        ),
      ],
    );
  }
}
