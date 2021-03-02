part of masamune_mobile;

final localMediaProvider = ModelProvider.family<LocalMediaModel, String>(
    (_, path) => LocalMediaModel(path));

class LocalMediaModel extends ValueModel<LocalMedia> {
  LocalMediaModel(this.path) : super(const LocalMedia());

  final String path;

  final ImagePicker _picker = ImagePicker();

  Future<LocalMedia> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile == null || pickedFile.path.isEmpty) {
      throw Exception("The file was not found.");
    }
    final file = File(pickedFile.path);
    final copy = await file.copy(path);
    return value = LocalMedia(file: copy, assetType: AssetType.image);
  }

  Future<LocalMedia> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.getVideo(source: source);
    if (pickedFile == null || pickedFile.path.isEmpty) {
      throw Exception("The file was not found.");
    }
    final file = File(pickedFile.path);
    final copy = await file.copy(path);
    return value = LocalMedia(file: copy, assetType: AssetType.video);
  }

  /// Get image from camera or library.
  ///
  /// [source]: Media source.
  Future<LocalMedia> image({ImageSource source = ImageSource.camera}) async {
    assert(path.isNotEmpty, "The path is invalid.");
    final media = await _pickImage(source);
    streamController.sink.add(media);
    return media;
  }

  /// Get video from camera or library.
  ///
  /// [source]: Media source.
  Future<LocalMedia> video({ImageSource source = ImageSource.camera}) async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = await _pickVideo(source);
  }

  /// Delete the file.
  Future<void> delete() async {
    final file = File(path);
    await file.delete();
    value = const LocalMedia();
  }

  /// Get image from camera or library by path.
  Future<LocalMedia> loadImage() async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = LocalMedia(file: File(path), assetType: AssetType.image);
  }

  /// Get video from camera or library by path.
  ///
  /// [path]: File path.
  /// [source]: Media source.
  /// [directoryType]: Directory destination to save.
  Future<LocalMedia> loadVideo() async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = LocalMedia(file: File(path), assetType: AssetType.image);
  }
}

class LocalMedia {
  const LocalMedia({this.file, this.assetType = AssetType.none});
  final File? file;
  final AssetType assetType;
  bool get hasFile => file != null;
}
