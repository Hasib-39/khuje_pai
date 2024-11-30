
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final int likeCnt;
  final int commentCnt;
  final int shareCnt;
  final String caption;
  final String location;
  final String imgUrl;
  final Timestamp createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.likeCnt,
    required this.commentCnt,
    required this.shareCnt,
    required this.caption,
    required this.location,
    required this.imgUrl,
    required this.createdAt,
  });

  // Factory constructor to create a Post object from Firestore document
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      likeCnt: json['like_cnt'] as int,
      commentCnt: json['comment_cnt'] as int,
      shareCnt: json['share_cnt'] as int,
      caption: json['caption'] as String,
      location: json['location'] as String,
      imgUrl: json['imgUrl'] as String,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  // Convert a Post object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'like_cnt': likeCnt,
      'comment_cnt': commentCnt,
      'share_cnt': shareCnt,
      'caption': caption,
      'location': location,
      'imgUrl': imgUrl,
      'createdAt': createdAt,
    };
  }
}
