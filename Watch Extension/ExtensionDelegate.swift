//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by Tiago Santo on 24/11/2019.
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import WatchKit
import WatchConnectivity

@main
class ExtensionDelegate: NSObject, WKApplicationDelegate {

    private lazy var sessionDelegater: SessionDelegater = {
        return SessionDelegater()
    }()

    /// Hold the KVO observers as we want to keep oberving in the extension life time.
    ///
    private var activationStateObservation: NSKeyValueObservation?
    private var hasContentPendingObservation: NSKeyValueObservation?

    /// An array to keep the background tasks.
    ///
    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()

    override init() {
        super.init()

        activationStateObservation = WCSession.default.observe(\.activationState) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }
        hasContentPendingObservation = WCSession.default.observe(\.hasContentPending) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }

        WCSession.default.delegate = sessionDelegater
        WCSession.default.activate()
    }

    /// Compelete the background tasks, and schedule a snapshot refresh.
    ///
    func completeBackgroundTasks() {
        guard !wcBackgroundTasks.isEmpty else { return }

        guard WCSession.default.activationState == .activated,
            WCSession.default.hasContentPending == false else { return }

        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }

        let date = Date(timeIntervalSinceNow: 1)
        WKApplication.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil) { error in
            if let error = error {
                print("scheduleSnapshotRefresh error: \(error)!")
            }
        }
        wcBackgroundTasks.removeAll()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let wcTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                wcBackgroundTasks.append(wcTask)
            } else {
                task.setTaskCompletedWithSnapshot(false)
            }
        }
        completeBackgroundTasks()
    }
}
