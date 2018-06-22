// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io' as io;
import 'dart:js';

import 'package:node_interop/dns.dart';
import 'package:node_interop/net.dart';

export 'dart:io' show InternetAddressType;

class InternetAddress implements io.InternetAddress {
  static const int _IPV6_ADDR_LENGTH = 16;

  final String _host;
  final List<int> _inAddr;

  @override
  final String address;

  @override
  String get host => _host ?? address;

  @override
  io.InternetAddressType get type => net.isIPv4(address)
      ? io.InternetAddressType.IPv4
      : io.InternetAddressType.IPv6;

  // This probably shouldn't have been in the interface because dart:io
  // version does not implement this setter.
  set type(io.InternetAddressType value) =>
      throw new UnsupportedError('Setting address type is not allowed.');

  InternetAddress._(this.address, [this._host])
      : _inAddr = _inet_pton(address) {
    if (net.isIP(address) == 0)
      throw new ArgumentError('${address} is not valid.');
  }

  factory InternetAddress(String address) => new InternetAddress._(address);

  static Future<List<io.InternetAddress>> lookup(String host) {
    Completer<List<io.InternetAddress>> completer = new Completer();
    var options = new DNSLookupOptions(all: true, verbatim: true);

    void handleLookup(error, result) {
      if (error != null) {
        completer.completeError(error);
      } else {
        final addresses = new List<DNSAddress>.from(result);
        var list = addresses
            .map((item) => new InternetAddress._(item.address, host))
            .toList(growable: false);
        completer.complete(list);
      }
    }

    dns.lookup(host, options, allowInterop(handleLookup));
    return completer.future;
  }

  @override
  bool get isLinkLocal {
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IPv4:
        // Checking for 169.254.0.0/16.
        return _inAddr[0] == 169 && _inAddr[1] == 254;
      case io.InternetAddressType.IPv6:
        // Checking for fe80::/10.
        return _inAddr[0] == 0xFE && (_inAddr[1] & 0xB0) == 0x80;
    }
    throw new StateError('Unreachable');
  }

  @override
  bool get isLoopback {
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IPv4:
        return _inAddr[0] == 127;
      case io.InternetAddressType.IPv6:
        for (int i = 0; i < _IPV6_ADDR_LENGTH - 1; i++) {
          if (_inAddr[i] != 0) return false;
        }
        return _inAddr[_IPV6_ADDR_LENGTH - 1] == 1;
    }
    throw new StateError('Unreachable');
  }

  @override
  bool get isMulticast {
    // Copied from dart:io
    switch (type) {
      case io.InternetAddressType.IPv4:
        // Checking for 224.0.0.0 through 239.255.255.255.
        return _inAddr[0] >= 224 && _inAddr[0] < 240;
      case io.InternetAddressType.IPv6:
        // Checking for ff00::/8.
        return _inAddr[0] == 0xFF;
    }
    throw new StateError('Unreachable');
  }

  @override
  List<int> get rawAddress => new List.from(_inAddr);

  @override
  Future<io.InternetAddress> reverse() {
    final Completer<io.InternetAddress> completer = new Completer();
    void reverseResult(error, List<String> hostnames) {
      if (error != null) {
        completer.completeError(error);
      } else {
        completer.complete(new InternetAddress._(address, hostnames.first));
      }
    }

    dns.reverse(address, allowInterop(reverseResult));
    return completer.future;
  }

  @override
  String toString() => '$address';
}

const int _kColon = 58;

/// Best-effort implementation of native inet_pton.
///
/// This implementation assumes that [ip] address has been validated for
/// correctness.
List<int> _inet_pton(String ip) {
  if (ip.contains(':')) {
    // ipv6
    final List<int> result = new List<int>.filled(16, 0);

    // Special cases:
    if (ip == '::') return result;
    if (ip == '::1') return result..[15] = 1;

    const int maxSingleColons = 7;

    int totalColons = ip.codeUnits.where((code) => code == _kColon).length;
    bool hasDoubleColon = ip.contains('::');
    int singleColons = hasDoubleColon ? (totalColons - 1) : totalColons;
    int skippedSegments = maxSingleColons - singleColons;

    StringBuffer segment = new StringBuffer();
    int pos = 0;
    for (var i = 0; i < ip.length; i++) {
      if (i > 0 && ip[i] == ':' && ip[i - 1] == ':') {
        /// We don't need to set bytes to zeros as our [result] array is
        /// prefilled with zeros already, so we just need to shift our position
        /// forward.
        pos += 2 * skippedSegments;
      } else if (ip[i] == ':') {
        if (segment.isEmpty) segment.write('0');
        int value = int.parse(segment.toString(), radix: 16);
        result[pos] = value ~/ 256;
        result[pos + 1] = value % 256;
        pos += 2;
        segment.clear();
      } else {
        segment.write(ip[i]);
      }
    }
    // Don't forget about the last segment:
    if (segment.isEmpty) segment.write('0');
    int value = int.parse(segment.toString(), radix: 16);
    result[pos] = value ~/ 256;
    result[pos + 1] = value % 256;
    return result;
  } else {
    // ipv4
    return ip.split('.').map(int.parse).toList(growable: false);
  }
}
