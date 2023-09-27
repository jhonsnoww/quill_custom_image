## add Git repo to your .yaml file like this

```dart
 quill_custom_image:
    git:
      url: https://github.com/jhonsnoww/quill_custom_image.git
```

## import package
```dart
import 'package:quill_custom_image/quill_custom_image.dart
```
# How to Delete an Image
```dart
 final QuillController _controller = QuillController.basic();
  GlobalKey<EditorState>? editorKey = GlobalKey<EditorState>();

```


```dart
void initState() {
  super.initState();

  _controller.document.changes.listen((event) {
    try {
      final baseDoc = _controller.document;
      final dl = baseDoc.toDelta().diff(event.before);

      dl.map(
        (p0) {
          // Log if content is deleted or inserted
          // log('isDelete: ${p0.isDelete}');
          // log('isInsert: ${p0.isInsert}');
          // log('---------------');
        },
      ).toList();

      var imgMap = dl.toJson().last;
      if (imgMap != null && imgMap['insert']['image'] != null) {
        log('imgMap : ${imgMap['insert']['image']}');
      }

      log('dl : ${json.encode(dl.toJson())}');
      //TODO: Delete Here
    } catch (e) {
      log('Cannot decode the Delta');
    }
  });
}
```

## Usage

## Controllers

```dart
  QuillToolbar.basic(
                  controller: _controller,
                  embedButtons: FlutterQuillEmbeds.buttons(
                    showCameraButton: false,
                    showVideoButton: false,
                    showFormulaButton: false,
                    onImagePickCallback: _onImagePickCallback,
                  )),
```

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

