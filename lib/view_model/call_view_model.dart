import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

enum CallState { idle, ringing, inCall, callEnded }
enum CallType { audio, video }

class CallViewModel extends ChangeNotifier {
  CallState _callState = CallState.idle;
  CallType? _callType;
  bool _isMuted = false;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isUsingFrontCamera = true;

  CallState get callState => _callState;
  CallType? get callType => _callType;
  bool get isMuted => _isMuted;

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  void simulateIncomingCall(CallType type) {
    _callType = type;
    _callState = CallState.ringing;
    notifyListeners();
  }
    void initiateCall(CallType type) async {
    _callType = type;
    _callState = CallState.inCall;

    if (type == CallType.video) {
      await _initializeFrontCamera();
    }
    notifyListeners();
  }

  void acceptCall() async {
    _callState = CallState.inCall;

    if (_callType == CallType.video) {
      await _initializeFrontCamera();
    }
    notifyListeners();
  }

  void rejectCall() {
    _callState = CallState.callEnded;
    resetState();
  }

  Future<void> _initializeFrontCamera() async {
    if (_cameras.isNotEmpty) {
      _cameraController?.dispose();
      _cameraController = CameraController(
        _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high,
      );
      await _cameraController?.initialize();
      _isUsingFrontCamera = true;
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (_cameras.isNotEmpty) {
      _cameraController?.dispose();
      _isUsingFrontCamera = !_isUsingFrontCamera;
      _cameraController = CameraController(
        _cameras.firstWhere((camera) =>
        _isUsingFrontCamera
            ? camera.lensDirection == CameraLensDirection.front
            : camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.high,
      );
      await _cameraController?.initialize();
      notifyListeners();
    }
  }

    void receiveCall(CallType type) {
    _callType = type;
    _callState = CallState.ringing;
    notifyListeners();
  }

  void declineCall() {
    _callState = CallState.callEnded;
    notifyListeners();
  }
  void endCall() {
    _callState = CallState.callEnded;
    _cameraController?.dispose();
    _cameraController = null;
    notifyListeners();
  }


  void resetState() {
    _callState = CallState.idle;
    _callType = null;
    _isMuted = false;
    notifyListeners();
  }
}










// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// enum CallState { idle, ringing, inCall, callEnded }
// enum CallType { audio, video }
//
// class CallViewModel extends ChangeNotifier {
//   CallState _callState = CallState.idle;
//   CallType? _callType;
//   bool _isMuted = false; // For audio calls
//   CameraController? _cameraController;
//   List<CameraDescription> _cameras = [];
//   bool _isUsingFrontCamera = true;
//
//   bool get isMuted => _isMuted;
//   CallState get callState => _callState;
//   CallType? get callType => _callType;
//   CameraController? get cameraController => _cameraController;
//
//   Future<void> initializeCameras() async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras.isNotEmpty) {
//         _cameraController = CameraController(
//           _cameras.first,
//           ResolutionPreset.high,
//         );
//         await _cameraController?.initialize();
//       }
//     } catch (e) {
//       debugPrint('Camera initialization failed: $e');
//     }
//   }
//
//   void initiateCall(CallType type) async {
//     _callType = type;
//     _callState = CallState.inCall;
//
//     if (type == CallType.video) {
//       await _initializeFrontCamera();
//     }
//     notifyListeners();
//   }
//
//   Future<void> _initializeFrontCamera() async {
//     if (_cameras.isNotEmpty) {
//       _cameraController?.dispose();
//       _cameraController = CameraController(
//         _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
//         ResolutionPreset.high,
//       );
//       await _cameraController?.initialize();
//       _isUsingFrontCamera = true;
//     }
//   }
//
//   Future<void> switchCamera() async {
//     if (_cameras.isNotEmpty) {
//       _cameraController?.dispose();
//       _isUsingFrontCamera = !_isUsingFrontCamera;
//       _cameraController = CameraController(
//         _cameras.firstWhere((camera) =>
//         _isUsingFrontCamera
//             ? camera.lensDirection == CameraLensDirection.front
//             : camera.lensDirection == CameraLensDirection.back),
//         ResolutionPreset.high,
//       );
//       await _cameraController?.initialize();
//       notifyListeners();
//     }
//   }
//
//   void toggleMute() {
//     _isMuted = !_isMuted;
//     notifyListeners();
//   }
//
//   void receiveCall(CallType type) {
//     _callType = type;
//     _callState = CallState.ringing;
//     notifyListeners();
//   }
//
//   void acceptCall() {
//     _callState = CallState.inCall;
//     notifyListeners();
//   }
//
//   void declineCall() {
//     _callState = CallState.callEnded;
//     notifyListeners();
//   }
//   void endCall() {
//     _callState = CallState.callEnded;
//     _cameraController?.dispose();
//     _cameraController = null;
//     notifyListeners();
//   }
//
//   void resetState() {
//     _callState = CallState.idle;
//     _callType = null;
//     notifyListeners();
//   }
// }
//
//
//
//
//
//
//
//
//
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// //
// // enum CallState { idle, ringing, inCall, callEnded }
// //
// // enum CallType { audio, video }
// //
// // class CallViewModel extends ChangeNotifier {
// //   CallState _callState = CallState.idle;
// //   CallType? _callType;
// //
// //   CallState get callState => _callState;
// //   CallType? get callType => _callType;
// //   CameraController? _cameraController;
// //   List<CameraDescription> _cameras = [];
// //   bool _isUsingFrontCamera = true;
// //
// //   Future<void> initializeCameras() async {
// //     _cameras = await availableCameras();
// //     if (_cameras.isNotEmpty) {
// //       _cameraController = CameraController(
// //         _cameras.first,
// //         ResolutionPreset.high,
// //       );
// //       await _cameraController?.initialize();
// //     }
// //   }
// //
// //   void initiateCall(CallType type) async {
// //     _callType = type;
// //     _callState = CallState.inCall;
// //
// //     if (type == CallType.video) {
// //       await _initializeFrontCamera();
// //     }
// //     notifyListeners();
// //   }
// //
// //   Future<void> _initializeFrontCamera() async {
// //     if (_cameras.isNotEmpty) {
// //       _cameraController?.dispose();
// //       _cameraController = CameraController(
// //         _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
// //         ResolutionPreset.high,
// //       );
// //       await _cameraController?.initialize();
// //       _isUsingFrontCamera = true;
// //     }
// //   }
// //
// //   Future<void> switchCamera() async {
// //     if (_cameras.isNotEmpty) {
// //       _cameraController?.dispose();
// //       _isUsingFrontCamera = !_isUsingFrontCamera;
// //       _cameraController = CameraController(
// //         _cameras.firstWhere((camera) =>
// //         _isUsingFrontCamera
// //             ? camera.lensDirection == CameraLensDirection.front
// //             : camera.lensDirection == CameraLensDirection.back),
// //         ResolutionPreset.high,
// //       );
// //       await _cameraController?.initialize();
// //       notifyListeners();
// //     }
// //   }
// //
// //   void receiveCall(CallType type) {
// //     _callType = type;
// //     _callState = CallState.ringing;
// //     notifyListeners();
// //   }
// //
// //   void acceptCall() {
// //     _callState = CallState.inCall;
// //     notifyListeners();
// //   }
// //
// //   void declineCall() {
// //     _callState = CallState.callEnded;
// //     notifyListeners();
// //   }
// //
// //   void endCall() {
// //     _callState = CallState.callEnded;
// //     notifyListeners();
// //   }
// //
// //   void resetState() {
// //     _callState = CallState.idle;
// //     _callType = null;
// //     notifyListeners();
// //   }
// // }
