import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forecast/api/weather_week_api.dart';

import '../screens/main_page.dart';

class UploadCacheMemoryData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("UploadCacheMemoryData");
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
            Text("Hash code:${fileInfo.hashCode}"),
            Text("Type:${fileInfo.runtimeType}"),
          ],
        )
            : Center(
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

class _FetchCacheMemoryDataState extends State<FetchCacheMemoryData> {
// class FetchCacheMemoryData extends StatelessWidget {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
        fetchWeatherForWeek();
  }
  Future<FileInfo?> fileInfoFuture = DefaultCacheManager().getFileFromCache(url!);

  @override
  Widget build(BuildContext context) {
    print("FetchCacheMemoryData");
    return FutureBuilder(
      future: fileInfoFuture,
      builder: (context, snapshot) {
        FileInfo fileInfo = snapshot.data as FileInfo;
        return snapshot.hasData
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Original Url:${fileInfo.originalUrl}"),
            Text("Valid Till:${fileInfo.validTill}"),
            Text("File address:${fileInfo.file}"),
            Text("File source:${fileInfo.source}"),
            Text("Hash code:${fileInfo.hashCode}"),
            Text("Hash code:${fileInfo.runtimeType}"),
          ],
        )
            : Center(child: Text("Fetching..."));
      },
    );
  }
}