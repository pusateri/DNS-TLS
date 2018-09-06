//
//  ServerTableViewController.swift
//  DNS-TLS
//
//  Created by Tom Pusateri on 7/21/17.
//  Copyright © 2017 !j. All rights reserved.
//

import UIKit

class ServerTableViewController: UITableViewController {

    struct TLSServerList : Decodable {
        let upstream_recursive_servers: [TLSServer]
    }

    var selected = TLSServer(address_data: "None", tls_auth_name: "Select", tls_pubkey_pinset: [])
    var servers = [TLSServer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        jsonParser()
        title = "DNS TLS Privacy Servers"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }

    func jsonParser() {
        let urlPath = "https://dnsprivacy.org/wiki/download/attachments/1277971/dns_privacy_servers.json?api=v2"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let decoder = JSONDecoder()
                let wrapper = try decoder.decode(TLSServerList.self, from: data)
                self.servers = wrapper.upstream_recursive_servers
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleIdentifier", for: indexPath)

        let server = servers[indexPath.row]
        
        // Set the text and image in the cell.
        var detail = server.address_data;
        cell.textLabel!.text = server.tls_auth_name
        if (server.tls_pubkey_pinset != nil) {
            detail += " 📌"
        }
        cell.detailTextLabel!.text = detail

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UnwindSelectSegue" {
            let destinationController = segue.destination as! ConfigurationTableViewController
            let selectedTableCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: selectedTableCell)
            let server = servers[indexPath!.row]
            destinationController.tlsserver = server
        }
    }

}
