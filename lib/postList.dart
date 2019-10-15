import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'post.dart';
import 'DBHelper.dart';
import 'models/read.dart';

class CustomListItem extends StatelessWidget {
  final num index;
  final List postList;

  CustomListItem({Key key, this.index, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double titleFontSize = postList[index]["type"] == "article" ? 14.0 : 16.0;

    return
        //  Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 4.0),
        //   child:
        FutureBuilder<dynamic>(
            future: DBHelper().getRead(index), //
            builder: (context, snapshot) {
              dynamic read = snapshot.data;
              print(read);

              Color readIconColor =
                  read == Null ? Colors.grey[300] : Colors.yellow[800];

              return Container(
                  height: 48,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: new BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 0.5, color: Colors.blueGrey)),
                      color: postList[index]["type"] == "section"
                          ? Colors.blueGrey
                          : Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.check_circle,
                                size: 16, color: readIconColor),
                            Container(
                              width: 8.0,
                            ),
                            Text(
                              postList[index]["title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: postList[index]["type"] == "section"
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ]),
                      Text(
                        postList[index]["author"] == null
                            ? ''
                            : postList[index]["author"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                  // ),
                  );
            });
  }
}

class _PostListState extends State<PostList> {
  List postList = [];
  TextEditingController controller = new TextEditingController();
  String filter;

  Future<String> loadIndex() async {
    String indexJsonStr = await rootBundle.loadString('assets/index.json');
    this.setState(() {
      postList = jsonDecode(indexJsonStr);
    });

    return "success";
    // return await DefaultAssetBundle.of(ctx).loadString('assets/2016_GDP.txt');
  }

  @override
  void initState() {
    super.initState();
    this.loadIndex();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Widget _buildPostList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: postList == null ? 0 : postList.length,
        itemBuilder: (context, index) {
          return filter == null || filter == ""
              ? GestureDetector(
                  child: CustomListItem(
                    index: index,
                    postList: postList,
                  ),
                  onTap: () {
                    Read read = Read(
                      bookId: index,
                      complete: true,
                    );
                    DBHelper().createData(read);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Post(
                                  index: index,
                                  postList: postList,
                                )));
                  })
              : postList[index]['title'].contains(filter)
                  ? GestureDetector(
                      child: CustomListItem(
                        index: index,
                        postList: postList,
                      ),
                      onTap: () {
                        Read read = Read(
                          bookId: index,
                          complete: true,
                        );
                        DBHelper().createData(read);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Post(
                                      index: index,
                                      postList: postList,
                                    )));
                      })
                  : new Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blue Christmas'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  DBHelper().deleteAllReads();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PostList()));
                })
          ],
        ),
        body: Material(
            child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.5, color: Colors.blueGrey))),
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                              decoration: new InputDecoration.collapsed(
                                hintText: "Search something",
                              ),
                              controller: controller)),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.search)),
                    ],
                  ))),
          Expanded(
            child: _buildPostList(),
          )
        ])));
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => new _PostListState();
}
