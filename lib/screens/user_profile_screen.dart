import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/app_routes.dart';
import '../services/auth_api_service.dart';
import '../services/user_session.dart';
import 'address_screens.dart';
import '../widgets/provider_bottom_nav.dart';

class UserProfileScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const UserProfileScreen({super.key, this.onTabSelected});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const Color navy = Color(0xFF0B1F3A);
  static const Color blue = Color(0xFF1261A0);
  static const Color orange = Color(0xFFFF7A00);
  static const Color canvas = Color(0xFFF7F9FC);

  // Backend has supplied different LAN hosts for these endpoints.
  static final Uri _avatarUri = Uri.parse('http://192.168.1.26:4000/api/v1/auth');
  static final Uri _profileUri = Uri.parse('http://192.168.1.26:4000/api/v1/auth/updateProfileController');

  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> user = {};
  List<dynamic> addresses = [];
  bool loading = true;
  bool savingName = false;
  bool uploadingAvatar = false;
  bool removingAvatar = false; 
  bool loggingOut = false;
  String? avatarUrl;
  Uint8List? previewBytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cached = await UserSession.getUser();
    if (!mounted) return;
    setState(() {
      user = cached;
      addresses = cached['_cached_addresses'] is List
          ? List<dynamic>.from(cached['_cached_addresses'] as List)
          : <dynamic>[];
      final image = cached['profile_image'];
      avatarUrl = image is Map ? image['url']?.toString() : image?.toString();
      loading = false;
    });
    await _fetchAvatar();
  }

  Future<String> _token() async {
    final token = await AuthApiService.getAccessToken();
    if (token == null || token.trim().isEmpty) {
      throw Exception('Login session missing. Please login again.');
    }
    return token.trim();
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'accessToken': token,
        'Authorization': 'Bearer $token',
        'x-access-token': token,
      };

  Future<Map<String, dynamic>> _decode(http.Response response) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Invalid response received from server.');
    }
    if (decoded is! Map) throw Exception('Unexpected server response.');
    final result = Map<String, dynamic>.from(decoded);
    final ok = response.statusCode >= 200 && response.statusCode < 300 &&
        (result['success'] == true || result['status'] == true);
    if (!ok) {
      throw Exception(result['message']?.toString() ?? 'Request failed.');
    }
    return result;
  }

  Future<void> _fetchAvatar() async {
    try {
      final token = await _token();
      final response = await http.get(
        _avatarUri.replace(path: '${_avatarUri.path}/me/avatar'),
        headers: _headers(token),
      );
      final result = await _decode(response);
      final data = result['data'];
      final image = data is Map ? data['profile_image'] : null;
      final url = image is Map ? image['url']?.toString() : null;
      if (!mounted) return;
      setState(() => avatarUrl = (url == null || url.isEmpty) ? null : url);
      await UserSession.updateUser({
        'profile_image': image is Map
            ? Map<String, dynamic>.from(image)
            : {'url': null, 'public_id': null},
      });
    } catch (e) {
      debugPrint('Avatar fetch failed: $e');
    }
  }

  Future<void> _showPhotoOptions() async {
    if (uploadingAvatar || removingAvatar || savingName) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: blue),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: blue),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(ImageSource.gallery);
              },
            ),
            if (avatarUrl != null && avatarUrl!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove profile photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _removeAvatar();
                },
              ),
          ]),
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      final photo = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (photo == null) return;
      final bytes = await photo.readAsBytes();
      if (bytes.isEmpty || bytes.length > 2 * 1024 * 1024) {
        _message(bytes.isEmpty ? 'Selected photo is empty.' : 'Choose a photo smaller than 2 MB.');
        return;
      }

      String ext;
      MediaType type;
      final png = bytes.length >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 &&
          bytes[2] == 0x4E && bytes[3] == 0x47 && bytes[4] == 0x0D &&
          bytes[5] == 0x0A && bytes[6] == 0x1A && bytes[7] == 0x0A;
      final jpg = bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
      if (png) {
        ext = 'png';
        type = MediaType('image', 'png');
      } else if (jpg) {
        ext = 'jpg';
        type = MediaType('image', 'jpeg');
      } else {
        _message('Only PNG and JPEG photos are supported.');
        return;
      }

      setState(() {
        uploadingAvatar = true;
        previewBytes = bytes;
      });
      final token = await _token();
      final request = http.MultipartRequest(
        'PATCH',
        _avatarUri.replace(path: '${_avatarUri.path}/updateAvatar'),
      )..headers.addAll(_headers(token));
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        bytes,
        filename: 'profile.$ext',
        contentType: type,
      ));
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      final result = await _decode(response);
      final data = result['data'];
      final image = data is Map ? data['profile_image'] : null;
      final url = image is Map ? image['url']?.toString() : null;
      if (url == null || url.isEmpty) throw Exception('Photo uploaded but image URL was missing.');
      await UserSession.updateUser({
        'profile_image': Map<String, dynamic>.from(image as Map),
      });
      if (!mounted) return;
      setState(() {
        avatarUrl = url;
        previewBytes = null;
      });
      _message('Profile photo updated successfully.');
    } catch (e) {
      if (mounted) setState(() => previewBytes = null);
      _message(_cleanError(e));
    } finally {
      if (mounted) setState(() => uploadingAvatar = false);
    }
  }

  Future<void> _removeAvatar() async {
    setState(() => removingAvatar = true);
    try {
      final token = await _token();
      final response = await http.delete(
        _avatarUri.replace(path: '${_avatarUri.path}/deleteAvatar'),
        headers: _headers(token),
      );
      await _decode(response);
      await UserSession.updateUser({'profile_image': {'url': null, 'public_id': null}});
      if (!mounted) return;
      setState(() {
        avatarUrl = null;
        previewBytes = null;
      });
      _message('Profile photo removed.');
    } catch (e) {
      _message(_cleanError(e));
    } finally {
      if (mounted) setState(() => removingAvatar = false);
    }
  }

  Future<void> _editName() async {
    final currentName = (user['name'] ?? '').toString().trim();
    final parts = currentName.split(RegExp(r'\s+'));
    final first = TextEditingController(text: parts.isEmpty ? '' : parts.first);
    final last = TextEditingController(text: parts.length > 1 ? parts.skip(1).join(' ') : '');
    final formKey = GlobalKey<FormState>();

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit full name', style: TextStyle(color: navy, fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: first,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration('First name'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter first name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: last,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration('Last name'),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: blue),
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(dialogContext, true);
            },
            child: const Text('Save name'),
          ),
        ],
      ),
    );

    if (accepted == true) await _saveName(first.text.trim(), last.text.trim());
    first.dispose();
    last.dispose();
  }

  Future<void> _saveName(String first, String last) async {
    setState(() => savingName = true);
    try {
      final token = await _token();
      // Email is deliberately not editable; send the existing email unchanged
      // because the backend contract requires the email field in this request.
      final existingEmail = (user['email'] ?? '').toString();
      final response = await http.patch(
        _profileUri,
        headers: {..._headers(token), 'Content-Type': 'application/json'},
        body: jsonEncode({'firstName': first, 'lastName': last, 'email': existingEmail}),
      );
      final result = await _decode(response);
      final fullName = [first, last].where((s) => s.isNotEmpty).join(' ');
      final data = result['data'];
      final returnedUser = data is Map && data['user'] is Map ? Map<String, dynamic>.from(data['user'] as Map) : <String, dynamic>{};
      await UserSession.updateUser({
        'name': fullName,
        if (returnedUser['profile_image'] != null) 'profile_image': returnedUser['profile_image'],
      });
      if (!mounted) return;
      setState(() => user['name'] = fullName);
      _message('Name updated successfully.');
    } catch (e) {
      _message(_cleanError(e));
    } finally {
      if (mounted) setState(() => savingName = false);
    }
  }

  String _cleanError(Object error) => error.toString().replaceFirst('Exception: ', '');

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  String _value(dynamic v, [String fallback = 'Not added']) =>
      v == null || v.toString().trim().isEmpty ? fallback : v.toString().trim();

  String _addressText(Map a) {
    final parts = <String>[];
    for (final key in ['address_line1', 'address_line2', 'landmark']) {
      final v = a[key]?.toString().trim();
      if (v != null && v.isNotEmpty) parts.add(v);
    }
    final city = a['city_id'];
    if (city is Map && city['city_name'] != null) parts.add(city['city_name'].toString());
    final pin = a['postal_code']?.toString();
    if (pin != null && pin.isNotEmpty) parts.add(pin);
    return parts.isEmpty ? 'Address details unavailable' : parts.join(', ');
  }

  String _label(dynamic label) {
    final raw = (label ?? 'ADDRESS').toString().toUpperCase();
    if (raw == 'HOME') return 'Home';
    if (raw == 'WORK' || raw == 'OFFICE') return 'Office';
    if (raw == 'OTHER') return 'Other';
    return raw[0] + raw.substring(1).toLowerCase();
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: canvas,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE1E7EF))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE1E7EF))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: blue, width: 1.5)),
      );

  Future<void> _openAddresses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedAddressesScreen(addresses: addresses),
      ),
    );
    final cached = await UserSession.getUser();
    if (!mounted) return;
    setState(() {
      addresses = cached['_cached_addresses'] is List
          ? List<dynamic>.from(cached['_cached_addresses'] as List)
          : <dynamic>[];
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Logout')),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => loggingOut = true);
    try { await AuthApiService.logout(); } catch (e) { debugPrint('Logout API error: $e'); }
    await UserSession.clearUser();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final fullName = _value(user['name'], 'Your Name');
    final mobile = _value(user['mobile']);
    final email = _value(user['email']);
    final ImageProvider? avatar = previewBytes != null
        ? MemoryImage(previewBytes!)
        : (avatarUrl != null && avatarUrl!.startsWith('http') ? NetworkImage(avatarUrl!) : null);

    return Scaffold(
      backgroundColor: canvas,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: blue))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: Color(0x0D0B1F3A), blurRadius: 18, offset: Offset(0, 7))],
                    ),
                    child: Column(children: [
                      InkWell(
                        onTap: _showPhotoOptions,
                        borderRadius: BorderRadius.circular(60),
                        child: Stack(clipBehavior: Clip.none, children: [
                          CircleAvatar(radius: 48, backgroundColor: const Color(0xFFEAF2FA), backgroundImage: avatar,
                            child: avatar == null ? const Icon(Icons.person_rounded, size: 52, color: blue) : null),
                          Positioned(right: -2, bottom: -1, child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(color: orange, shape: BoxShape.circle),
                            child: (uploadingAvatar || removingAvatar)
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                          )),
                        ]),
                      ),
                      const SizedBox(height: 14),
                      Text(fullName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, color: navy, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      Text(mobile, style: const TextStyle(color: Color(0xFF667085), fontSize: 14)),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeading(title: 'Personal Information'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: Column(children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: _leadingIcon(Icons.person_outline_rounded),
                        title: const Text('Full Name', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                        subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(fullName, style: const TextStyle(color: navy, fontSize: 15, fontWeight: FontWeight.w700))),
                        trailing: IconButton(
                          tooltip: 'Edit full name',
                          onPressed: savingName ? null : _editName,
                          icon: savingName ? const SizedBox(width: 19, height: 19, child: CircularProgressIndicator(strokeWidth: 2, color: blue)) : const Icon(Icons.edit_outlined, color: blue),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFEEF1F5)),
                      _detailTile(Icons.phone_outlined, 'Mobile Number', mobile),
                      const Divider(height: 1, color: Color(0xFFEEF1F5)),
                      _detailTile(Icons.email_outlined, 'Email Address', email),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _SectionHeading(title: 'My Addresses'),
                      TextButton.icon(
                        onPressed: _openAddresses,
                        icon: const Icon(Icons.manage_accounts_outlined, size: 18),
                        label: const Text('Manage'),
                        style: TextButton.styleFrom(foregroundColor: blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (addresses.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Row(children: [
                        Icon(Icons.location_on_outlined, color: blue),
                        SizedBox(width: 12),
                        Expanded(child: Text('No saved addresses yet. Add your address to continue.', style: TextStyle(color: Color(0xFF667085)))),
                      ]),
                    )
                  else
                    ...addresses.whereType<Map>().map((a) {
                      final isDefault = a['is_default'] == true;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _leadingIcon(Icons.location_on_outlined),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                              Text(_label(a['label']), style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
                              if (isDefault) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEAF5EF), borderRadius: BorderRadius.circular(20)), child: const Text('DEFAULT', style: TextStyle(color: Color(0xFF24834A), fontSize: 9, fontWeight: FontWeight.w800))),
                            ]),
                            const SizedBox(height: 7),
                            Text(_addressText(a), style: const TextStyle(color: Color(0xFF667085), height: 1.45)),
                          ])),
                        ]),
                      );
                    }),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openAddresses,
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: const Text('Add / Manage Addresses'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: blue,
                        side: const BorderSide(color: blue),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: loggingOut ? null : _logout,
                    icon: loggingOut ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.logout_rounded, color: Colors.red),
                    label: Text(loggingOut ? 'Logging out...' : 'Logout', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), side: const BorderSide(color: Color(0xFFFFD6D6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: KaamdarBottomNav(
        currentIndex: 2,
        onTap: (index) {
          widget.onTabSelected?.call(index);
        },
      ),
    );
  }

  Widget _detailTile(IconData icon, String title, String value) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _leadingIcon(icon),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
        subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(value, style: const TextStyle(color: navy, fontSize: 15, fontWeight: FontWeight.w700))),
      );

  Widget _leadingIcon(IconData icon) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: const Color(0xFFEAF2FA), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: blue, size: 20),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 17, color: Color(0xFF0B1F3A), fontWeight: FontWeight.w800));
}
