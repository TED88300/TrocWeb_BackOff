import 'dart:html' as htmlfile;
import 'platform_file_picker.dart';

PlatformFilePicker createPickerObject() => WebFilePicker();

class WebFilePicker implements PlatformFilePicker{
  @override
  String getFileName(file) {
      return file.file.name;
    }

    @override
    void startWebFilePicker(pickerCallBack) {
    htmlfile.FileUploadInputElement uploadInput = htmlfile.FileUploadInputElement();

    uploadInput.multiple = true;
    uploadInput.accept = 'image/*';

    uploadInput.click();

    //allowMultiple: true
    uploadInput.onChange.listen((e){
      final files = uploadInput.files;

      print("files!.length ${files!.length}");

      if(files.length == 1){
        final htmlfile.File file = files[0];
        final reader = htmlfile.FileReader();
        reader.onLoadEnd.listen((event) {
          String wTmp = reader.result.toString();
          print("wTmp1");
          wTmp = wTmp.replaceAll("[", "");
          wTmp = wTmp.replaceAll("]", "");
          print("wTmp2");
          List<String> wTmpSplitf = wTmp.split(",");
          print("wTmpSplitf");
          List<int> wTmpSplitINT = wTmpSplitf.map((data) => int.parse(data)).toList();
          pickerCallBack([FlutterWebFile(file, wTmpSplitINT)]);
        });
        reader.readAsArrayBuffer(file);
      }
      else
      {

      }


    });
  }

}

class FlutterWebFile{
  htmlfile.File file;
  List<int> fileBytes;
  FlutterWebFile(this.file, this.fileBytes);
}