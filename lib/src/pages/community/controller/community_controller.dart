import 'package:get/get.dart';

enum CATEGORY_LIST { FREE_BOARD, MY_LIFE}

extension CategoryExtension on CATEGORY_LIST{
  String get title {
    switch (this){
      case CATEGORY_LIST.FREE_BOARD:
        return '자유게시판';
      case CATEGORY_LIST.MY_LIFE:
        return '나의 일상';
      default:
        return '';
    }
  }
}

class CommunityController extends GetxController{
  RxInt currentCategoryIndex = 0.obs;
}