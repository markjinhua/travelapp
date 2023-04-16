import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../theme/theme_services.dart';

class ImageViewScreen extends StatelessWidget {
  String image;

  ImageViewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Stack(


          children: [



        Center(child: CachedNetworkImage(imageUrl: image,placeholder: (context, url) =>
            Center(
                child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(15)),
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.textTheme
                            .headline1!.color))),)),

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded,color: context.textTheme.headline1!.color,size: 18),
                  5.0.addWSpace(),
                  Text('Image Preview',style: TextStyle(color: context.textTheme.headline1!.color,fontSize: 18),)
                ],
              ).marginOnly(top: 50,left: 20),
            ),

            Row(
              children: [

                button(text: "Share",onTap: () async {

                  try {
                    int i = Random().nextInt(30);
                    Directory tempDir = await getTemporaryDirectory();
                    final path = '${tempDir.path}/$i.jpeg';
                    await Dio().download(
                        image, path);
                    Share.shareFiles([path]);
                  } catch (e) {
                    print("Share File ------> $e");
                  }

                }),

                button(
                    text: "Download",
                    onTap: () async {
                      try {
                        var response = await Dio().get(
                            image,
                            options: Options(
                                responseType: ResponseType
                                    .bytes));
                        await ImageGallerySaver.saveImage(
                            Uint8List.fromList(response.data)
                        );
                      } catch (e) {
                    print(
                        '----------> Image  Store Error -> $e');
                  }

                }),

              ],
            ).marginSymmetric(horizontal: 20,vertical: 15)

          ],
        )
      ]),
    );
  }

  Widget button({required String text,required VoidCallback onTap}){
   return  Expanded(
     child: GestureDetector(
       onTap: onTap,
       child: Container(
         height: 50,
        decoration: BoxDecoration(
          color: const Color(0xff56CBFF),
          borderRadius: BorderRadius.circular(15)
        ),
         child: Center(child: Text(text,style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w800),)),
       ).marginAll(3),
     ),
   );
  }

}
