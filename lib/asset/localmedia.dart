part of masamune.mobile;

/// Get video or image from camera or library.
class LocalMedia extends AssetUnit<File> {
  final ImagePicker _picker = ImagePicker();
  File _file;
  Uint8List _bytes;

  /// Media type.
  MediaType get mediaType => this._mediaType;
  MediaType _mediaType;

  /// Get the file.
  File get file => this._file;

  /// Get the byte data.
  Uint8List get bytes => this._bytes;

  /// Create a Completer that matches the class.
  ///
  /// Do not use from external class.
  @override
  Completer createCompleter() => Completer<LocalMedia>();

  /// Process to create a new instance.
  ///
  /// Do not use from outside the class.
  ///
  /// [path]: Destination path.
  /// [isTemporary]: True if the data is temporary.
  @override
  T createInstance<T extends IClonable>(String path, bool isTemporary) =>
      LocalMedia._(path, this.mediaType) as T;

  /// Get image from camera or library by path.
  ///
  /// [path]: File path.
  /// [source]: Media source.
  /// [directoryType]: Directory destination to save.
  static Future<LocalMedia> imageFromPath(String path) {
    assert(isNotEmpty(path));
    if (isEmpty(path)) {
      Log.error("The path is invalid.");
      return Future.delayed(Duration.zero);
    }
    LocalMedia unit = PathMap.get<LocalMedia>(path);
    if (unit != null) {
      unit._mediaType = MediaType.image;
      unit._load();
      return unit.future;
    }
    unit = LocalMedia._(path, MediaType.image);
    unit._pickImage();
    return unit.future;
  }

  /// Get video from camera or library by path.
  ///
  /// [path]: File path.
  /// [source]: Media source.
  /// [directoryType]: Directory destination to save.
  static Future<LocalMedia> videoFromPath(String path) {
    assert(isNotEmpty(path));
    if (isEmpty(path)) {
      Log.error("The path is invalid.");
      return Future.delayed(Duration.zero);
    }
    LocalMedia unit = PathMap.get<LocalMedia>(path);
    if (unit != null) {
      unit._mediaType = MediaType.video;
      unit._load();
      return unit.future;
    }
    unit = LocalMedia._(path, MediaType.video);
    unit._load();
    return unit.future;
  }

  /// Get image from camera or library.
  ///
  /// [path]: File path.
  /// [source]: Media source.
  /// [directoryType]: Directory destination to save.
  static Future<LocalMedia> image(String path,
      {ImageSource source = ImageSource.camera}) {
    assert(isNotEmpty(path));
    if (isEmpty(path)) {
      Log.error("The path is invalid.");
      return Future.delayed(Duration.zero);
    }
    LocalMedia unit = PathMap.get<LocalMedia>(path);
    if (unit != null) {
      unit._mediaType = MediaType.image;
      unit._pickImage(
        source: source,
      );
      return unit.future;
    }
    unit = LocalMedia._(path, MediaType.image);
    unit._pickImage(
      source: source,
    );
    return unit.future;
  }

  /// Get video from camera or library.
  ///
  /// [path]: File path.
  /// [source]: Media source.
  /// [directoryType]: Directory destination to save.
  static Future<LocalMedia> video(
    String path, {
    ImageSource source = ImageSource.camera,
  }) {
    assert(isNotEmpty(path));
    if (isEmpty(path)) {
      Log.error("The path is invalid.");
      return Future.delayed(Duration.zero);
    }
    LocalMedia unit = PathMap.get<LocalMedia>(path);
    if (unit != null) {
      unit._mediaType = MediaType.video;
      unit._pickVideo(
        source: source,
      );
      return unit.future;
    }
    unit = LocalMedia._(path, MediaType.video);
    unit._pickVideo(
      source: source,
    );
    return unit.future;
  }

  /// Delete the file.
  ///
  /// [path]: File path.
  /// [directoryType]: Directory destination to save.
  static Future delete(String path) async {
    assert(isNotEmpty(path));
    if (isEmpty(path)) {
      Log.error("The path is invalid.");
      return;
    }
    LocalMedia unit = PathMap.get<LocalMedia>(path);
    if (unit != null) {
      if (unit.file != null) {
        unit.file.delete();
      } else {
        File file = File(unit.path);
        if (file != null) file.delete();
      }
      unit.dispose();
      return;
    }
    File file = File(path);
    if (file != null) file.delete();
  }

  LocalMedia._(String path, MediaType mediaType)
      : this._mediaType = mediaType,
        super(path: path, isTemporary: false, order: 10, group: 0);

  void _pickImage({ImageSource source}) async {
    try {
      this.init();
      PickedFile pickedFile = await this._picker.getImage(source: source);
      if (pickedFile == null || isEmpty(pickedFile.path)) {
        this.error("The file was not found.");
        return;
      }
      this._file = File(pickedFile.path);
      this._file = await this._file.copy(this.path);
      this._bytes = await this._file.readAsBytes();
      this.done();
    } catch (e) {
      this.error(e.toString());
    }
  }

  void _pickVideo({ImageSource source}) async {
    try {
      this.init();
      PickedFile pickedFile = await this._picker.getVideo(source: source);
      if (pickedFile == null || isEmpty(pickedFile.path)) {
        this.error("The file was not found.");
        return;
      }
      this._file = File(pickedFile.path);
      this._file = await this._file.copy(this.path);
      this._bytes = await this._file.readAsBytes();
      this.done();
    } catch (e) {
      this.error(e.toString());
    }
  }

  void _load() async {
    try {
      this.init();
      this._file = File(this.path);
      this._bytes = await this._file.readAsBytes();
      this.done();
    } catch (e) {
      this.error(e.toString());
    }
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    this._file = null;
    this._bytes = null;
    super.dispose();
  }
}

/// The type of media.
enum MediaType {
  /// Image.
  image,

  /// Video.
  video
}
