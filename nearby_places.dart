 FutureBuilder<LocationData> bodyMain() {
    return FutureBuilder<LocationData>(
      future: locate.getLocation(),
      builder: (context, currentLocation) {
        return currentLocation.hasData
            ? FutureBuilder<List>(
                future: MapServices().getNearbyPlaces(currentLocation.data ??
                    LocationData.fromMap({"lat": 4, "lang": 4})),
                builder: (context, place) {
                  if (place.hasData) {
                    var places = place.data;
                    return ListView.builder(
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: true,
                      padding: EdgeInsets.only(top: 30),
                      itemBuilder: (context, index) {
                        var isVisited = true;
                        placesss.contains(places![index]["fsq_id"])
                            ? isVisited = true
                            : isVisited = false;

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                              onTap: () => {},
                              minVerticalPadding: 10,
                              tileColor: isVisited
                                  ? Colors.teal.shade200
                                  : places[index]["distance"] < 10
                                      ? Color.fromARGB(255, 114, 252, 121)
                                      : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              leading: places[index]["categories"][0]["icon"]
                                          ["prefix"] !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              places[index]["categories"][0]
                                                      ["icon"]["prefix"] +
                                                  "32" +
                                                  places[index]["categories"][0]
                                                      ["icon"]["suffix"]),
                                    )
                                  : null,
                              title: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: places[index]["name"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  isVisited
                                      ? TextSpan()
                                      : WidgetSpan(
                                          child: Icon(
                                          Icons.location_on,
                                          size: 16,
                                        )),
                                  isVisited
                                      ? TextSpan()
                                      : TextSpan(
                                          text: "(" +
                                              places[index]["distance"]
                                                  .toString() +
                                              "m)"),
                                ]),
                              ),
                              subtitle: isVisited
                                  ? null
                                  : Text(places[index]["location"]["address"]),
                              trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.roboto().fontFamily)),
                                  onPressed: () async => onCheckLocationPressed(
                                      places[index]["fsq_id"],
                                      places[index]["name"],
                                      places[index]["distance"]),
                                  child: const Text("I'm Here"))),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }
