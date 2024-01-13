import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageImageBubble extends StatefulWidget {
  MessageImageBubble({
    @required this.picture,
    @required this.username,
    @required this.profilePicture,
    @required this.id,
    @required this.isMe,
    @required this.collection,
    @required this.key,
  });

  final String picture;
  final String username;
  final String profilePicture;
  final String id;
  final bool isMe;
  final CollectionReference collection;
  final Key key;

  @override
  _MessageImageBubbleState createState() => _MessageImageBubbleState();
}

class _MessageImageBubbleState extends State<MessageImageBubble> {
  String latestUsername;

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!widget.isMe)
          Container(
            margin: EdgeInsets.only(left: 5),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.profilePicture),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft:
                    widget.isMe ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    widget.isMe ? Radius.circular(0) : Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  latestUsername ?? widget.username,
                  textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  constraints: BoxConstraints(
                    minWidth: 100,
                    minHeight: 100,
                    maxHeight: 400,
                    maxWidth: 400,
                  ),
                  child: Image.network(widget.picture),
                ),
              ],
            ),
          ),
        ),
        if (widget.isMe)
          Container(
            margin: EdgeInsets.only(right: 5),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.profilePicture),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
  }

  void getUsername() async {
    final doc = await widget.collection
        .doc(widget.id)
        .get(GetOptions(source: Source.cache));
    final username = doc['username'];
    setState(() => latestUsername = username);
  }
}
