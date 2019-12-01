//
//  HistoryViewController.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    let data = TestManager.papers()
    
    let f = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        f.dateFormat = "yyyy-MM-dd HH:mm"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let paper = data[indexPath.row]
        
        
        cell.textLabel?.text = String(format: "Test Score: %d%%", paper.score)
        cell.detailTextLabel?.text = f.string(from: paper.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let paper = data[indexPath.row]
        self.performSegue(withIdentifier: "paper", sender: paper)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paper"
        {
            let vc = segue.destination as! TestViewController
            vc.paper = sender as? Paper
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
