import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/post.dart';
import '../user_model.dart';
import '../views/profile.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
                            size: 22, // Slightly larger for better visual impact
                          ),
                          const SizedBox(width: 8), // Consistent spacing
                          Text(
                            "$likeCount",
                            style: const TextStyle(
                              fontSize: 16, // Slightly larger text for clarity
                              fontWeight: FontWeight.w500, // Slightly bold for emphasis
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.comment,
                          color: Color(0xFF2196F3),
                          size: 22, // Slightly larger for consistency
                        ),
                        const SizedBox(width: 8), // Consistent spacing
                        Text(
                          "${widget.post.commentCnt}",
                          style: const TextStyle(
                            fontSize: 16, // Slightly larger text for clarity
                            fontWeight: FontWeight.w500, // Slightly bold for emphasis
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final imgUrl = widget.post.imgUrl;
                          final url = Uri.parse(imgUrl);

                          // Get the image as bytes
                          final response = await http.get(url);
                          if (response.statusCode == 200) {
                            final bytes = response.bodyBytes;

                            // Get the temporary directory
                            final temp = await getTemporaryDirectory();
                            final path = '${temp.path}/image.jpg';

                            // Save the image file
                            final file = File(path);
                            await file.writeAsBytes(bytes);

                            // Share the image file with caption
                            await Share.shareXFiles([XFile(path)], text: widget.post.caption);
                          } else {
                            // Handle error if image is not found or failed to load
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to download the image")),
                            );
                          }
                        } catch (e) {
                          // Handle any other errors
                          print('$e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error occurred: $e")),
                          );
                        }

                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.ios_share,
                            color: Colors.blueAccent,
                            size: 22, // Slightly larger for consistency
                          ),
                          const SizedBox(width: 8), // Consistent spacing
                          Text(
                            "${widget.post.shareCnt}",
                            style: const TextStyle(
                              fontSize: 16, // Slightly larger text for clarity
                              fontWeight: FontWeight.w500, // Slightly bold for emphasis
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
