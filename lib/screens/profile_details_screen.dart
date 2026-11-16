
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/app_routes.dart';
import '../services/auth_api_service.dart';
import '../services/user_session.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState
    extends State<ProfileDetailsScreen> {
  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color orange = Color(0xFFFF7A00);

  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();

  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _avatarUrl;
  Uint8List? _previewBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final result = await AuthApiService.getMe();
      final data = result['data'];
      if (data is! Map) return;
      final user = data['user'] is Map ? data['user'] as Map : data;
      final image = user['profile_image'];
      final url = image is Map ? image['url'] : image;
      if (mounted && url is String && url.isNotEmpty) {
        setState(() => _avatarUrl = url);
      }
    } catch (e) {
      debugPrint('Avatar load failed: $e');
    }
  }

  Future<void> _showPhotoOptions() async {
    if (_uploadingAvatar || _saving) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: blue),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: blue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    if (_uploadingAvatar || _saving) return;

    try {
      final photo = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (photo == null) return;

      final bytes = await photo.readAsBytes();

      if (bytes.isEmpty) {
        _message('Selected image is empty. Please choose another photo.');
        return;
      }

      if (bytes.length > 2 * 1024 * 1024) {
        _message('Please choose a photo smaller than 2 MB.');
        return;
      }

      // Detect the actual image format from its file signature.
      // Do not rely only on photo.name or the file extension.
      String extension;
      MediaType contentType;

      final isPng = bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47 &&
          bytes[4] == 0x0D &&
          bytes[5] == 0x0A &&
          bytes[6] == 0x1A &&
          bytes[7] == 0x0A;

      final isJpeg = bytes.length >= 3 &&
          bytes[0] == 0xFF &&
          bytes[1] == 0xD8 &&
          bytes[2] == 0xFF;

      if (isPng) {
        extension = 'png';
        contentType = MediaType('image', 'png');
      } else if (isJpeg) {
        extension = 'jpg';
        contentType = MediaType('image', 'jpeg');
      } else {
        _message('Only valid PNG or JPEG images are supported.');
        return;
      }

      if (!mounted) return;
      setState(() => _uploadingAvatar = true);

      final token = await AuthApiService.getAccessToken();
      if (token == null || token.trim().isEmpty) {
        throw Exception('Login session missing. Please login again.');
      }

      // Keep this host in sync with AuthApiService's base URL.
      // The backend must be running and reachable at this address.
      final uri = Uri.parse(
        'http://192.168.1.26:4000/api/v1/auth/updateAvatar',
      );

      final request = http.MultipartRequest('PATCH', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'accessToken': token,
        'Authorization': 'Bearer $token',
        'x-access-token': token,
      });

      // IMPORTANT: Do not set Content-Type manually for MultipartRequest.
      // It adds multipart/form-data with the correct boundary automatically.
      request.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          bytes,
          filename: 'profile.$extension',
          contentType: contentType,
        ),
      );

      final streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 45));

      final response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 30));

      Map<String, dynamic>? decoded;
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          decoded = body;
        } else if (body is Map) {
          decoded = Map<String, dynamic>.from(body);
        }
      } on FormatException {
        decoded = null;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded?['message']?.toString();
        throw Exception(
          message != null && message.isNotEmpty
              ? message
              : 'Photo upload failed (HTTP ${response.statusCode}).',
        );
      }

      if (decoded == null) {
        throw Exception('Server returned an invalid response.');
      }

      if (decoded['success'] != true && decoded['status'] != true) {
        throw Exception(
          decoded['message']?.toString() ?? 'Photo upload failed.',
        );
      }

      final data = decoded['data'];
      final user = data is Map && data['user'] is Map
          ? data['user'] as Map
          : data;
      final image = user is Map ? user['profile_image'] : null;
      final url = image is Map ? image['url'] : image;

      if (url is! String || url.trim().isEmpty) {
        // Some APIs return success without returning the image URL.
        // Refresh the profile once to retrieve the saved avatar URL.
        await _loadAvatar();

        if (_avatarUrl == null || _avatarUrl!.isEmpty) {
          throw Exception(
            'Upload response received, but the profile image URL was not returned.',
          );
        }
      } else {
        if (!mounted) return;
        setState(() {
          _avatarUrl = url;
          _previewBytes = bytes;
        });
      }

      // Keep the cached profile photo in sync with the upload.
      if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
        await UserSession.updateUser({
          'profile_image': {'url': _avatarUrl},
        });
      }

      if (mounted) {
        _message('Profile photo uploaded successfully.');
      }
    } on http.ClientException catch (e) {
      if (mounted) {
        _message(
          'Cannot connect to the server. Check that the backend is running, '
          'the phone and laptop are on the same Wi-Fi, and the server IP is correct. '
          'Details: ${e.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        _message(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  Widget _avatarPicker() {
    final ImageProvider? avatarImage = _previewBytes != null
        ? MemoryImage(_previewBytes!)
        : (_avatarUrl != null ? NetworkImage(_avatarUrl!) : null);
    return Center(
      child: InkWell(
        onTap: _uploadingAvatar ? null : _showPhotoOptions,
        borderRadius: BorderRadius.circular(60),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFFEAF4FF),
              backgroundImage: avatarImage,
              child: _uploadingAvatar
                  ? const CircularProgressIndicator(color: blue)
                  : (_previewBytes == null && _avatarUrl == null
                      ? const Icon(Icons.account_circle_outlined,
                          size: 86, color: blue)
                      : null),
            ),
            Positioned(
              right: -3,
              bottom: -3,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: orange,
                child: const Icon(Icons.camera_alt,
                    color: Colors.white, size: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  void _message(String value) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(value),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // SAVE PROFILE
  Future<void> _save() async {
    if (_saving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _saving = true;
    });

    try {
      // STEP 1: CHECK SAVED TOKEN
      final token = await AuthApiService.getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Login session missing. Please login again.',
        );
      }

      // STEP 2: UPDATE PROFILE API
      final result = await AuthApiService.updateProfile(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
      );

      // STEP 3: CHECK API RESPONSE
      final success =
          result['success'] == true ||
          result['status'] == true;

      if (!success) {
        throw Exception(
          result['message']?.toString() ??
              'Profile update failed.',
        );
      }

      if (!mounted) return;

      // Update local profile immediately after successful API response.
      // No extra getMe request needed on the Home/Profile screens.
      final fullName = [
        _firstName.text.trim(),
        _lastName.text.trim(),
      ].where((part) => part.isNotEmpty).join(' ');

      await UserSession.updateUser({
        'name': fullName,
        'email': _email.text.trim(),
        'profile_completed': true,
        if (_avatarUrl != null && _avatarUrl!.isNotEmpty)
          'profile_image': {'url': _avatarUrl},
      });

      if (!mounted) return;

      // STEP 4: OPEN HOME
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      debugPrint('Profile update error: $e');

      _message(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFD8E0E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFD8E0E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: blue,
          width: 1.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                30,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    _avatarPicker(),

                    const SizedBox(height: 16),

                    const Text(
                      'Tell us about yourself',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Add your details to get started with KaamDaar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF667085),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'First Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _firstName,
                      textCapitalization:
                          TextCapitalization.words,
                      decoration:
                          _decoration('Enter first name'),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Last Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _lastName,
                      textCapitalization:
                          TextCapitalization.words,
                      decoration:
                          _decoration('Enter last name'),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _email,
                      keyboardType:
                          TextInputType.emailAddress,
                      decoration:
                          _decoration('Enter email address'),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Email is required';
                        }

                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(email)) {
                          return 'Enter a valid email address';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: (_saving || _uploadingAvatar) ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: orange
                              .withValues(alpha: 0.6),
                          shape: const StadiumBorder(),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save & Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
