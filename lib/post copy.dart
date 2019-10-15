import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PreferenceHelper.dart';

class Post extends StatelessWidget {
  final num index;
  final List postList;

  Post({
    Key key,
    this.index,
    this.postList,
  }) : super(key: key);

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
    // return await DefaultAssetBundle.of(ctx).loadString('assets/2016_GDP.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(postList[index]['title']),
      ),
      body: postList[index]['type'] == 'article' ? SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: loadAsset('assets/${index}_post.txt'), // a previously-obtained Future<String> or null
          builder: (context, snapshot) {
            final contents = snapshot.data.toString();
            return Text(
              contents,
              style: TextStyle(
                height: 1.4
              )
            );
          }
        )
      ) : Center(
        child: FutureBuilder<String>(
          future: loadAsset('assets/${index}_post.txt'), // a previously-obtained Future<String> or null
          builder: (context, snapshot) {
            final contents = snapshot.data.toString();
            PreferencesHelper.setBool('read$index', true);
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    contents,
                    style: TextStyle(
                      height: 1.8
                    ),
                    textAlign: TextAlign.center
                  )
                )
              ]
            );
          }
        )
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          index == 0 ? new Container() :
          Padding(
            padding: EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: new Theme(
                data: new ThemeData(
                  accentColor: Colors.transparent,
                ),
                child: new FloatingActionButton(
                  heroTag: 'goPreviousButton',
                  foregroundColor: Colors.black.withOpacity(0.4),
                  elevation: 0.0,
                  onPressed: (){
                    Navigator.pushReplacement(
                      context,
                        MaterialPageRoute(
                          builder: (context) => Post(
                            index: index - 1,
                            postList: postList,
                          )
                      )
                    );
                  },
                  child: Icon(Icons.arrow_back_ios)
                )
              )
            )
          ),
          index == postList.length - 1 ? new Container() :
          Align(
            alignment: Alignment.bottomRight,
            child: new Theme(
              data: new ThemeData(
                accentColor: Colors.transparent,
              ),
              child: FloatingActionButton(
                heroTag: 'goNextButton',
                foregroundColor: Colors.black.withOpacity(0.4),
                elevation: 0.0,
                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                      MaterialPageRoute(
                        builder: (context) => Post(
                          index: index + 1,
                          postList: postList,
                        )
                    )
                  );
                },
                child: Icon(Icons.arrow_forward_ios)
              )
            )
          )
        ],
      )
    );
  }

}
