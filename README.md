

## import package
```dart
import 'package:quill_custom_image/quill_custom_image.dart
```
# How to Delete an Image

The following code snippet demonstrates how to use the `flutter_quill` package to listen to document changes and perform operations when image is deleted. It also logs information about deleted content, including images.

```dart
void initState() {
  super.initState();

  _controller.document.changes.listen((event) {
    try {
      final baseDoc = _controller.document;
      final dl = baseDoc.toDelta().diff(event.before);

      // Log information about deleted content
      dl.map(
        (p0) {
          // Log if content is deleted or inserted
          // log('isDelete: ${p0.isDelete}');
          // log('isInsert: ${p0.isInsert}');
          // log('---------------');
        },
      ).toList();

      // Extract and log image information if available
      var imgMap = dl.toJson().last;
      if (imgMap != null && imgMap['insert']['image'] != null) {
        log('imgMap : ${imgMap['insert']['image']}');
      }

      // Log the entire Delta as JSON
      log('dl : ${json.encode(dl.toJson())}');
      //TODO: Delete Here
    } catch (e) {
      log('Cannot decode the Delta');
    }
  });
}
```

## Usage

```dart
        Flexible(
                child: QuillEditor(
                  controller: _controller,
                  embedBuilders: FlutterQuillEmbeds.builders(),
                  autoFocus: false,
                  editorKey: editorKey,
                  readOnly: false,
                  expands: false,
                  minHeight: 150,
                  focusNode: FocusNode(),
                  padding: EdgeInsets.zero,
                  scrollController: ScrollController(),
                  scrollable: true,
                ),
              )

```

### You can upload to server in this _onImagePickCallback method

```dart
 Future<String> _onImagePickCallback(File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    final path = copiedFile.path.toString();
    log('Path : $path');

    return path;
  }
```

