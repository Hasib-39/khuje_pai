import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khuje_pai/components/post.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post});
  final Post post;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  String? userName;
  String? userImgUrl;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget is initialized
    likeCount = widget.post.likeCnt;
  }

  Future<void> fetchUserData() async {
    try {
      // Query User collection where userId matches
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: widget.post.userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          userName = userDoc["name"];
          userImgUrl = userDoc["imgUrl"];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });

    try {
      // Update like count in Firebase
      await FirebaseFirestore.instance
          .collection("Post")
          .doc(widget.post.id) // Ensure this is the correct post document ID
          .update({
        "like_cnt": likeCount,
      });
    } catch (e) {
      print("Error updating like count: $e");
      // Revert state on failure
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user info (image and name)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: userImgUrl != null
                      ? NetworkImage(userImgUrl!)
                      : const AssetImage("images/default_profile.png") as ImageProvider,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 10),
                Text(
                  userName ?? "Loading...",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Display post caption
            Text(
              widget.post.caption,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            // Display post image
            widget.post.imgUrl.isNotEmpty
                ? Image.network(
              widget.post.imgUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            // Display post stats with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "$likeCount",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.green, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.post.commentCnt}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.share, color: Colors.orange, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.post.shareCnt}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Display post location and timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.post.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  widget.post.createdAt.toDate().toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
