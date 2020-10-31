// To parse this JSON data, do
//
//     final responseApi = responseApiFromJson(jsonString);

import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  ResponseApi({
    this.id,
    this.names,
    this.lastNames,
    this.allViewedVideos,
    this.allVisitedModules,
  });

  int id;
  String names;
  String lastNames;
  List<AllViewedVideo> allViewedVideos;
  List<AllVisitedModule> allVisitedModules;

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
        id: json["id"],
        names: json["names"],
        lastNames: json["last_names"],
        allViewedVideos: List<AllViewedVideo>.from(
            json["all_viewed_videos"].map((x) => AllViewedVideo.fromJson(x))),
        allVisitedModules: List<AllVisitedModule>.from(
            json["all_visited_modules"]
                .map((x) => AllVisitedModule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "names": names,
        "last_names": lastNames,
        "all_viewed_videos":
            List<dynamic>.from(allViewedVideos.map((x) => x.toJson())),
        "all_visited_modules":
            List<dynamic>.from(allVisitedModules.map((x) => x.toJson())),
      };
}

class AllViewedVideo {
  AllViewedVideo({
    this.id,
    this.name,
    this.moduleId,
    this.fileName,
    this.showed,
  });

  int id;
  String name;
  int moduleId;
  String fileName;
  bool showed;

  factory AllViewedVideo.fromJson(Map<String, dynamic> json) => AllViewedVideo(
        id: json["id"],
        name: json["name"],
        moduleId: json["module_id"] == null ? null : json["module_id"],
        fileName: json["file_name"],
        showed: json["showed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "module_id": moduleId == null ? null : moduleId,
        "file_name": fileName,
        "showed": showed,
      };
}

class AllVisitedModule {
  AllVisitedModule({
    this.id,
    this.index,
    this.title,
    this.visited,
  });

  int id;
  int index;
  String title;
  bool visited;

  factory AllVisitedModule.fromJson(Map<String, dynamic> json) =>
      AllVisitedModule(
        id: json["id"],
        index: json["index"],
        title: json["title"],
        visited: json["visited"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "index": index,
        "title": title,
        "visited": visited,
      };
}
