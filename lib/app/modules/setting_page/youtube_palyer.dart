import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<VideoData> videos = [
    VideoData(
      url: 'https://youtube.com/shorts/PVHKi5ivD7k?si=s5Kjs7omn-YTAQ0e',
      title: 'Portrait Video 1',
      isPortrait: true,
    ),
    VideoData(
      url: 'https://www.youtube.com/watch?v=x0uinJvhNxI',
      title: 'Landscape Video',
      isPortrait: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Videos'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return VideoListItem(video: video);
        },
      ),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final VideoData video;

  const VideoListItem({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(video.title),
      subtitle: Text(video.url),
      trailing: Icon(
        video.isPortrait
            ? Icons.stay_current_portrait
            : Icons.stay_current_landscape,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => VideoBottomSheet(video: video),
        );
      },
    );
  }
}

class VideoBottomSheet extends StatefulWidget {
  final VideoData video;

  const VideoBottomSheet({
    super.key,
    required this.video,
  });

  @override
  State<VideoBottomSheet> createState() => _VideoBottomSheetState();
}

class _VideoBottomSheetState extends State<VideoBottomSheet> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final videoId = YoutubePlayerController.convertUrlToId(widget.video.url);
    if (videoId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid YouTube URL')),
        );
      });
      return;
    }

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );

    await _controller.loadVideo(videoId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final height = widget.video.isPortrait
        ? screenSize.height * 0.9
        : screenSize.height * 0.7;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bottom sheet handle and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          // Video title and URL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.video.url,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // YouTube Player
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: widget.video.isPortrait ? 9 / 16 : 16 / 9,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoData {
  final String url;
  final String title;
  final bool isPortrait;

  const VideoData({
    required this.url,
    required this.title,
    this.isPortrait = false,
  });
}
