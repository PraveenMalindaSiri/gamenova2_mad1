import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo extends StatefulWidget {
  const NetworkInfo({super.key});

  @override
  State<NetworkInfo> createState() => _NetworkInfoState();
}

class _NetworkInfoState extends State<NetworkInfo> {
  final _conn = Connectivity();

  ConnectivityResult _type = ConnectivityResult.none;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  String _ip = '—';

  @override
  void initState() {
    super.initState();
    info();
  }

  Future<void> info() async {
    final res = await _conn.checkConnectivity();
    _type = _pickEffective(res);
    _ip = await _getIp(_type);
    if (mounted) setState(() {});

    _sub = _conn.onConnectivityChanged.listen((r) async {
      _type = _pickEffective(r);
      _ip = await _getIp(_type);
      if (mounted) setState(() {});
    });
  }

  ConnectivityResult _pickEffective(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi))
      return ConnectivityResult.wifi;
    if (results.contains(ConnectivityResult.mobile))
      return ConnectivityResult.mobile;
    if (results.contains(ConnectivityResult.ethernet))
      return ConnectivityResult.ethernet;
    if (results.contains(ConnectivityResult.vpn)) return ConnectivityResult.vpn;
    return ConnectivityResult.none;
  }

  Future<String> _getIp(ConnectivityResult type) async {
    if (type == ConnectivityResult.none) return '—';
    try {
      final ifs = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      for (final nif in ifs) {
        for (final a in nif.addresses) {
          if (!a.isLoopback) return a.address;
        }
      }
    } catch (_) {}
    return '—';
  }

  IconData get _icon {
    switch (_type) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_alt;
      case ConnectivityResult.ethernet:
        return Icons.settings_ethernet;
      case ConnectivityResult.vpn:
        return Icons.vpn_lock;
      default:
        return Icons.portable_wifi_off;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connected = _type != ConnectivityResult.none;
    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: connected
              ? Colors.green
              : Colors.red,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 10,),
          const SizedBox(width: 8),
          const Text('•', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8),
          Text('IP: $_ip', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
