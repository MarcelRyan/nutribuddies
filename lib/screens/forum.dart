import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewDiscussionPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Start A Discussion!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  primary: false,
                  children: const [
                    DiscussionCard(
                      userProfile: 'A',
                      userName: 'John Doe',
                      createdAt: '2 hours ago',
                      question: 'What is your favorite programming language?',
                      answers: 2,
                      isTopic: true,
                    ),
                    DiscussionCard(
                      userProfile: 'B',
                      userName: 'Jane Smith',
                      createdAt: '1 day ago',
                      question: 'Flutter vs React Native - pros and cons?',
                      answers: 3,
                      isTopic: true,
                    ),
                    DiscussionCard(
                      userProfile: 'A',
                      userName: 'John Doe',
                      createdAt: '2 hours ago',
                      question: 'What is your favorite programming language?',
                      answers: 2,
                      isTopic: true,
                    ),
                    DiscussionCard(
                      userProfile: 'B',
                      userName: 'Jane Smith',
                      createdAt: '1 day ago',
                      question: 'Flutter vs React Native - pros and cons?',
                      answers: 3,
                      isTopic: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class DiscussionCard extends StatelessWidget {
  final String userProfile;
  final String userName;
  final String createdAt;
  final String question;
  final int answers;
  final bool isTopic;

  const DiscussionCard({
    Key? key,
    required this.userProfile,
    required this.userName,
    required this.createdAt,
    required this.question,
    required this.isTopic,
    this.answers = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isTopic) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscussionPage(),
            ),
          );
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
                    child: Text(userProfile),
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
                      Text(createdAt),
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
              answers != 0
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

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discussion Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question
              const DiscussionCard(
                userProfile: 'A',
                userName: 'John Doe',
                createdAt: '2 hours ago',
                question: 'What is your favorite programming language?',
                answers: 4,
                isTopic: false,
              ),
              const SizedBox(height: 8),
              // Button to add a new answer
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    surfaceTintColor: primary,
                    foregroundColor: onPrimary,
                    backgroundColor: primary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewAnswerPage(),
                    ),
                  );
                },
                child: const Text('Add New Answer'),
              ),
              const SizedBox(height: 16),
              // Answers
              const Text(
                "Answers (14)",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                primary: false,
                children: const [
                  DiscussionCard(
                    userProfile: 'A',
                    userName: 'John Doe',
                    createdAt: '2 hours ago',
                    question: 'What is your favorite programming language?',
                    isTopic: false,
                  ),
                  DiscussionCard(
                    userProfile: 'B',
                    userName: 'Jane Smith',
                    createdAt: '1 day ago',
                    question: 'Flutter vs React Native - pros and cons?',
                    isTopic: false,
                  ),
                  DiscussionCard(
                    userProfile: 'A',
                    userName: 'John Doe',
                    createdAt: '2 hours ago',
                    question: 'What is your favorite programming language?',
                    isTopic: false,
                  ),
                  DiscussionCard(
                    userProfile: 'B',
                    userName: 'Jane Smith',
                    createdAt: '1 day ago',
                    question: 'Flutter vs React Native - pros and cons?',
                    isTopic: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewDiscussionPage extends StatelessWidget {
  const NewDiscussionPage({super.key});

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
            const TextField(
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter discussion title...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  surfaceTintColor: primary,
                  foregroundColor: onPrimary,
                  backgroundColor: primary),
              onPressed: () {
                // Handle starting a new discussion
              },
              child: const Text('Start Discussion!'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewAnswerPage extends StatelessWidget {
  const NewAnswerPage({Key? key}) : super(key: key);

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
            const TextField(
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  surfaceTintColor: primary,
                  foregroundColor: onPrimary,
                  backgroundColor: primary),
              onPressed: () {
                // Handle add new answer
              },
              child: const Text('Add your answer!'),
            ),
          ],
        ),
      ),
    );
  }
}
