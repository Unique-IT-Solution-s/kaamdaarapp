
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

const Color addressBlue = Color(0xFF1261A0);
const Color addressLightBlue = Color(0xFFD6E5F2);
const Color addressOrange = Color(0xFFFF8000);

class AddressData {
  final String fullAddress;
  final String house;
  final String landmark;
  final String type;

  AddressData({
    required this.fullAddress,
    required this.house,
    required this.landmark,
    required this.type,
  });
}

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  final _house = TextEditingController();
  final _landmark = TextEditingController();

  String _type = 'Home';

  @override
  void dispose() {
    _address.dispose();
    _house.dispose();
    _landmark.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressData(
      fullAddress: _address.text.trim(),
      house: _house.text.trim(),
      landmark: _landmark.text.trim(),
      type: _type,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SavedAddressesScreen(
          addresses: [address],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController controller, {
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          validator: optional
              ? null
              : (value) => value == null || value.trim().isEmpty
                  ? 'This field is required'
                  : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 12),
                _backButton(context),
                const SizedBox(height: 12),

                // Map preview placeholder.
                Container(
                  height: 175,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EFF2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: addressBlue,
                          size: 42,
                        ),
                        Text(
                          'Select your location on map',
                          style: TextStyle(color: addressBlue),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _field(
                  'Full Address',
                  'Enter your Full Address',
                  _address,
                ),
                const SizedBox(height: 15),
                _field(
                  'House Flat, Building No',
                  'Eg. Sunshine Apartment',
                  _house,
                ),
                const SizedBox(height: 15),
                _field(
                  'Landmark (optional)',
                  'Eg. Near City Mall',
                  _landmark,
                  optional: true,
                ),

                const SizedBox(height: 18),
                const Text('Save As'),
                const SizedBox(height: 10),

                Row(
                  children: ['Home', 'Work', 'Other'].map((type) {
                    final selected = _type == type;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _type = type);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: selected
                                ? addressLightBlue
                                : Colors.white,
                            foregroundColor: addressBlue,
                          ),
                          child: Text(type),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _saveAddress,
                    style: FilledButton.styleFrom(
                      backgroundColor: addressLightBlue,
                      foregroundColor: addressBlue,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Save Address'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    _addresses = List.from(widget.addresses);
  }

  Future<void> _addAddress() async {
    final result = await Navigator.push<AddressData>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _addresses.add(result);
      });
    }
  }

  void _continue() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultAddress = _addresses[_defaultIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _backButton(context),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: addressLightBlue,
                  borderRadius: BorderRadius.circular(13),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(defaultAddress.type),
                          const SizedBox(height: 5),
                          Text(
                            '${defaultAddress.house}, '
                            '${defaultAddress.fullAddress}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.home,
                      color: addressOrange,
                      size: 48,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.type,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${address.house}, '
                                    '${address.fullAddress}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Checkbox(
                                          value: _defaultIndex == index,
                                          activeColor: addressOrange,
                                          onChanged: (_) {
                                            setState(() {
                                              _defaultIndex = index;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Set as default address',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: addressBlue,
                              ),
                              onPressed: () {
                                if (_addresses.length == 1) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'At least one address is required.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _addresses.removeAt(index);
                                  if (_defaultIndex >=
                                      _addresses.length) {
                                    _defaultIndex =
                                        _addresses.length - 1;
                                  } else if (_defaultIndex > index) {
                                    _defaultIndex--;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: _addAddress,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: addressBlue,
                    side: const BorderSide(color: addressBlue),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 13),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: addressLightBlue,
                    foregroundColor: addressBlue,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _backButton(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(30),
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: addressOrange,
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 17,
        ),
      ),
    ),
  );
}
