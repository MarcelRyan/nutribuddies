// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nutribuddies/constant/colors.dart';
import 'package:nutribuddies/models/forum.dart';
import 'package:nutribuddies/models/user.dart';
import 'package:nutribuddies/services/database.dart';
import 'package:nutribuddies/services/forum.dart';
import 'package:nutribuddies/widgets/loading.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Forum>?> getForum(BuildContext context) async {
    try {
      // Initialize forum service
      final ForumService forumService = ForumService();

      final forums = await forumService.getForum();

      return forums;
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text(
            "Forum Discussion",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      surfaceTintColor: primary,
                      foregroundColor: onPrimary,
                      backgroundColor: primary),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewDiscussionPage(),
                      ),
                    );

                    setState(() {});
                  },
                  child: const Text(
                    'Start A Discussion!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Forum>?>(
                  future: getForum(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                          ));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No discussion available',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ));
                    } else {
                      List<Forum> forums = snapshot.data!;

                      return ListView.builder(
                        itemCount: forums.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          Forum forum = forums[index];
                          return DiscussionCard(
                            forum: forum,
                            userProfile: forum.profilePicture,
                            userName: forum.name,
                            createdAt: forum.createdAt.toString(),
                            question: forum.question,
                            answers: forum.answers.length,
                            isTopic: true,
                            refresh: () => {setState(() {})},
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class DiscussionCard extends StatelessWidget {
  final Forum forum;
  final String userProfile;
  final String userName;
  final String createdAt;
  final String question;
  final int answers;
  final bool isTopic;
  final Function? refresh;

  const DiscussionCard({
    Key? key,
    required this.userProfile,
    required this.userName,
    required this.createdAt,
    required this.question,
    required this.isTopic,
    this.answers = 0,
    required this.forum,
    this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isTopic) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiscussionPage(forumId: forum.forumId),
            ),
          ).then((value) => refresh!());
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        surfaceTintColor: surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userProfile),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(DateFormat('dd-MM-yyyy HH:mm')
                          .format(forum.createdAt)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              isTopic
                  ? Text(
                      '$answers answer(s)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscussionPage extends StatefulWidget {
  final String forumId;
  const DiscussionPage({Key? key, required this.forumId}) : super(key: key);

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late Future<Forum?> forumFuture;

  @override
  void initState() {
    super.initState();
    forumFuture = getForumById();
  }

  Future<Forum?> getForumById() async {
    try {
      final ForumService forumService = ForumService();
      final forum = await forumService.getForumById(widget.forumId);
      return forum;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discussion Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<Forum?>(
            future: forumFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error fetching forum details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ));
              } else {
                Forum forum = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question
                    DiscussionCard(
                      forum: forum,
                      userProfile: forum.profilePicture,
                      userName: forum.name,
                      createdAt: forum.createdAt.toString(),
                      question: forum.question,
                      answers: forum.answers.length,
                      isTopic: false,
                    ),
                    const SizedBox(height: 8),
                    // Button to add a new answer
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          surfaceTintColor: primary,
                          foregroundColor: onPrimary,
                          backgroundColor: primary),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAnswerPage(forum: forum),
                          ),
                        );

                        setState(() {
                          forumFuture = getForumById();
                        });
                      },
                      child: const Text('Add New Answer'),
                    ),
                    const SizedBox(height: 16),
                    // Answers
                    Text(
                      "Answers (${forum.answers.length})",
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: forum.answers.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        ForumAnswers answer = forum.answers[index];
                        return DiscussionCard(
                          forum: forum,
                          userProfile: answer.profilePicture,
                          userName: answer.name,
                          createdAt: answer.createdAt.toString(),
                          question: answer.answer,
                          answers: 0,
                          isTopic: false,
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class NewDiscussionPage extends StatefulWidget {
  const NewDiscussionPage({Key? key}) : super(key: key);

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  final TextEditingController _titleController = TextEditingController();

  Future<void> createForum(String title) async {
    // Get user
    final Users? users = Provider.of<Users?>(context, listen: false);
    final Users user = await DatabaseService(uid: users!.uid).getUserData();
    String defaultPhotoPath = 'default_profile.png';
    String defaultPhotoUrl =
        await DatabaseService(uid: user.uid).getPhotoUrl(defaultPhotoPath);
    print(defaultPhotoUrl);

    // Create Forum
    final ForumService forumService = ForumService();

    await forumService.createForum(
        user.uid,
        title,
        user.profilePictureUrl ?? defaultPhotoUrl,
        user.displayName ?? "Anonymous");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start A Discussion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Title:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter discussion title...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                surfaceTintColor: primary,
                foregroundColor: onPrimary,
                backgroundColor: primary,
              ),
              onPressed: () async {
                String title = _titleController.text;
                try {
                  await createForum(title);
                  Navigator.pop(context, true);
                  Fluttertoast.showToast(
                      msg: "Discussion created successfully.");
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error creating new discussion.");
                }
              },
              child: const Text('Start Discussion!'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewAnswerPage extends StatefulWidget {
  const NewAnswerPage({Key? key, required this.forum}) : super(key: key);

  final Forum forum;

  @override
  State<NewAnswerPage> createState() => _NewAnswerPageState();
}

class _NewAnswerPageState extends State<NewAnswerPage> {
  final TextEditingController _answerController = TextEditingController();

  Future<void> answerForum(String answer) async {
    // Get user
    final Users? users = Provider.of<Users?>(context, listen: false);
    final Users user = await DatabaseService(uid: users!.uid).getUserData();

    String defaultPhotoPath = 'default_profile.png';
    String defaultPhotoUrl =
        await DatabaseService(uid: user.uid).getPhotoUrl(defaultPhotoPath);

    // Create Answer
    final ForumService forumService = ForumService();

    await forumService.answerForum(
        widget.forum.forumId,
        user.uid,
        answer,
        user.profilePictureUrl ?? defaultPhotoUrl,
        user.displayName ?? "Anonymous");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Answer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Answer:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                surfaceTintColor: primary,
                foregroundColor: onPrimary,
                backgroundColor: primary,
              ),
              onPressed: () async {
                String answer = _answerController.text;
                try {
                  await answerForum(answer);
                  Navigator.pop(context, true);
                  Fluttertoast.showToast(msg: "Answer created successfully.");
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error creating answer.");
                }
              },
              child: const Text('Add your answer!'),
            ),
          ],
        ),
      ),
    );
  }
}
