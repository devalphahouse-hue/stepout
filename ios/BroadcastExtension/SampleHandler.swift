//
//  SampleHandler.swift
//  BroadcastExtension
//
//  Entry point of the ReplayKit Broadcast Upload Extension (principal class).
//  Source: jitsi-meet / react-native-webrtc broadcast sample.
//
//  IMPORTANT: appGroupIdentifier MUST match:
//   - the App Group capability on BOTH the Runner and this extension target
//   - the `RTCAppGroupIdentifier` key in Runner/Info.plist
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {

  private var clientConnection: SocketConnection?
  private var uploader: SampleUploader?
  private var frameCount: Int = 0

  private let appGroupIdentifier = "group.br.com.stepout.aluno"

  private var socketFilePath: String {
    guard let sharedContainer = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
      return ""
    }
    return sharedContainer.appendingPathComponent("rtc_SSFD").path
  }

  override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
    frameCount = 0

    guard let connection = SocketConnection(filePath: socketFilePath) else {
      return
    }
    clientConnection = connection
    setupConnection()

    uploader = SampleUploader(connection: connection)
    openConnection()
  }

  override func broadcastPaused() {}

  override func broadcastResumed() {}

  override func broadcastFinished() {
    clientConnection?.close()
    DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
  }

  override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    switch sampleBufferType {
    case .video:
      // Throttle to every other frame to keep CPU/bandwidth reasonable.
      if frameCount % 2 == 0 {
        uploader?.send(sample: sampleBuffer)
      }
      frameCount += 1
    default:
      break
    }
  }
}

private extension SampleHandler {

  func setupConnection() {
    clientConnection?.didClose = { [weak self] error in
      print("client connection did close: \(String(describing: error))")

      if let error = error {
        self?.finishBroadcastWithError(error)
      } else {
        let customError = NSError(
          domain: RPRecordingErrorDomain,
          code: 10001,
          userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped"]
        )
        self?.finishBroadcastWithError(customError)
      }
    }
  }

  func openConnection() {
    let queue = DispatchQueue(label: "org.jitsi.meet.broadcast.connectTimer")
    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
    timer.setEventHandler { [weak self] in
      guard self?.clientConnection?.open() == true else {
        return
      }
      timer.cancel()
      self?.notifyServerStarted()
    }
    timer.resume()
  }

  func notifyServerStarted() {
    DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
  }
}
