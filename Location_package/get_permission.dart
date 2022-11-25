  Future<bool> getPermission() async {
    var x = await locate.hasPermission();
    if (x == PermissionStatus.granted || x == PermissionStatus.grantedLimited) {
    } else {
      locate.requestService();
      return true;
    }
    return false;
  }
