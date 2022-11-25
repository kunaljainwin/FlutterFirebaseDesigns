import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/modified_dropdown.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  num rank = -1;
  List<String> placesList =
      List<String>.from(userSnapshot["placeslist"] ?? ["a"]);
  Map<String, String> placesMap = Map<String, String>.from(
      userSnapshot["places"] ??
          {"a": "Oh looks like prisoned , no places visited"});
  String queryPlaceId = "a";

  @override
  void initState() {
    super.initState();
    queryPlaceId = placesList.first;
    getRankAtPlace(queryPlaceId);
  }

  Future<void> getRankAtPlace(String fsq_id) async {
    var mp = await FirebaseFirestore.instance
        .collection("places")
        .doc(fsq_id)
        .get()
        .then((value) {
      return value["visits"];
    });
    List<String> list = mp.keys.toList();
    list..sort((a, b) => mp[b]!.compareTo(mp[a] ?? 0));

    setState(() {
      rank = list.indexOf(queryPlaceId) + 2;
    });
  }

  // String getDayOfMonthSuffix(int dayNum) {
  //   if (!(dayNum >= 1 && dayNum <= 31)) {
  //     throw Exception('Invalid day of month');
  //   }

  //   if (dayNum >= 11 && dayNum <= 13) {
  //     return 'th';
  //   }

  //   switch (dayNum % 10) {
  //     case 1:
  //       return 'st';
  //     case 2:
  //       return 'nd';
  //     case 3:
  //       return 'rd';
  //     default:
  //       return 'th';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Key _key = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        leading: IconButton(
          icon: Icon(CupertinoIcons.multiply),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 100,
        child: ListTile(
          enabled: true,
          title: rank != -1
              ? Text(
                  "Rank" + " | " + NumberFormat.decimalPattern().format(rank)
                  //+ getDayOfMonthSuffix(rank % 31 as int)
                  ,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              : Text("🚫No data to show Rank"),
          leading: CircleAvatar(
            foregroundImage:
                CachedNetworkImageProvider(userSnapshot["imageurl"]),
          ),
          subtitle: Text("Keep contributing to get a better rank"),
          trailing: Text(
            "Visits\n" + userSnapshot[queryPlaceId].toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.orange, Colors.white, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated),
            boxShadow: const [
              BoxShadow(color: Colors.blue, spreadRadius: 2, blurRadius: 20)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Wrap(
            children: [
              ModifiedDropDownMenu(
                  selectedValue: [placesMap[queryPlaceId] ?? ""],
                  onChanged: (v) {
                    setState(() {
                      queryPlaceId = placesMap.keys
                          .firstWhere((element) => placesMap[element] == v);

                      getRankAtPlace(queryPlaceId);
                    });
                  },
                  titleText: placesMap[queryPlaceId] ?? "Select the Place",
                  stringItems: placesMap.values.toList()),
              queryPlaceId.isNotEmpty
                  ? PaginateFirestore(
                      key: _key,
                      shrinkWrap: true,
                      itemsPerPage: 7,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      itemBuilder: (context, snapshot, index) {
                        return Wrap(
                          children: [
                            Text("${index + 1}. "),
                            ListTile(
                              isThreeLine: true,
                              subtitle: Text(userSnapshot["useremail"]),
                              leading: CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                    snapshot[index]["imageurl"]),
                              ),
                              title: Text(snapshot[index]["nickname"]),
                              // subtitle: Text(snapshot[index]["home"].latitude.toString() +
                              //     " , " +
                              //     snapshot[index]["home"].longitude.toString()),
                              trailing: Text(
                                "Visits\n" +
                                    snapshot[index][queryPlaceId].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                      initialLoader: CircularProgressIndicator(),
                      query: FirebaseFirestore.instance
                          .collection("users")
                          .where("placeslist", arrayContains: queryPlaceId),
                      itemBuilderType: PaginateBuilderType.listView)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
