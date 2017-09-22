//
//  ViewController.swift
//  VainGloryURLPractice
//
//  Created by Tennant Shaw on 9/11/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource {
    //MARK: - Properties
    let urlString = "https://api.dc01.gamelockerapp.com/shards/na/samples"
    @IBOutlet var tableView: UITableView!
    var dataArray = [String]()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadJsonWithTask()
    }

    
    //MARK: - TableViewDelegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.DataLabelOutlet.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    
    //MARK: - Methods
    func downloadJsonWithTask() {
        let url = NSURL(string: urlString)
        
        var downloadTask = URLRequest(url: (url as URL?)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        downloadTask.httpMethod = "GET"
    downloadTask.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJiOTIwNTM2MC03NTUwLTAxMzUtMDc2NC0yNjU5ZGNhZmNkOWEiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNTA0NzE2MzMyLCJwdWIiOiJzZW1jIiwidGl0bGUiOiJ2YWluZ2xvcnkiLCJhcHAiOiJiOTEyNTJiMC03NTUwLTAxMzUtMDc2Mi0yNjU5ZGNhZmNkOWEiLCJzY29wZSI6ImNvbW11bml0eSIsImxpbWl0IjoxMH0.sEQeY5CxgrQpPtiSn8R9TlmhIEDmHYumN_1AssKAcB4", forHTTPHeaderField: "Authorization")
        downloadTask.addValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: downloadTask) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            print(jsonData!.value(forKey: "data") as Any)
                    if let sampleArray = jsonData!.value(forKey: "data") as? NSArray {
                        for sample in sampleArray {
                            if let dataDict = sample as? NSDictionary {
                                if let name = dataDict.value(forKey: "id") {
                                    self.dataArray.append(name as! String)
                                }
                                
                                OperationQueue.main.addOperation({ 
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}

