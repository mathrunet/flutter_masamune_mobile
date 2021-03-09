part of masamune_mobile;

/// Displays a dialog to select media.
class UIMediaDialog {
  /// Displays a dialog to select media.
  ///
  /// [context]: Build context.
  /// [type]: Asset selection type.
  /// [imageLabel]: The image label.
  /// [videoLabel]: The video label.
  /// [cameraLabel]: The camera label.
  /// [libraryLabel]: The library label.
  /// [dialogTitlePath]: Dialog title path.
  /// [title]: Default title.
  /// [disableBackKey]: True to disable the back key.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  /// [willShowRepetition]: True if the dialog will continue to be displayed unless you press the regular close button.
  static Future<LocalMedia?> show(BuildContext context,
      {UIMediaDialogType type = UIMediaDialogType.both,
      required String title,
      String imageLabel = "Image",
      String videoLabel = "Video",
      String cameraLabel = "Taken with camera",
      String libraryLabel = "Read from library",
      bool disableBackKey = false,
      bool popOnPress = true,
      bool willShowRepetition = false}) async {
    Future<LocalMedia>? res;
    AssetType? assetType;
    switch (type) {
      case UIMediaDialogType.image:
        assetType = AssetType.image;
        break;
      case UIMediaDialogType.video:
        assetType = AssetType.video;
        break;
      default:
        await UISelectDialog.show(
          context,
          selectors: {
            imageLabel.localize(): () {
              assetType = AssetType.image;
            },
            videoLabel.localize(): () {
              assetType = AssetType.video;
            }
          },
          title: title,
          disableBackKey: disableBackKey,
          popOnPress: popOnPress,
          willShowRepetition: willShowRepetition,
        );
        break;
    }
    if (assetType == null) {
      return null;
    }
    final localMedia = readProvider(localMediaProvider(
        "${Config.temporaryDirectory.path}/$uuid.${assetType == AssetType.video ? "mp4" : "jpg"}"));
    await UISelectDialog.show(
      context,
      selectors: {
        cameraLabel.localize(): () {
          if (assetType == AssetType.image) {
            res = localMedia.image(source: ImageSource.camera);
          } else {
            res = localMedia.video(source: ImageSource.camera);
          }
        },
        libraryLabel.localize(): () {
          if (assetType == AssetType.image) {
            res = localMedia.image(source: ImageSource.gallery);
          } else {
            res = localMedia.video(source: ImageSource.gallery);
          }
        }
      },
      title: title,
      disableBackKey: disableBackKey,
      popOnPress: popOnPress,
      willShowRepetition: willShowRepetition,
    );
    if (res == null) {
      return null;
    }
    return await res;
  }
}

enum UIMediaDialogType { image, video, both }
