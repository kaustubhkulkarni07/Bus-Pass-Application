import 'package:flutter/material.dart';

class GeneratePassPage extends StatefulWidget {
  const GeneratePassPage({super.key});

  @override
  State<GeneratePassPage> createState() => _GeneratePassPageState();
}

class _GeneratePassPageState extends State<GeneratePassPage> {
  final List<String> _sourceStations = ['Ichalkaranji', 'Kolhapur', 'Sangli'];
  final List<String> _destinationStations = ['Kolhapur', 'Sangli', 'Miraj'];
  final Map<String, List<String>> _passDurations = {
    'Monthly': ['1 Month - ₹500', '6 Month - ₹2500'],
    'Quarterly': ['3 Months - ₹1350'],
    'Half-Yearly': ['6 Months - ₹2600'],
    'Yearly': ['12 Months - ₹4800'],
  };
  final List<String> _paymentMethods = ['Google Pay', 'UPI ID', 'Phone Pay', 'Credit/Debit Card'];

  String? _selectedSource;
  String? _selectedDestination;
  String? _selectedDuration;
  String? _selectedPaymentMethod;
  double _totalAmount = 0.0;

  bool _durationExpanded = false;
  bool _paymentExpanded = false;
  bool _showUpiTextField = false;
  TextEditingController _upiIdController = TextEditingController();
  String? _upiIdError;

  @override
  void initState() {
    super.initState();
  }

  void _updateTotalAmount() {
    if (_selectedDuration?.contains('₹') ?? false) {
      final priceString = _selectedDuration!.split('₹').last;
      setState(() => _totalAmount = double.tryParse(priceString) ?? 0.0);
    } else {
      setState(() => _totalAmount = 0.0);
    }
  }

  String? _validateUpiId(String? value) {
    if (_showUpiTextField) {
      if (value == null || value.isEmpty) {
        return 'UPI ID is required';
      }
      if (!RegExp(r'^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$').hasMatch(value)) {
        return 'Enter a valid UPI ID format (e.g., abc@xyz)';
      }
    }
    return null;
  }

  void _validateAndProceedPayment() {
    final upiError = _validateUpiId(_upiIdController.text);
    setState(() {
      _upiIdError = upiError;
    });

    if (_selectedSource != null &&
        _selectedDestination != null &&
        _selectedDuration != null &&
        _selectedPaymentMethod != null &&
        (!_showUpiTextField || upiError == null)) {
      String paymentInfo = _selectedPaymentMethod!;
      if (_showUpiTextField) {
        paymentInfo += ' (UPI ID: ${_upiIdController.text})';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proceeding to Payment with $paymentInfo...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required details and enter a valid UPI ID if selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Your Pass'),
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildDropdown(
                    labelText: 'From Station',
                    icon: Icons.location_on_outlined,
                    value: _selectedSource,
                    items: _sourceStations,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSource = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    labelText: 'To Station',
                    icon: Icons.pin_drop_outlined,
                    value: _selectedDestination,
                    items: _destinationStations,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDestination = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildExpandableSection(
              title: 'SELECT DURATION',
              icon: Icons.timer_outlined,
              isExpanded: _durationExpanded,
              onTap: () {
                setState(() {
                  _durationExpanded = !_durationExpanded;
                  _paymentExpanded = false;
                });
              },
              children: _durationExpanded
                  ? _passDurations.values.expand((list) => list).map((duration) {
                      return _buildOptionItem(
                        title: duration.split(' - ')[0],
                        subtitle: duration.split(' - ').length > 1 ? 'Price: ${duration.split(' - ')[1]}' : null,
                        isSelected: _selectedDuration == duration,
                        onTap: () {
                          setState(() {
                            _selectedDuration = duration;
                            _durationExpanded = false;
                            _updateTotalAmount();
                            _selectedPaymentMethod = null;
                            _showUpiTextField = false;
                            _upiIdController.clear();
                            _upiIdError = null;
                          });
                        },
                      );
                    }).toList()
                  : [],
            ),
            const SizedBox(height: 12),
            _buildExpandableSection(
              title: 'Payment Options',
              icon: Icons.payment_outlined,
              isExpanded: _paymentExpanded,
              onTap: () {
                setState(() {
                  _paymentExpanded = !_paymentExpanded;
                  _durationExpanded = false;
                });
              },
              children: _paymentExpanded
                  ? _paymentMethods.map((method) {
                      return _buildOptionItem(
                        title: method,
                        isSelected: _selectedPaymentMethod == method,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method;
                            _paymentExpanded = false;
                            _showUpiTextField = method == 'UPI ID';
                            _upiIdError = null;
                          });
                        },
                      );
                    }).toList()
                  : [],
            ),
            const SizedBox(height: 12),
            if (_showUpiTextField)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  controller: _upiIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Enter UPI ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
                    errorText: _upiIdError,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _upiIdError = _validateUpiId(value);
                    });
                  },
                ),
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pass Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('From: ${_selectedSource ?? 'Not Selected'}'),
                  Text('To: ${_selectedDestination ?? 'Not Selected'}'),
                  Text('Duration: ${_selectedDuration?.split(' - ')[0] ?? 'Not Selected'}'),
                  Text('Total: ₹${_totalAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedSource != null &&
                      _selectedDestination != null &&
                      _selectedDuration != null &&
                      _selectedPaymentMethod != null &&
                      (!_showUpiTextField || _upiIdError == null))
                  ? _validateAndProceedPayment
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[500],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'PAY NOW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: Please ensure all details are correct before proceeding with payment.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            icon: Icon(icon, color: Colors.grey[600]),
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData? icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(icon, color: Colors.indigo[400]),
                        ),
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
          color: isSelected ? Colors.indigo[50]?.withOpacity(0.8) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}