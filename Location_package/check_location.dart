Future onCheckLocationPressed(
      String fsq_id, String name, int distance) async {
    var ff = FirebaseFirestore.instance;
    // var x = await getPermission();

    // var location_data = await locate.getLocation();
    late var snack;

    if (List.castFrom(userSnapshot["placeslist"]).contains(fsq_id)) {
      if (!isToday(userSnapshot["lastVisit"][fsq_id].toDate())) {
        if (distance < error_distance) {
          snack = SnackBar(
              backgroundColor: Colors.greenAccent,
              content: Text(
                "Success     " + distance.toString() + "m",
                textAlign: TextAlign.center,
              ));
//need to add restriction for a day only

//updating place doc
          ff.collection("places").doc(fsq_id).set({
            "visitors": FieldValue.increment(1),
            "visits": {userSnapshot.id: FieldValue.increment(1)}
          }, SetOptions(merge: true));

// updating user doc
          userSnapshot.reference.set({
            fsq_id: FieldValue.increment(1),
            "placeslist": FieldValue.arrayUnion([fsq_id]),
            "places": {fsq_id: name},
            "lastVisit": {fsq_id: DateTime.now()},
          }, SetOptions(merge: true));
        } else {
          //here

          snack = SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Failure     " + distance.toString() + "m",
                textAlign: TextAlign.center,
              ));
        }
      } else {
        snack = const SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text(
              "See you tommorow",
              textAlign: TextAlign.center,
            ));
      }
    } else {
      if (distance < error_distance) {
        //here

        snack = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(
              "Success     " + distance.toString() + "m",
              textAlign: TextAlign.center,
            ));
//updating place doc
        ff.collection("places").doc(fsq_id).set({
          "visitors": FieldValue.increment(1),
          "visits": {userSnapshot.id: FieldValue.increment(1)}
        }, SetOptions(merge: true));

// updating user doc
        userSnapshot.reference.set({
          fsq_id: FieldValue.increment(1),
          "placeslist": FieldValue.arrayUnion([fsq_id]),
          "places": {fsq_id: name},
          "lastVisit": {fsq_id: DateTime.now()},
        }, SetOptions(merge: true));
      } else {
        //here

        snack = SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Failure     " + distance.toString() + "m",
              textAlign: TextAlign.center,
            ));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
