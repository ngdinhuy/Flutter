class Message {
  int? id;
  String time;
  String content;

  // Message({this.id, required this.time, required this.content});
  // Message({required this.time, required this.content});


  Message({this.id, required this.time, required this.content});

  Map<String, dynamic> toMap()=> {'time': time, 'content': content};

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(id: map['id'] ,time: map['time'], content: map['content']);
  }

}