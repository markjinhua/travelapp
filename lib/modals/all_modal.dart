class AstrologyModal{
  String? title;
  String? description;
  AstrologyModal({this.title,this.description});
}
List<AstrologyModal> astrologyList = [];


class SocialMediaModal{
  String? title;
  String? description;
  SocialMediaModal({this.title,this.description});
}
List<SocialMediaModal> socialMedialList = [];


class ChatGPTModal{
  String name;
  List<CategoriesData> categoriesData = [];

  ChatGPTModal({required this.name,required this.categoriesData});

}

class CategoriesData {
  String title;
  String description;
  String question;
  CategoriesData({required this.title,required this.description,required this.question});
}

List<ChatGPTModal>chatGPTList = [];

