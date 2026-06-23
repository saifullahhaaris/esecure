class EncryptedPayload {
  final String ciphertext;
  final String nonce;
  final String mac;

  const EncryptedPayload({
    required this.ciphertext,
    required this.nonce,
    required this.mac,
  });

  Map<String, String> toMap() {
    return {
      'ciphertext': ciphertext,
      'nonce': nonce,
      'mac': mac,
    };
  }

  factory EncryptedPayload.fromMap(Map<String, String> map) {
    return EncryptedPayload(
      ciphertext: map['ciphertext']!,
      nonce: map['nonce']!,
      mac: map['mac']!,
    );
  }
}
