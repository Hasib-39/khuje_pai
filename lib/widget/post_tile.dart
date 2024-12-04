import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/post.dart';
import '../user_model.dart';
import '../views/profile.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post, this.delete_option = false});
  final Post post;
  final bool delete_option;

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
    fetchUserData();
    likeCount = widget.post.likeCnt;
  }

  Future<UserModel?> fetchUserData() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: widget.post.userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first.data() as Map<String, dynamic>;
        return UserModel.fromJson(userDoc);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });

    try {
      await FirebaseFirestore.instance
          .collection("Post")
          .doc(widget.post.id)
          .update({
        "like_cnt": likeCount,
      });
    } catch (e) {
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
      });
    }
  }

  Future<void> deletePost() async {
    try {
      await FirebaseFirestore.instance
          .collection("Post")
          .doc(widget.post.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete the post!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(""));
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading user data"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("User data not found"));
        }

        UserModel user = snapshot.data!;

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(profileUser: user),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: user.imgUrl != null
                                ? NetworkImage(user.imgUrl!)
                                : const AssetImage("images/default_profile.png")
                            as ImageProvider,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(profileUser: user),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? "Loading...",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${widget.post.location} . ${timeago.format(widget.post.createdAt.toDate().toLocal())}",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.delete_option)
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Post"),
                              content: const Text(
                                  "Are you sure you want to delete this post?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await deletePost();
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.post.caption,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                widget.post.imgUrl.isNotEmpty
                    ? Image.network(
                  widget.post.imgUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 10),
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
                        const Icon(FontAwesomeIcons.solidComment,
                            color: Colors.black, size: 20),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
