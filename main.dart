import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA3oL5KciRELVB74IpNRskNGAx36CAW8ew",
      authDomain: "crisislink-3d3af.firebaseapp.com",
      projectId: "crisislink-3d3af",
      storageBucket: "crisislink-3d3af.appspot.com",
      messagingSenderId: "683221505285",
      appId: "1:683221505285:web:b92390617a02b51d20136c",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrisisLink',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () => setState(() => _opacity = 1.0));
    Timer(const Duration(seconds: 3), () => setState(() => _opacity = 0.0));
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PreLoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7EF),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Container(
            width: 403,
            height: 403,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/ChatGPT%20Image%20Jun%2012%2C%202025%2C%2006_46_45%20PM.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});
  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  void _onTap() {
    if (_tapped) return;
    setState(() => _tapped = true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20272B),
      body: Center(
        child: GestureDetector(
          onTap: _onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _tapped ? _controller.value : 0,
                  strokeWidth: 6,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA3D5FF)),
                  backgroundColor: Colors.transparent,
                ),
              ),
              AnimatedBuilder(
                animation: _rotation,
                builder: (context, child) => Transform.rotate(angle: _rotation.value, child: child),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/ChatGPT_Image_Jun_12__2025__06_46_45_PM-removebg-preview.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20272B),
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF20272B),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Image.network(
                      'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/ChatGPT_Image_Jun_12__2025__06_46_45_PM-removebg-preview.png',
                      height: 350,
                    ),
                    const SizedBox(height: 30),
                    _buildTextInput(
                      hint: 'Username / Email',
                      onSaved: (value) => email = value ?? '',
                      validator: (value) => value == null || !value.contains('@') ? 'Please enter a valid email' : null,
                      obscure: false,
                    ),
                    _buildTextInput(
                      hint: 'Password',
                      onSaved: (value) => password = value ?? '',
                      validator: (value) => value == null || value.length < 6 ? 'Password must be 6+ characters' : null,
                      obscure: true,
                      suffix: IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Color(0xFFA3D5FF)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in!')));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage(mood: 'neutral')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(onPressed: () {}, child: const Text('Sign Up', style: TextStyle(color: Color(0xFF10A0FA)))),
                    TextButton(onPressed: () {}, child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF10A0FA)))),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                      },
                      child: const Text('Continue As Guest', style: TextStyle(color: Color(0xFF10A0FA))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required String hint,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
    required bool obscure,
    Widget? suffix,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                decoration: InputDecoration(hintText: hint, border: InputBorder.none),
                obscureText: obscure,
                validator: validator,
                onSaved: onSaved,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How often have you felt overwhelmed or stressed lately?',
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
    },
    {
      'question': 'How well have you been sleeping recently?',
      'options': ['Very well', 'Okay', 'Poorly', 'Barely sleeping'],
    },
    {
      'question': 'How often do you feel anxious or nervous?',
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
    },
    {
      'question': 'Are you enjoying activities you used to enjoy?',
      'options': ['Yes, very much', 'A little', 'Not really', 'Not at all'],
    },
    {
      'question': 'Do you feel supported by friends or family?',
      'options': ['Always', 'Most of the time', 'Sometimes', 'Rarely', 'Never'],
    },
    {
      'question': 'How would you rate your energy levels?',
      'options': ['Very high', 'Moderate', 'Low', 'Exhausted'],
    },
  ];

  int _currentQuestion = 0;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      _currentQuestion++;
    });

    if (_currentQuestion >= _questions.length) {
      String mood;
      if (_totalScore <= 7) {
        mood = 'happy';
      } else if (_totalScore <= 14) {
        mood = 'okay';
      } else if (_totalScore <= 20) {
        mood = 'down';
      } else {
        mood = 'struggling';
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(mood: mood),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = _questions[_currentQuestion];
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7EF),
      appBar: AppBar(
        title: const Text('Mental Health Quiz'),
        backgroundColor: const Color(0xFF20272B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              current['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(current['options'].length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10A0FA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Text(current['options'][index],
                      style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
            const SizedBox(height: 12),
            Text(
              'Question ${_currentQuestion + 1} of ${_questions.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String mood;
  const HomePage({super.key, this.mood = 'neutral'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _hospitalOffset;
  late Animation<Offset> _educationOffset;
  late Animation<Offset> _veteranOffset;
  late Animation<Offset> _emergencyOffset;
  bool _menuOpen = false;

  final Map<String, String> moodImages = {
    'happy': 'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/happy_flower_1-removebg-preview.png',
    'okay': 'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/okay_flower_1-removebg-preview.png',
    'down': 'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/MoodFlowers_1-removebg-preview.png',
    'struggling': 'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/MoodFlowers_2-removebg-preview.png',
    'neutral': 'https://raw.githubusercontent.com/Akash0605/congressional25/refs/heads/main/MoodFlowers_1-removebg-preview.png',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _hospitalOffset = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _educationOffset = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _veteranOffset = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _emergencyOffset = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  void _toggleMenu() {
    setState(() {
      _menuOpen = !_menuOpen;
      _menuOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = moodImages[widget.mood] ?? moodImages['neutral']!;

    return Scaffold(
      backgroundColor: const Color(0xFF20272B),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      imageUrl,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Mood: ${widget.mood}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white),
                onPressed: _toggleMenu,
              ),
              if (_menuOpen)
                SlideTransition(
                  position: _hospitalOffset,
                  child: IconButton(
                    icon: const Icon(Icons.local_hospital, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TherapyScreen()),
                    ),
                  ),
                ),
              if (_menuOpen)
                SlideTransition(
                  position: _educationOffset,
                  child: IconButton(
                    icon: const Icon(Icons.video_library, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EducationScreen()),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              if (_menuOpen)
                SlideTransition(
                  position: _veteranOffset,
                  child: IconButton(
                    icon: const Icon(Icons.military_tech, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VeteranSupportScreen()),
                    ),
                  ),
                ),
              if (_menuOpen)
                SlideTransition(
                  position: _emergencyOffset,
                  child: IconButton(
                    icon: const Icon(Icons.phone_in_talk, color: Colors.redAccent),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmergencyScreen()),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _personalContacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update FAB when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _addContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C333A),
        title: const Text('Add Emergency Contact', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_relationController, 'Relation'),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_phoneController, 'Phone Number', TextInputType.phone),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                setState(() {
                  _personalContacts.add({
                    'name': _nameController.text,
                    'relation': _relationController.text,
                    'address': _addressController.text,
                    'phone': _phoneController.text,
                  });
                });
                _clearControllers();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? type]) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _relationController.clear();
    _addressController.clear();
    _phoneController.clear();
  }

  Widget _buildPersonalContactsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _personalContacts.isEmpty
          ? const Center(
              child: Text(
                'No personal emergency contacts added yet.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _personalContacts.length,
              itemBuilder: (context, index) {
                final contact = _personalContacts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact['relation'] ?? '',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact['address'] ?? '',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact['phone']!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActionButton(Icons.message, 'Message', const Color(0xFF10A0FA)),
                              _buildActionButton(Icons.phone, 'Call', const Color(0xFF13DB08)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => setState(() => _personalContacts.removeAt(index)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white10,
                          child: IconButton(
                            icon: const Icon(Icons.location_on, color: Colors.redAccent),
                            onPressed: () {
                              // TODO: Add location tracking functionality here later
                            },
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

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildOfficialContactsTab() {
    final List<Map<String, String>> officialContacts = [
      {'name': 'National Suicide Prevention Lifeline', 'phone': '1-800-273-TALK'},
      {'name': 'Crisis Text Line', 'phone': 'Text HOME to 741741'},
      {'name': '911 - Emergency Services', 'phone': '911'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: officialContacts.length,
        itemBuilder: (context, index) {
          final contact = officialContacts[index];
          return Card(
            color: const Color(0xFF2C333A),
            child: ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.orangeAccent),
              title: Text(contact['name']!, style: const TextStyle(color: Colors.white)),
              subtitle: Text(contact['phone']!, style: const TextStyle(color: Colors.white70)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20272B),
      appBar: AppBar(
        title: const Text('Emergency Resources'),
        backgroundColor: const Color(0xFF20272B),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Contacts'),
            Tab(text: 'Official Help'),
          ],
          indicatorColor: Colors.redAccent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalContactsTab(),
          _buildOfficialContactsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: _addContactDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20272B),
      appBar: AppBar(
        title: const Text('Mental Health Education'),
        backgroundColor: const Color(0xFF20272B),
      ),
      body: const Center(
        child: Text(
          'Educational Videos Coming Soon!',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}


class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7EF),
      appBar: AppBar(
        title: const Text('Find a Therapist'),
        backgroundColor: const Color(0xFF20272B),
      ),
      body: Column(
        children: [
          // Placeholder for Google Maps
          Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Text('Map will be here', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Therapy Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF10A0FA)),
                  title: Text('Dr. Smith'),
                  subtitle: Text('Therapist - (555) 123-4567'),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF10A0FA)),
                  title: Text('Counselor Jane'),
                  subtitle: Text('Counselor - (555) 987-6543'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF10A0FA),
        onPressed: () {
          // TODO: Add AI Chatbot navigation
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class VeteranSupportScreen extends StatelessWidget {
  const VeteranSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> locations = [
      {
        'name': 'VA Medical Center - Springfield',
        'type': 'Mental Health & Physical Services',
        'distance': '2.3 miles'
      },
      {
        'name': 'Veteran Wellness Hub',
        'type': 'Therapy & Support Groups',
        'distance': '5.1 miles'
      },
      {
        'name': 'Community Veteran Center',
        'type': 'Rehabilitation and Benefits',
        'distance': '3.7 miles'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7EF),
      appBar: AppBar(
        title: const Text('Veteran Support Centers'),
        backgroundColor: const Color(0xFF20272B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final loc = locations[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Color(0xFF10A0FA)),
              title: Text(loc['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${loc['type']!}\n${loc['distance']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
