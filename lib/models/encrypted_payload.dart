class EncryptedPayload {
  final String ciphertext;
  final String nonce;
  final String mac;

  EncryptedPayload({
    required this.ciphertext,
    required this.nonce,
    required this.mac,
  });

  Map<String, dynamic> toJson() {
    return {
      'ciphertext': ciphertext,
      'nonce': nonce,
      'mac': mac,
    };
  }

  factory EncryptedPayload.fromJson(Map<String, dynamic> json) {
    return EncryptedPayload(
      ciphertext: json['ciphertext'],
      nonce: json['nonce'],
      mac: json['mac'],
    );
  }
}





