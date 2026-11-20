
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceName;
  final IconData serviceIcon;
  final Color serviceColor;
  final String? serviceImage;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.serviceIcon,
    required this.serviceColor,
    this.serviceImage, 
  });

  @override
  State<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  int? selectedTask;

  late final List<_ServiceTask> tasks;
  late final AnimationController _heroController;
  late final Animation<double> _heroFloat;
  late final Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();
    tasks = _getTasks(widget.serviceName);

    // Subtle floating + breathing animation for the service icon.
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _heroFloat = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );
    _heroScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  // SERVICE-WISE TASKS
  List<_ServiceTask> _getTasks(String name) {
    switch (name.toLowerCase()) {
      case 'ac cleaning':
      case 'ac repair':
        return [
          _ServiceTask('Cleaning', Icons.cleaning_services_rounded, 499),
          _ServiceTask('Gas Refill', Icons.local_gas_station_rounded, 1499),
          _ServiceTask('Repair', Icons.build_rounded, 399),
          _ServiceTask('Installation', Icons.install_desktop, 999),
        ];

      case 'plumbing':
        return [
          _ServiceTask('Tap Repair', Icons.water_drop_rounded, 199),
          _ServiceTask('Pipe Leakage', Icons.plumbing_rounded, 299),
          _ServiceTask('Drain Cleaning', Icons.cleaning_services, 399),
          _ServiceTask('Installation', Icons.build_rounded, 499),
        ];

      case 'painting':
        return [
          _ServiceTask('Interior', Icons.format_paint_rounded, 499),
          _ServiceTask('Exterior', Icons.house_rounded, 699),
          _ServiceTask('Wall Repair', Icons.home_repair_service, 299),
          _ServiceTask('Texture', Icons.brush_rounded, 899),
        ];

      case 'gardening':
        return [
          _ServiceTask('Plant Care', Icons.local_florist, 199),
          _ServiceTask('Lawn Cleaning', Icons.grass, 299),
          _ServiceTask('Trimming', Icons.content_cut, 249),
          _ServiceTask('Landscaping', Icons.park, 999),
        ];

      case 'salon':
        return [
          _ServiceTask('Haircut', Icons.content_cut_rounded, 199),
          _ServiceTask('Beard Grooming', Icons.face, 149),
          _ServiceTask('Facial', Icons.spa_rounded, 499),
          _ServiceTask('Hair Styling', Icons.brush_rounded, 299),
        ];

      case 'dish washing':
        return [
          _ServiceTask('Utensils', Icons.dining_rounded, 199),
          _ServiceTask('Kitchen', Icons.kitchen_rounded, 299),
          _ServiceTask('Deep Cleaning', Icons.cleaning_services, 499),
          _ServiceTask('Daily Help', Icons.wash_rounded, 249),
        ];

      case 'electrician':
        return [
          _ServiceTask('Fan Repair', Icons.toys, 199),
          _ServiceTask('Wiring', Icons.electrical_services, 399),
          _ServiceTask('Switch Repair', Icons.toggle_on, 149),
          _ServiceTask('Installation', Icons.build_rounded, 299),
        ];

      case 'home cleaning':
        return [
          _ServiceTask('Room Cleaning', Icons.weekend_rounded, 299),
          _ServiceTask('Bathroom', Icons.bathroom_rounded, 249),
          _ServiceTask('Kitchen', Icons.kitchen_rounded, 299),
          _ServiceTask('Deep Cleaning', Icons.cleaning_services, 699),
        ];

      case 'carpenter':
        return [
          _ServiceTask('Furniture Repair', Icons.chair_rounded, 299),
          _ServiceTask('Door Repair', Icons.door_front_door, 249),
          _ServiceTask('Assembly', Icons.handyman_rounded, 399),
          _ServiceTask('Installation', Icons.build_rounded, 299),
        ];

      case 'pest control':
        return [
          _ServiceTask('Cockroach', Icons.bug_report, 499),
          _ServiceTask('Termite', Icons.pest_control, 999),
          _ServiceTask('Mosquito', Icons.pest_control_rounded, 399),
          _ServiceTask('General Pest', Icons.home_work, 599),
        ];

      case 'appliance repair':
        return [
          _ServiceTask('Washing Machine', Icons.local_laundry_service, 399),
          _ServiceTask('Refrigerator', Icons.kitchen, 499),
          _ServiceTask('Microwave', Icons.microwave, 299),
          _ServiceTask('Other Appliance', Icons.home_repair_service, 499),
        ];

      case 'water purifier':
        return [
          _ServiceTask('Filter Change', Icons.water_drop, 299),
          _ServiceTask('RO Repair', Icons.build, 399),
          _ServiceTask('Servicing', Icons.cleaning_services, 249),
          _ServiceTask('Installation', Icons.install_desktop, 499),
        ];

      default:
        return [
          _ServiceTask('Cleaning', Icons.cleaning_services, 299),
          _ServiceTask('Repair', Icons.build, 399),
          _ServiceTask('Maintenance', Icons.handyman, 299),
          _ServiceTask('Installation', Icons.install_desktop, 499),
        ];
    }
  }

  // SELECTED PRICE
  int get _price {
    if (selectedTask == null) {
      return tasks
          .map((task) => task.price)
          .reduce((a, b) => a < b ? a : b);
    }

    return tasks[selectedTask!].price;
  }

  // SERVICE DESCRIPTION
  String get _description {
    if (selectedTask == null) {
      return 'Choose the service you need. Our trained professionals '
          'provide reliable and quality doorstep services.';
    }

    final task = tasks[selectedTask!];

    return 'Get professional ${task.name.toLowerCase()} service '
        'for your ${widget.serviceName.toLowerCase()} needs. '
        'Our service professionals focus on quality workmanship '
        'and reliable support at your doorstep.';
  }

  // BOOK INSTANT
  void _bookInstant() {
    if (selectedTask == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service first.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Confirm Service'),
        content: Text(
          '${widget.serviceName}\n'
          '${tasks[selectedTask!].name}\n'
          'Starting price: ₹$_price',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Service selected. Booking integration is pending.',
                  ),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  // SCHEDULE LATER
  Future<void> _scheduleLater() async {
    if (selectedTask == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service first.'),
        ),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tasks[selectedTask!].name} selected for '
          '${date.day}/${date.month}/${date.year} '
          'at ${time.format(context)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1261A0),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        // APP BAR
        appBar: AppBar(
          backgroundColor: KaamdarColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: const Text(
            'Service',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // MAIN BODY
        body: Column(
          children: [
            // COMMON SERVICE BACKGROUND + SERVICE-WISE ICON/IMAGE
            // Keep only one background file for every service:
            // assets/services/service_bg.png
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/services/service_bg1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: AnimatedBuilder(
                animation: _heroController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _heroFloat.value),
                    child: Transform.scale(
                      scale: _heroScale.value,
                      child: child,
                    ),
                  );
                },
                child: widget.serviceImage != null &&
                        widget.serviceImage!.trim().isNotEmpty
                    ? Image.asset(
                        widget.serviceImage!,
                        width: 145,
                        height: 145,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          widget.serviceIcon,
                          color: KaamdarColors.blue,
                          size: 104,
                        ),
                      )
                    : Icon(
                        widget.serviceIcon,
                        color: KaamdarColors.blue,
                        size: 104,
                      ),
              ),
            ),

            // SERVICE DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 19, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SERVICE TITLE
                    Text(
                      '${widget.serviceName} Service and Repair',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF242424),
                      ),
                    ),

                    const SizedBox(height: 7),

                    // RATING
                    Row(
                      children: const [
                        Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB900),
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '4.8 (2.8k reviews)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // SERVICE OPTIONS
                    Row(
                      children: List.generate(tasks.length, (index) {
                        final task = tasks[index];
                        final isSelected = selectedTask == index;

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                selectedTask = index;
                              });
                            },
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    // Removed the orange outline around the circle.
                                    color: Color(0xFFDCEAF7),
                                    shape: BoxShape.circle,
                                  ),
                                  // Inner service icons stay static.
                                  child: Icon(
                                    task.icon,
                                    color: isSelected
                                        ? KaamdarColors.orange
                                        : KaamdarColors.blue,
                                    size: 27,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                SizedBox(
                                  height: 28,
                                  child: Center(
                                    child: Text(
                                      task.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? KaamdarColors.blue
                                            : Colors.black54,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    // ABOUT SERVICE - NO EXTRA SPACER
                    const SizedBox(height: 18),

                   const Text(
  'About this Service',
  style: TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    color: Color(0xFF242424),
  ),
),

                    const SizedBox(height: 9),

                    AnimatedSwitcher(
  duration: const Duration(milliseconds: 180),
  child: Text(
    _description,
    key: ValueKey(selectedTask),
    maxLines: 4,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 16,
      height: 1.55,
      color: Color(0xFF777777),
    ),
  ),
),

                    // FLEXIBLE SPACE BEFORE PRICE
                    const Spacer(),

                    // PRICE AND BOOK INSTANT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹$_price',
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Starting Price',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),

                        FilledButton(
                          onPressed: _bookInstant,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFDCEAF7),
                            foregroundColor: KaamdarColors.blue,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          child: const Text(
                            'Book Instant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // SCHEDULE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _scheduleLater,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDCEAF7),
                          foregroundColor: KaamdarColors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Color(0xFFCEE0F1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Schedule for later',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // BOTTOM NAVIGATION
        bottomNavigationBar: Container(
          color: KaamdarColors.blue,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  _BottomItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _BottomItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'Booking',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking screen coming soon.'),
                        ),
                      );
                    },
                  ),
                  _BottomItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile screen coming soon.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// SERVICE TASK MODEL
class _ServiceTask {
  final String name;
  final IconData icon;
  final int price;

  const _ServiceTask(this.name, this.icon, this.price);
}

// BOTTOM NAVIGATION ITEM
class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23, color: Colors.white),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
