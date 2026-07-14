import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo/Icon
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.goldGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: accentGold.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.mosque_rounded,
                              color: isDark
                                  ? const Color(0xFF0B1324)
                                  : Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'مرحباً بك مجدداً',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'سجّل الدخول لمتابعة رحلتك الروحانية',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Login Form Box
                        GlassCard(
                          radius: 30,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                                decoration: _inputDecoration(
                                  'البريد الإلكتروني',
                                  Icons.email_outlined,
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                    ? 'البريد الإلكتروني غير صالح'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                textDirection: TextDirection.ltr,
                                decoration: _inputDecoration(
                                  'كلمة المرور',
                                  Icons.lock_outline,
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'كلمة المرور قصيرة جداً'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context.push('/forgot-password');
                                  },
                                  child: Text(
                                    'نسيت كلمة المرور؟',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: accentGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: _buttonStyle(accentGold, isDark),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    HapticFeedback.mediumImpact();
                                    // Simulated sign in
                                    context.go('/home');
                                  }
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟ ',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                context.push('/register');
                              },
                              child: Text(
                                'أنشئ حساباً جديداً',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 12,
                                  color: accentGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    final accentGold = AppTheme.goldPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.notoKufiArabic(
        fontSize: 12,
        color: AppTheme.textMuted,
      ),
      prefixIcon: Icon(icon, color: accentGold, size: 18),
      filled: true,
      fillColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold, width: 1.2),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color bg, bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: isDark ? const Color(0xFF0B1324) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 4,
      shadowColor: bg.withValues(alpha: 0.3),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'إنشاء حساب جديد',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ابدأ رحلتك الإيمانية مع تطبيقنا الفاخر',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Form Card
                        GlassCard(
                          radius: 30,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: _inputDecoration(
                                  'الاسم الكامل',
                                  Icons.person_outline_rounded,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'الرجاء إدخال الاسم'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                                decoration: _inputDecoration(
                                  'البريد الإلكتروني',
                                  Icons.email_outlined,
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                    ? 'البريد الإلكتروني غير صالح'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                textDirection: TextDirection.ltr,
                                decoration: _inputDecoration(
                                  'كلمة المرور',
                                  Icons.lock_outline,
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'يجب أن لا تقل كلمة المرور عن 6 أحرف'
                                    : null,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: _buttonStyle(accentGold, isDark),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    HapticFeedback.mediumImpact();
                                    // OTP route simulation
                                    context.push('/otp');
                                  }
                                },
                                child: Text(
                                  'إنشاء الحساب',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لديك حساب بالفعل؟ ',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                context.pop();
                              },
                              child: Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 12,
                                  color: accentGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    final accentGold = AppTheme.goldPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.notoKufiArabic(
        fontSize: 12,
        color: AppTheme.textMuted,
      ),
      prefixIcon: Icon(icon, color: accentGold, size: 18),
      filled: true,
      fillColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold, width: 1.2),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color bg, bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: isDark ? const Color(0xFF0B1324) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 4,
      shadowColor: bg.withValues(alpha: 0.3),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: accentGold),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'نسيت كلمة المرور',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أدخل بريدك الإلكتروني لإرسال كود التحقق لتسجيل كلمة مرور جديدة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Form Card
                        GlassCard(
                          radius: 30,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  labelStyle: GoogleFonts.notoKufiArabic(
                                    fontSize: 12,
                                    color: AppTheme.textMuted,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: accentGold,
                                    size: 18,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? const Color(
                                          0xFF1E293B,
                                        ).withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.5),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: accentGold.withValues(alpha: 0.15),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: accentGold,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                    ? 'البريد الإلكتروني غير صالح'
                                    : null,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentGold,
                                  foregroundColor: isDark
                                      ? const Color(0xFF0B1324)
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  elevation: 4,
                                  shadowColor: accentGold.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    HapticFeedback.mediumImpact();
                                    context.push('/otp');
                                  }
                                },
                                child: Text(
                                  'إرسال كود التحقق',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: accentGold),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'تأكيد الرمز (OTP)',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لقد أرسلنا كود التحقق المكون من 4 أرقام إلى بريدك الإلكتروني',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Code inputs Card
                      GlassCard(
                        radius: 30,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: TextFormField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: isDark
                                          ? const Color(
                                              0xFF1E293B,
                                            ).withValues(alpha: 0.3)
                                          : Colors.white.withValues(alpha: 0.5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: accentGold.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: accentGold,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        HapticFeedback.lightImpact();
                                        if (index < 3) {
                                          _focusNodes[index + 1].requestFocus();
                                        } else {
                                          _focusNodes[index].unfocus();
                                        }
                                      } else {
                                        if (index > 0) {
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentGold,
                                foregroundColor: isDark
                                    ? const Color(0xFF0B1324)
                                    : Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                elevation: 4,
                                shadowColor: accentGold.withValues(alpha: 0.3),
                              ),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                // Simulated sign in success
                                context.go('/home');
                              },
                              child: Text(
                                'تأكيد الحساب',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            // Resend animation
                          },
                          child: Text(
                            'إعادة إرسال الكود؟',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12,
                              color: accentGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
