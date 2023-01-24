// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageSourceButton extends StatelessWidget {
  bool previewImage = false;
  Color _conversationEntryIconColor = Color.fromARGB(255, 214, 103, 12);
  Color _conversationEntryFbBgColor = Color.fromARGB(57, 255, 128, 0);
  var _selectImage;

  SelectImageSourceButton(this.previewImage, this._selectImage);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        print("Camera button clicked !");
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    bottom: 20,
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    if (previewImage) Text("Previewing"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Text("Select Image Source",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        FloatingActionButton(
                          child: Icon(Icons.camera_alt,
                              color: _conversationEntryIconColor),
                          elevation: 0,
                          backgroundColor: _conversationEntryFbBgColor,
                          onPressed: () async {
                            _selectImage(context, ImageSource.camera);
                          },
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.image_rounded,
                              color: _conversationEntryIconColor),
                          elevation: 0,
                          backgroundColor: _conversationEntryFbBgColor,
                          onPressed: () async {
                            _selectImage(context, ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            });
      },
      child: Icon(
        Icons.camera_alt_outlined,
        color: _conversationEntryIconColor,
        size: 18,
      ),
      elevation: 0,
      backgroundColor: _conversationEntryFbBgColor,
    );
  }
}
