class FileModel {
  final String fileName;
  final String path;
  final DateTime createdAt;
  final int size;

  FileModel({
    required this.fileName,
    required this.path,
    required this.createdAt,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
      'size': size,
    };
  }

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileName: json['fileName'],
      path: json['path'],
      createdAt: DateTime.parse(json['createdAt']),
      size: json['size'],
    );
  }
}