//
//  EnvironmentVariables.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation


struct EnvironmentVariables {
    static let REST_HEAD = Bundle.main.object(forInfoDictionaryKey: "REST_HEAD")
    static let REST_PORT  = Bundle.main.object(forInfoDictionaryKey: "REST_PORT")
    static let JWT_KEYCHAIN_KEY  = Bundle.main.object(forInfoDictionaryKey: "JWT_KEYCHAIN_KEY")
}
