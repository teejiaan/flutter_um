import 'package:flutter/material.dart';
import 'package:flutter_um/screens/cart_screen.dart';
import 'package:flutter_um/screens/order_history_screen.dart';
import 'package:flutter_um/screens/shop_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_um/screens/analytics_screen.dart';
import 'package:flutter_um/screens/purchase_membership_screen.dart';
import 'package:flutter_um/screens/daily_points_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<String> _titles = ['Shop', 'Cart', 'Orders'];
  final List<Widget> _screens = [
    const ShopScreen(),
    const CartScreen(),
    const OrderHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: const Text(
                '🏠︎ Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Daily Points'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyPointsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('View Analytics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_membership),
              title: const Text('Purchase Membership'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseMembershipScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Text('🚪', style: TextStyle(fontSize: 20)),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(
                  context,
                  '/screen1',
                ); // Redirect to login
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
              top: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Orders',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.teal,
                shape: const CircleBorder(),
                elevation: 8,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
