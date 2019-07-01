//
//  MrPlannerAuthStorageService.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 6/3/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation

struct MrPlannerTokenConfig {
    static let serviceName = "MrPlannerAuth"
    static let accountName = "MrPlannerAuthToken"
    static let accessGroup: String? = nil
}

struct MrPlannerTokenSecretConfig {
    static let serviceName = "MrPlannerAuth"
    static let accountName = "MrPlannerAuthTokenSecret"
    static let accessGroup: String? = nil
}

struct MrPlannerAuthStorageService {
    static func saveAuthToken(_ token: String) {
        guard !token.isEmpty else {
            return
        }
        do {
            let tokenItem = KeychainPasswordItem(
                service: MrPlannerTokenConfig.serviceName,
                account: MrPlannerTokenConfig.accountName,
                accessGroup: MrPlannerTokenConfig.accessGroup)
            try tokenItem.savePassword(token)
        } catch {
            
            print("Saving token error: \(error)")
        }
    }
    
    static func readAuthToken() -> String {
        do {
            let tokenItem = KeychainPasswordItem(
                service: MrPlannerTokenConfig.serviceName,
                account: MrPlannerTokenConfig.accountName,
                accessGroup: MrPlannerTokenConfig.accessGroup)
            let token = try tokenItem.readPassword()
            return token
        } catch {
            print("Reading token Failed! \(error)")
        }
        return ""
    }
    
    static func saveTokenSecret(_ secret: String) {
        guard !secret.isEmpty else {
            return
        }
        do {
            let secretItem = KeychainPasswordItem(
                service: MrPlannerTokenSecretConfig.serviceName,
                account: MrPlannerTokenSecretConfig.accountName,
                accessGroup: MrPlannerTokenSecretConfig.accessGroup)
            try secretItem.savePassword(secret)
            
        } catch {
            print("Saving token secret failed: \(error)")
        }
        
    }
    
    static func readTokenSecret() -> String {
        do {
            let secretItem = KeychainPasswordItem(
                service: MrPlannerTokenSecretConfig.serviceName,
                account: MrPlannerTokenSecretConfig.accountName,
                accessGroup: MrPlannerTokenSecretConfig.accessGroup)
            let secret = try secretItem.readPassword()
            return secret
        } catch {
            print("Reading token secret failed: \(error)")
        }
        return ""
    }
    
    static func removeTokenSecret() {
        do {
            let secretItem = KeychainPasswordItem(
                service: MrPlannerTokenSecretConfig.serviceName,
                account: MrPlannerTokenSecretConfig.accountName,
                accessGroup: MrPlannerTokenSecretConfig.accessGroup)
            try secretItem.deleteItem()
        } catch {
            print("Removing item failed: \(error)")
        }
        
    }
}

