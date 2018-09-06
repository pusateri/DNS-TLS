//
//  TLSServer.swift
//  DNS-TLS
//
//  Created by Tom Pusateri on 7/22/17.
//  Copyright © 2017 !j. All rights reserved.
//

import UIKit

class TLSServer: Decodable {
    struct Pinset: Decodable {
        let digest: String
        let value: String
    }
    
    let address_data: String
    let tls_auth_name: String?
    let tls_pubkey_pinset: [Pinset]?
    
    init(address_data: String, tls_auth_name: String = "", tls_pubkey_pinset: [Pinset]) {
        self.address_data = address_data
        self.tls_auth_name = tls_auth_name
        self.tls_pubkey_pinset = tls_pubkey_pinset
    }
}

