
enum RequestType { GET, PUT, POST, DELETE }

enum ExceptionType {UNAUTHORIZED, BADREQUEST, INVALIDINPUT, FETCHDATA}

class KeyValue {
  String label;
  String key;
  KeyValue(this.label, this.key);
}
