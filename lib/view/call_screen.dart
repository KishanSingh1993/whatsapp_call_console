import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import '../view_model/call_view_model.dart';
import 'package:camera/camera.dart';
import 'package:android_intent_plus/android_intent.dart'; // For Android system ringtone

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context);

    switch (callViewModel.callState) {
      case CallState.idle:
        return IdleView();
      case CallState.ringing:
        return RingingView();
      case CallState.inCall:
        return callViewModel.callType == CallType.audio ? AudioCallView() : InCallView();
      case CallState.callEnded:
        return CallEndedView();
    }
  }
}

class InCallView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('In Call')),
      body: Column(
        children: [
          if (callViewModel.callType == CallType.video &&
              callViewModel.cameraController != null &&
              callViewModel.cameraController!.value.isInitialized)
            Expanded(
              child: CameraPreview(callViewModel.cameraController!),
            )
          else
            const Expanded(
              child: Center(child: Text('Video Feed Not Available')),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (callViewModel.callType == CallType.video)
                  ElevatedButton(
                    onPressed: callViewModel.switchCamera,
                    child: const Text('Switch Camera'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: callViewModel.endCall,
                  child: const Text('End Call'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RingingView extends StatefulWidget {
  @override
  _RingingViewState createState() => _RingingViewState();
}

class _RingingViewState extends State<RingingView> {

  @override
  void initState() {
    super.initState();
    _playSystemRingtone();
  }


  Future<void> _playSystemRingtone() async {
    try {
      // Launch system default ringtone on Android
      FlutterRingtonePlayer.playRingtone();

      const intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'content://settings/system/ringtone',
      );
      await intent.launch();
    } catch (e) {
      debugPrint("Error playing system ringtone: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming ${callViewModel.callType == CallType.audio ? "Audio" : "Video"} Call',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    callViewModel.acceptCall();
                    FlutterRingtonePlayer.stop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    callViewModel.rejectCall();
                    FlutterRingtonePlayer.stop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IdleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Call Console')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => callViewModel.initiateCall(CallType.audio),
              child: const Text('Initiate Audio Call'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => callViewModel.initiateCall(CallType.video),
              child: const Text('Initiate Video Call'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => callViewModel.receiveCall(CallType.audio),
              child: const Text('Simulate Incoming Call'),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioCallView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Audio Call in Progress', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            IconButton(
              onPressed: callViewModel.toggleMute,
              icon: Icon(callViewModel.isMuted ? Icons.mic_off : Icons.mic, size: 40),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: callViewModel.endCall,
              child: const Text('End Call'),
            ),
          ],
        ),
      ),
    );
  }
}

class CallEndedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Call Ended')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Call Ended'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: callViewModel.resetState,
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

