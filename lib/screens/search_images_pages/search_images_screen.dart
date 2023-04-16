import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:chat_gpt/theme/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/screens/search_images_pages/search_screen_controller.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import '../../constant/app_icon.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../widgets/app_dropdown.dart';
import '../../widgets/app_textfield.dart';
import 'image_view_screen.dart';


class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {

  final searchScreenController = Get.put(SearchImageScreenController());

  String value = "ABC";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: Scaffold(
          backgroundColor: context.theme.backgroundColor,
          appBar: AppBar(
              leading: IconButton(onPressed: () {
                Get.back();
              },
                  icon: Icon(Icons.arrow_back,
                    color: context.textTheme.headline1!.color,)),
              backgroundColor: context.theme.backgroundColor,
              elevation: 0,
              foregroundColor: Colors.white,
              title: Text("imageGeneration".tr,
                style: TextStyle(color: context.textTheme.headline1!.color),)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                10.0.addHSpace(),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: context.isDarkMode == false
                          ?
                      const Color(0xffEDEDED)
                          :
                      Colors.white,),
                    child: Row(
                      children: [

                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              AppTextField(
                                controller: searchScreenController.imageSearch,
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                            onPressed: () {
                              hideKeyboard(context);
                              searchScreenController.generateImage();
                            }, icon: Icon(Icons.search, color: Colors.black)),
                      ],
                    )
                ).marginSymmetric(horizontal: 5, vertical: 10),

                // 8.0.addHSpace(),


                Obx(() {
                  return Container(
                    height: 65,

                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xffF8F9FD),
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Expanded(
                          flex: 1,
                          child: const Text('Image size', style: TextStyle(color: Colors.black,fontSize: 15),).marginOnly(top: 0, left: 20),
                        ),

                        Expanded(
                          flex: 2,
                          child: Container(
                              decoration: BoxDecoration(
                                  // color: const Color(0xffF8F9FD),
                                  color: Colors.blueGrey.shade50,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            child: AppDropdown(
                              value: searchScreenController.size.value,
                              items: searchScreenController.imageSizeList.value.map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                                value: value,

                                child: Text(value,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400)).marginOnly(left: 10),)).toList(),
                              onChanged: searchScreenController.onImageSizeChange,
                            )
                          ).marginOnly(left: 50,right: 10),
                        )
                      ],
                    ),
                  );
                }).marginSymmetric(horizontal: 5, vertical: 10),

                20.0.addHSpace(),


                Obx(() {
                  return searchScreenController.isLoading.value == true
                      ?
                  SizedBox(height: 200,
                      child: Center(
                          child: CircularProgressIndicator(color: context
                              .textTheme.headline1!.color)))
                      :
                  Container();
                }),

                Obx(() =>
                searchScreenController.isLoading.value == false &&
                    searchScreenController.imageList.isNotEmpty
                    ?
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // childAspectRatio: (0.45 / 0.5),
                        // crossAxisSpacing: 10,
                        // mainAxisSpacing: 10
                    ),
                    itemCount: searchScreenController.imageList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Get.to(ImageViewScreen(image: searchScreenController.imageList[index]),transition: Transition.rightToLeft);
                        },
                        child: ClipRRect(
                          borderRadius:  BorderRadius.circular(15),
                          child: Stack(
                            // alignment: Alignment.bottomRight,
                            children: [




                              CachedNetworkImage(
                                imageUrl: searchScreenController.imageList[index],

                                // fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator(strokeWidth: 2, color: context.textTheme.headline1!.color)),
                                errorWidget: (context, error, u) =>
                                    Center(child: CircularProgressIndicator(strokeWidth: 2, color: context.textTheme.headline1!.color)),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        var response = await Dio().get(
                                            searchScreenController.imageList[index],
                                            options: Options(responseType: ResponseType.bytes));
                                        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data)
                                        );
                                      } catch (e) {
                                        print(
                                            '----------> Image  Store Error -> $e');
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(color: Color(0xff7C9AAC)),
                                      child: AppIcon.downloadIcon(),
                                    ),
                                  ),
                                ],
                              ),


                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //
                              //     IconButton(
                              //         onPressed: () async {
                              //       try {
                              //         int i = Random().nextInt(30);
                              //         Directory tempDir = await getTemporaryDirectory();
                              //         final path = '${tempDir.path}/$i.jpeg';
                              //         await Dio().download(
                              //             searchScreenController
                              //                 .imageList[index], path);
                              //         Share.shareFiles([path]);
                              //       } catch (e) {
                              //         print("Share File ------> $e");
                              //       }
                              //     },
                              //         icon: const Icon(Icons.share,
                              //           color: Color(0xff7E30A1),)),
                              //
                              //
                              //     IconButton(onPressed: () async {
                              //       try {
                              //         var response = await Dio().get(
                              //             searchScreenController
                              //                 .imageList[index],
                              //             options: Options(
                              //                 responseType: ResponseType
                              //                     .bytes));
                              //         await ImageGallerySaver.saveImage(
                              //             Uint8List.fromList(response.data)
                              //         );
                              //       } catch (e) {
                              //         print(
                              //             '----------> Image  Store Error -> $e');
                              //       }
                              //     },
                              //         icon: const Icon(Icons.save,
                              //           color: Color(0xff7E30A1),)),
                              //   ],
                              // )

                            ],
                          ),
                        ),
                      ).marginAll(3);
                    }
                )
                    :
                Container())

              ],
            ).paddingSymmetric(horizontal: 20),
          )
      ),
    );
  }
}