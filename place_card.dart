Widget PlaceCard(BuildContext context,
      List<DocumentSnapshot<Object?>> snapshot, int index) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.9,
                        imageUrl: snapshot[index]["thumbnail"],
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.contain,
                      ),
                    ),
                    devMode
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily)),
                                onPressed: () async {
                                  GeoFirePoint gfp;
                                  await locate
                                      .getLocation()
                                      .then((value) async => {
                                            gfp = GeoFirePoint(
                                                value.latitude ?? 0.0,
                                                value.longitude ?? 0.0),
                                            await snapshot[index]
                                                .reference
                                                .update({
                                              "geohash": gfp.hash,
                                              "location": gfp.geoPoint
                                            })
                                          });
                                },
                                child: const Text("Change Location")),
                          )
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily)),
                                onPressed: () {},
                                child: const Text("Check Location")),
                          )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 4.0, left: 20, right: 100),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: snapshot[index]["name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    WidgetSpan(
                        child: Icon(
                      Icons.location_on,
                      size: 16,
                    )),
                    TextSpan(
                      text: snapshot[index]["address"],
                    )
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
