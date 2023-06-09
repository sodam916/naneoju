import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SearchProvider extends GetConnect {
  final logger = Logger();
  final storage = const FlutterSecureStorage();
  @override
  void onInit() async {
    await dotenv.load();
    httpClient.baseUrl = dotenv.env['BASE_URL'];
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(milliseconds: 5000);
    super.onInit();
  }

  //인기 해시 태그 조회
  Future<Response> getPopularTag() async {
    final response =
        await get("https://k8b207.p.ssafy.io/api//tag-service/tags");
    return response;
  }

  //검색 페이지  => 나눔 및  공연 타입으로  목록 조회
  Future<Response> getSearch({
    required String type,
    required String q,
  }) async {
    final response = await get("search?=$type?=$q");
    return response;
  }

  //나눔 공연 조회
  Future<Response> getSharingShow({
    required String category,
    required String title,
  }) async {
    final response = await get("/shows/search?category=$category&title=$title");
    return response;
  }

  //큰 카테고리 조회
  Future<Response> getParentCategory() async {
    final response = await get(
        "https://k8b207.p.ssafy.io/api/show-service/shows/categories");
    return response;
  }

  //작은 카테고리 조회
  Future<Response> getChildCategory({String? parent}) async {
    final response = await get(
        "https://k8b207.p.ssafy.io/api/show-service/shows/categories?parent=$parent");
    return response;
  }

  //공연 목록 검색
  Future<Response> getShowList(
      {required String category, String? title}) async {
    logger.i("들와라 제발 $category $title");
    final response = await get(
        'https://k8b207.p.ssafy.io/api/show-service/shows/search?category=$category&title=$title');
    return response;
  }

  //공연 등록 요청
  Future<Response> postReqShow({
    required String title,
    required String path,
  }) async {
    logger.i("공연 등록 요청 $title, $path");
    final token = await storage.read(key: 'accessToken');
    final response = await post(
        'https://k8b207.p.ssafy.io/api/user-service/users/ask/show',
        jsonEncode({
          'title': title,
          'path': path,
        }),
        headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  //나눔 관련 검색 api
  Future<Response> getRelatedSearch({required String text}) async {
    final headers = {'Content-Type': 'application/json'};
    final response = await get(
        'https://k8b207.p.ssafy.io/api/tag-service/tags/search?search=$text',
        headers: headers);
    return response;
  }

  //나눔 검색 api
  Future<Response> getNanumsSearch({required String q}) async {
    final headers = {'Content-Type': 'application/json'};
    final response = await get(
        "https://k8b207.p.ssafy.io/api/nanum-service/nanums/search?q=$q");
    return response;
  }

  //공연 검색 api
  Future<Response> getShowsSearch({required String q}) async {
    final headers = {'Content-Type': 'application/json'};
    final response = await get(
        "https://k8b207.p.ssafy.io/api/show-service/shows/search/query?q=$q");
    return response;
  }
}
