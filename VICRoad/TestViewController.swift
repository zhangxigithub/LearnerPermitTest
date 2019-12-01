//
//  TestViewController.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,QuestionCellDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var paper : Paper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        if paper == nil
        {
            //paper = Paper.randomPaper()
            paper = Paper.all()
        }else
        {
            progressView.progress = 1
            quitButton.setTitle("", for: .normal)
            quitButton.setImage(UIImage(named: "back"), for: .normal)
            submitButton.setTitle(String(format: "Score: %d%%", paper.score), for: .normal)
        }
        
    }
    

    
    @IBAction func quit(_ sender: Any) {
        
        if paper.isSubmit
        {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Quit?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    
    
    @IBAction func submit(_ sender: Any) {
        
        if  paper.isSubmit
        {
            return
        }
        
        
        TestManager.savePaper(paper: paper)
        
        
        paper.isSubmit = true
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        self.submitButton.setTitle(String(format: "Score: %d%%", paper.score), for: .normal)
    }
    
    
    
    func answer(indexPath: IndexPath, answer: Int) {
        
        
        let question = paper.questions[indexPath.row]
        
        if question.myAnswer == nil
        {
            if indexPath.row + 1 < paper.questions.count
            {
                if paper.questions[indexPath.row + 1].myAnswer == nil
                {
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        
        
        question.myAnswer = answer
        progressView.progress = paper.percentage
        
    }
    
    func tapImageView(cell:QuestionCell) {
    
        print(cell.questionImageView.frame)
        print(cell.frame)
        
        print(tableView.contentInset.top)
        
        let frame = CGRect(x: cell.frame.origin.x + cell.questionImageView.frame.origin.x,
                           y: cell.frame.origin.y + cell.questionImageView.frame.origin.y - tableView.contentOffset.y + tableView.frame.origin.y,
                           width: cell.questionImageView.frame.size.width,
                           height: cell.questionImageView.frame.size.height)
        
        ImageViewController.showImage(image:cell.questionImageView.image,
                                      frame: frame,
                                      parent: self)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paper.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionCell
        cell.indexPath = indexPath
        cell.question = paper.questions[indexPath.row]
        cell.delegate = self
        if paper.isSubmit
        {
            cell.showAnswer = true
        }
        return cell
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
