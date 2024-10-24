//
//  BuiltInChallengesManager.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/24/24.
//

import Foundation

final class BuiltInChallengesManager {
    private var plistConfig: BuiltInConfig? {
        guard let filePath = Bundle.main.path(forResource: "BuiltInChallenges", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
        let config = try? PropertyListDecoder().decode(BuiltInConfig.self, from: data)
        return config
    }
    
    var shouldSync: Bool {
        let savedVersion = UserDefaults.standard.double(forKey: "BuiltInSyncVersion")
        let plistVersion = plistConfig?.version ?? 0.0
        
        return savedVersion.distance(to: plistVersion) > 0
    }
    
    func syncIfNeeded(completion: @escaping (() -> Void)) {
        guard shouldSync, let config = plistConfig else {
            completion()
            return
        }
        
        DatabaseService.shared.saveBuiltIn(challenges: config.challenges) { finished in
            DispatchQueue.main.async {
                if finished {
                    UserDefaults.standard.set(config.version, forKey: "BuiltInSyncVersion")
                }
                
                completion()
            }
        }
    }
}
