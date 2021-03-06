//
//  Library
//
//  Created by 0 on 10.05.19.
//  Copyright © 2019 Zap. All rights reserved.
//

import Foundation
import Logger

public protocol BackupService {
    func save(data: Data, nodePubKey: String, fileName: String)
}

public final class StaticChannelBackupper {
    private let backupService: BackupService

    var data: Data? {
        didSet {
            if data != oldValue {
                tryToUploadBackup()
            }
        }
    }

    var nodePubKey: String? {
        didSet {
            if nodePubKey != oldValue {
                tryToUploadBackup()
            }
        }
    }

    init(backupService: BackupService) {
        self.backupService = backupService
    }

    private func tryToUploadBackup() {
        guard
            let data = data,
            let nodePubKey = nodePubKey
            else { return }
        backupService.save(data: data, nodePubKey: nodePubKey, fileName: "channel.backup")
    }
}
