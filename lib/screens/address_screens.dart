
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

const Color addressBlue = Color(0xFF1261A0);
const Color addressLightBlue = Color(0xFFD6E5F2);
const Color addressOrange = Color(0xFFFF8000);

// ---------------------------------------------------------
// ADDRESS MODEL
// ---------------------------------------------------------

class AddressData {
  final String fullAddress;
  final String house;
  final String landmark;
  final String type;

  const AddressData({
    required this.fullAddress,
    required this.house,
    required this.landmark,
    required this.type,
  });

  String get completeAddress {
    return [
      house,
      fullAddress,
      if (landmark.trim().isNotEmpty) landmark,
    ].where((value) => value.trim().isNotEmpty).join(', ');
  }
}

// ---------------------------------------------------------
// ADD / EDIT ADDRESS SCREEN
// ---------------------------------------------------------

class AddAddressScreen extends StatefulWidget {
  final AddressData? initialAddress;

  const AddAddressScreen({
    super.key,
    this.initialAddress,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _address;
  late final TextEditingController _house;
  late final TextEditingController _landmark;

  late String _type;

  @override
  void initState() {
    super.initState();

    final old = widget.initialAddress;

    _address = TextEditingController(
      text: old?.fullAddress ?? '',
    );

    _house = TextEditingController(
      text: old?.house ?? '',
    );

    _landmark = TextEditingController(
      text: old?.landmark ?? '',
    );

    _type = old?.type ?? 'Home';
  }

  @override
  void dispose() {
    _address.dispose();
    _house.dispose();
    _landmark.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final result = AddressData(
      fullAddress: _address.text.trim(),
      house: _house.text.trim(),
      landmark: _landmark.text.trim(),
      type: _type,
    );

    Navigator.pop(context, result);
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          validator: optional
              ? null
              : (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF999999),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: addressBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _typeButton(String type) {
    final selected = _type == type;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: OutlinedButton(
          onPressed: () {
            setState(() => _type = type);
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 46),
            padding: EdgeInsets.zero,
            backgroundColor:
                selected ? addressLightBlue : Colors.white,
            foregroundColor: addressBlue,
            side: BorderSide(
              color: selected ? addressBlue : Colors.grey,
            ),
            shape: const StadiumBorder(),
          ),
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(30),
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: addressOrange,
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight - 28,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // BACK BUTTON
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _backButton(context),
                          ),

                          const SizedBox(height: 20),

                          // MAP PREVIEW
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4EFF2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 48,
                                        color: addressBlue,
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        'Select your location on map',
                                        style: TextStyle(
                                          color: addressBlue,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 12,
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Interactive map is not connected yet.',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 17,
                                    ),
                                    label: const Text('Edit on Map'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: addressBlue,
                                      foregroundColor: Colors.white,
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ADDRESS FIELDS
                          _field(
                            label: 'Full Address',
                            hint: 'Enter your Full Address',
                            controller: _address,
                          ),

                          const SizedBox(height: 18),

                          _field(
                            label: 'House Flat, Building No',
                            hint: 'Eg. Sunshine Apartment',
                            controller: _house,
                          ),

                          const SizedBox(height: 18),

                          _field(
                            label: 'Landmark (optional)',
                            hint: 'Eg. Near City Mall',
                            controller: _landmark,
                            optional: true,
                          ),

                          const SizedBox(height: 23),

                          const Text(
                            'Save As',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              _typeButton('Home'),
                              _typeButton('Work'),
                              _typeButton('Other'),
                            ],
                          ),

                          // Flexible space pushes Save Address down
                          // on taller screens. On shorter screens,
                          // the page remains scrollable.
                          SizedBox(
                            height: screenHeight > 700 ? 65 : 28,
                          ),

                          // SAVE BUTTON
                          SizedBox(
                            height: 54,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _saveAddress,
                              style: FilledButton.styleFrom(
                                backgroundColor: addressLightBlue,
                                foregroundColor: addressBlue,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                widget.initialAddress == null
                                    ? 'Save Address'
                                    : 'Update Address',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// SAVED ADDRESSES SCREEN
// ---------------------------------------------------------

class SavedAddressesScreen extends StatefulWidget {
  final List<AddressData> addresses;

  const SavedAddressesScreen({
    super.key,
    required this.addresses,
  });

  @override
  State<SavedAddressesScreen> createState() =>
      _SavedAddressesScreenState();
}

class _SavedAddressesScreenState
    extends State<SavedAddressesScreen> {
  late List<AddressData> _addresses;

  int _defaultIndex = 0;

  @override
  void initState() {
    super.initState();
    _addresses = List<AddressData>.from(widget.addresses);
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Home':
        return Icons.home_rounded;
      case 'Work':
        return Icons.work_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Future<void> _addAddress() async {
    final result = await Navigator.push<AddressData>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _addresses.add(result);
    });
  }

  Future<void> _editAddress(int index) async {
    final result = await Navigator.push<AddressData>(
      context,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(
          initialAddress: _addresses[index],
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _addresses[index] = result;
    });
  }

  void _deleteAddress(int index) {
    if (_addresses.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one address is required.'),
        ),
      );
      return;
    }

    setState(() {
      _addresses.removeAt(index);

      if (_defaultIndex == index) {
        _defaultIndex = 0;
      } else if (_defaultIndex > index) {
        _defaultIndex--;
      }
    });
  }

  void _continue() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  Widget _defaultAddressCard(AddressData address) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: addressLightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Default Address',
                  style: TextStyle(
                    color: addressBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  address.type,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address.completeAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/images/location_home.png',
            width: 75,
            height: 75,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                _typeIcon(address.type),
                size: 55,
                color: addressOrange,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _addressCard(AddressData address, int index) {
    final isDefault = _defaultIndex == index;

    return Card(
      elevation: 3,
      color: const Color(0xFFF4F3FA),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                _typeIcon(address.type),
                color: Colors.grey.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.type,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Edit address',
                        onPressed: () => _editAddress(index),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: addressBlue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    address.completeAddress,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Checkbox(
                        value: isDefault,
                        activeColor: addressOrange,
                        onChanged: (_) {
                          setState(() {
                            _defaultIndex = index;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Set as default address',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Delete address',
                        onPressed: () => _deleteAddress(index),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: addressBlue,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_addresses.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: TextButton.icon(
              onPressed: _addAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
            ),
          ),
        ),
      );
    }

    final defaultAddress = _addresses[_defaultIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _backButton(context),
                  ),

                  const SizedBox(height: 15),

                  _defaultAddressCard(defaultAddress),

                  const SizedBox(height: 15),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        return _addressCard(
                          _addresses[index],
                          index,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _addAddress,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add New Address',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: addressBlue,
                        side: const BorderSide(
                          color: addressBlue,
                          width: 1.2,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 13),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: addressLightBlue,
                        foregroundColor: addressBlue,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// SAVED ADDRESS BACK BUTTON
// ---------------------------------------------------------

Widget _backButton(BuildContext context) {
  return InkWell(
    onTap: () => Navigator.pop(context),
    borderRadius: BorderRadius.circular(30),
    child: const CircleAvatar(
      radius: 19,
      backgroundColor: addressOrange,
      child: Icon(
        Icons.arrow_back_ios_new,
        color: Colors.white,
        size: 17,
      ),
    ),
  );
}
