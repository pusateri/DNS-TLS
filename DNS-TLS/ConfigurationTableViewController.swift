//
//  ConfigurationTableViewController.swift
//  DNS-TLS
//
//  Created by Tom Pusateri on 6/27/17.
//  Copyright © 2017 !j. All rights reserved.
//

import UIKit
import os.log
import NetworkExtension

let DEFAULT_PADDING_BLOCKSIZE = 256
let DEFAULT_IDLE_TIMEOUT = 10000
let DEFAULT_EDNS_CLIENT_SUBNET_PRIVATE = true
let ROUND_ROBIN_UPSTREAMS = true

class ConfigurationTableViewController: UITableViewController {
    let manager = NEDNSProxyManager.shared()
    var tlsserver = TLSServer(address_data: "None", tls_auth_name: "Select", tls_pubkey_pinset: [])
    var padding_blocksize = DEFAULT_PADDING_BLOCKSIZE
    var idle_timeout = DEFAULT_IDLE_TIMEOUT
    var edns_client_subnet_private = DEFAULT_EDNS_CLIENT_SUBNET_PRIVATE
    var round_robin_upstreams = ROUND_ROBIN_UPSTREAMS

    @IBOutlet weak var selectedLabel: UILabel!

    private func update(_ body: @escaping () -> Void) {
        self.manager.loadFromPreferences { (error) in
            guard error == nil else {
                NSLog("Load error: \(String(describing: error?.localizedDescription))")
                return
            }
            body()
            self.manager.saveToPreferences { (error) in
                guard error == nil else {
                    os_log("Save error")
                    return
                }
            }
        }
    }

    private func enable() {
        self.update {
            self.manager.localizedDescription = "DNS-TLS-Proxy"
            let dict = ["foo": "bar"]
            let proto = NEDNSProxyProviderProtocol()
            proto.providerConfiguration = dict
            proto.providerBundleIdentifier = "com.bangj.DNS-TLS.DNS-TLS-Proxy"
            self.manager.providerProtocol = proto
            self.manager.isEnabled = true
        }
    }
    
    private func disable() {
        self.update {
            self.manager.isEnabled = false
        }
    }

    private func buildConfig() -> Dictionary <String, Any> {
        var config = [String: Any]()
        config["resolution_type"] = "GETDNS_RESOLUTION_STUB"
        config["dns_transport_list"] = ["GETDNS_TRANSPORT_TLS", ]
        config["tls_authentication"] = "GETDNS_AUTHENTICATION_REQUIRED"
        config["tls_query_padding_blocksize"] = self.padding_blocksize
        config["edns_client_subnet_private"] = self.edns_client_subnet_private
        config["idle_timeout"] = self.idle_timeout
        config["round_robin_upstreams"] = self.round_robin_upstreams

        return config
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            enable()
        } else {
            disable()
        }
    }

    @IBAction func loggingValueChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            enableLogging()
        } else {
            disableLogging()
        }
    }

    private func enableLogging() {
        os_log("enable Logging")
    }

    private func disableLogging() {
        os_log("disable Logging")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.selectedLabel.text = self.tlsserver.tls_auth_name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ServerSelectionSegue" {
            let destinationController = segue.destination as! ServerTableViewController
            destinationController.selected = self.tlsserver
        }
    }

    @IBAction func unwindCancel(_ segue: UIStoryboardSegue) {
        assert(segue.identifier == "UnwindCancelSegue")
    }

    @IBAction func unwindWithSelection(_ segue: UIStoryboardSegue) {
        if (segue.identifier == "UnwindSelectSegue") {
            if self.tlsserver.tls_auth_name != nil && self.tlsserver.tls_auth_name!.count > 0 {
                self.selectedLabel.text = self.tlsserver.tls_auth_name
            } else {
                self.selectedLabel.text = self.tlsserver.address_data
            }
        }
        
        // build a new configuration to send to stubby
        
    }
}
