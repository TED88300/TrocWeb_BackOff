import 'platform_file_picker_stub.dart'
if(dart.library.io) 'mobile_file_picker.dart'
if(dart.library.html) 'web_file_picker.dart';

typedef CallBackForFilePicker = Function(List<dynamic> files);

abstract class PlatformFilePicker{

  factory PlatformFilePicker() => createPickerObject();

  void startWebFilePicker(CallBackForFilePicker pickerCallBack);

  String getFileName(dynamic file);

}
