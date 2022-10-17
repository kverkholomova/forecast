import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forecast/api/weather_week_api.dart';

import '../models/weather_week_model.dart';
import '../screens/main_page.dart';


class UploadCacheMemoryData extends StatelessWidget {
  const UploadCacheMemoryData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (_, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Original Url:${fileInfo.originalUrl}"),
            Text("Valid Till:${fileInfo.validTill}"),
            Text("File address:${fileInfo.file}"),
            Text("File source:${fileInfo.source}"),
            Text("Type:${fileInfo.runtimeType}"),
          ],
        )
            : const Center(
          child: Text("Uploading..."),
        );
      },
    );
  }
}
class FetchCacheMemoryData extends StatefulWidget {
  const FetchCacheMemoryData({Key? key}) : super(key: key);

  @override
  State<FetchCacheMemoryData> createState() => _FetchCacheMemoryDataState();
}

var responceCache;
class _FetchCacheMemoryDataState extends State<FetchCacheMemoryData> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        fetchWeatherForWeek();
  }
  Future<FileInfo?> fileInfoFuture = DefaultCacheManager().getFileFromCache(url!);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fileInfoFuture,
      builder: (context, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;

        if(snapshot.hasData) {
          responceCache = DefaultCacheManager().getFileStream(fileInfo.originalUrl, withProgress: true);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Original Url:${fileInfo.originalUrl}"),
              Text("Valid Till:${fileInfo.validTill}"),
              Text("File address:${fileInfo.file}"),
              Text("File source:${fileInfo.source}"),
              Text("Hash code:${fileInfo.runtimeType}"),
            ],
          );
        }
        else{
          return const Center(child: Text("Fetching..."));
        }

      },
    );
  }
}


class HttpProvider {
  Future<Weather5Days> getData(String? url) async {
    var file = await DefaultCacheManager().getSingleFile(url!);
    if (file != null && await file.exists()) {
      file.openRead();
      var res = await file.readAsString();
      // final body = jsonDecode(res);
      return Weather5Days.fromJson(jsonDecode(res));
    }
    throw Exception('Error');
  }
}