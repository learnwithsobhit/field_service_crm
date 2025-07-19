import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String _selectedRole = 'technician';

  final List<String> _roles = [
    'technician',
    'supervisor',
    'manager',
    'dispatcher',
    'administrator'
  ];

  final Map<String, String> _roleLabels = {
    'technician': 'Field Technician',
    'supervisor': 'Team Supervisor',
    'manager': 'Operations Manager',
    'dispatcher': 'Dispatcher',
    'administrator': 'System Administrator'
  };

  final Map<String, IconData> _roleIcons = {
    'technician': Icons.build,
    'supervisor': Icons.people,
    'manager': Icons.manage_accounts,
    'dispatcher': Icons.schedule,
    'administrator': Icons.admin_panel_settings
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo and Title
                _buildHeader(),
                const SizedBox(height: 40),

                // Role Selection
                _buildRoleSelection(),
                const SizedBox(height: 24),

                // Email Field
                _buildEmailField(),
                const SizedBox(height: 16),

                // Password Field
                _buildPasswordField(),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                _buildRememberMeAndForgotPassword(),
                const SizedBox(height: 24),

                // Login Button
                _buildLoginButton(),
                const SizedBox(height: 24),

                // Divider
                _buildDivider(),
                const SizedBox(height: 24),

                // Social Login Options
                _buildSocialLoginOptions(),
                const SizedBox(height: 24),

                // Sign Up Link
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF14B8A6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14B8A6).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.build_circle,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your Field Service CRM account',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _roles.length,
            itemBuilder: (context, index) {
              final role = _roles[index];
              final isSelected = _selectedRole == role;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedRole = role),
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF14B8A6) : Colors.grey[50],
                    border: Border.all(
                      color: isSelected ? const Color(0xFF14B8A6) : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _roleIcons[role],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _roleLabels[role]!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) => setState(() => _rememberMe = value!),
                activeColor: const Color(0xFF14B8A6),
              ),
              const Text('Remember me'),
            ],
          ),
        ),
        TextButton(
          onPressed: _forgotPassword,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF14B8A6)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF14B8A6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Signing In...'),
              ],
            )
          : const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _signInWithGoogle,
          icon: const Icon(Icons.g_mobiledata, color: Colors.red),
          label: const Text('Continue with Google'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _signInWithApple,
          icon: const Icon(Icons.apple, color: Colors.black),
          label: const Text('Continue with Apple'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: _navigateToSignUp,
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF14B8A6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock authentication logic
      final email = _emailController.text.toLowerCase();
      final password = _passwordController.text;
      
      // Demo credentials
      if (email == 'demo@fieldservice.com' && password == 'password') {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        }
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent to your email'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-In coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _signInWithApple() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign-In coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }
} 