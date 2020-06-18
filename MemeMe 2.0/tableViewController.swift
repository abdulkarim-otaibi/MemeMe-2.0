//
//  tableViewController.swift
//  MemeMe 2.0
//
//  Created by Abdulkrum Alatubu on 24/10/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit

class tableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
    @IBOutlet weak var tableView: UITableView!
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
       NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }
    

    
    // this funs for refresh the tableView when we add new item
    @objc func refresh(notification: NSNotification) {
        //must be used from main thread only , becouse we need update UI  
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.memes = appDelegate.memes
            self.tableView.reloadData()
            
        }
        
    }
    
}

extension tableViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewList:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath) as! TableViewCell
        viewList.Info = memes[indexPath.row]
        return viewList
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ViewControllerOpen") as! ViewControllerOpen
        VC.setImage(img: memes[indexPath.row].memedImage!)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
