//
//  QuestionCell.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import UIKit
import SDWebImage

let RightColor = UIColor(red: 127.0/255.0, green: 184.0/255.0, blue: 20.0/255.0, alpha: 1)
let WrongColor = UIColor(red: 182.0/255.0, green: 0, blue: 22.0/255.0, alpha: 1)
let TextColor = UIColor(white: 0.64, alpha: 1)



protocol QuestionCellDelegate {
    func answer(indexPath:IndexPath,answer:Int)
    func tapImageView(cell:QuestionCell)
}

class QuestionCell: UITableViewCell {

    var delegate : QuestionCellDelegate!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var answerButtonC: UIButton!
    
    
    
    @IBOutlet weak var questionImageView: UIImageView!
    
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var markView: UIImageView!
    
    
    var indexPath : IndexPath!
    var question  : Question!
    {
        didSet{
            titleLabel.text = String(self.indexPath.row+1) + ". " + question.title
            
            if question.image != nil
            {
                questionImageView.sd_setImage(with: URL(string: question.image!)!)
                imageLeftConstraint.constant = 10
            }else
            {
                imageLeftConstraint.constant = -90
            }
            answerA.text = question.answers[0]
            answerB.text = question.answers[1]
            answerC.text = question.answers[2]
            
            
            if question.myAnswer != nil
            {
                for i in 0 ..< 3
                {
                    let button = buttonAndLebel(index: i).button
                    if question.myAnswer! == i
                    {
                        button.selected()
                    }else
                    {
                        button.unselected()
                    }
                }
            }else
            {
                answerButtonA.unselected()
                answerButtonB.unselected()
                answerButtonC.unselected()
            }

        }
    }
    var showAnswer : Bool = false
    {
        didSet{
            
            if showAnswer
            {
                if question.myAnswer == nil
                {
                    for i in 0 ..< 3
                    {
                        if i == question.answer
                        {//right
                            let control = buttonAndLebel(index: i)
                            control.label.textColor = RightColor
                            control.button.right()
                        }else
                        {//empty
                            let control = buttonAndLebel(index: i)
                            control.label.textColor = TextColor
                            control.button.unselected()
                        }
                    }
                    self.markView.image = UIImage(named: "answer_wrong")
                }else
                {
                    //right
                    if question.myAnswer! == question.answer
                    {
                        for i in 0 ..< 3
                        {
                            if i == question.myAnswer!
                            {//right
                                let control = buttonAndLebel(index: i)
                                control.label.textColor = RightColor
                                control.button.right()
                            }else
                            {//empty
                                let control = buttonAndLebel(index: i)
                                control.label.textColor = TextColor
                                control.button.unselected()
                            }
                        }
                        self.markView.image = UIImage(named: "answer_right")
                    }else
                    {
                        //wrong answer
                        for i in 0 ..< 3
                        {
                            if i == question.myAnswer!
                            {//my answer is wrong
                                let control = buttonAndLebel(index: i)
                                control.label.textColor = WrongColor
                                control.button.wrong()
                            }else if i == question.answer
                            {//true answer
                                let control = buttonAndLebel(index: i)
                                control.label.textColor = RightColor
                                control.button.right()
                            }else
                            {//empty
                                let control = buttonAndLebel(index: i)
                                control.label.textColor = TextColor
                                control.button.unselected()
                            }
                        }
                        
                        self.markView.image = UIImage(named: "answer_wrong")
                    }
                }
            }else
            {
                for i in 0 ..< 3
                {
                    let control = buttonAndLebel(index: i)
                    control.label.textColor = TextColor
                }
                self.markView.image = nil
            }
            

        }
    }
    
    func buttonAndLebel(index:Int)->(button:UIButton,label:UILabel)
    {
        return (button: [answerButtonA,answerButtonB,answerButtonC][index]!,
                label:[answerA,answerB,answerC][index]!)
    }
    
    @IBAction func tapAnswerButton(_ sender: UIButton) {
        if showAnswer {return }
        
        for i in 0 ..< 3
        {
            let button = buttonAndLebel(index: i).button
            if sender.tag == i
            {
                button.selected()
            }else
            {
                button.unselected()
            }
        }
        
        
        self.delegate.answer(indexPath: self.indexPath, answer: sender.tag)
    }
    
    @IBAction func tapAnswer(_ sender: UITapGestureRecognizer) {
        if showAnswer {return }
        let answer = (sender.view as! UILabel).tag
        self.delegate.answer(indexPath: self.indexPath, answer: answer)
        
        for i in 0 ..< 3
        {
            let button = buttonAndLebel(index: i).button
            if answer == i
            {
                button.selected()
            }else
            {
                button.unselected()
            }
        }
    }
    @objc func tapImage(_ sender: UITapGestureRecognizer) {
        
        self.delegate.tapImageView(cell: self)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        for label in [answerA,answerB,answerC]
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(QuestionCell.tapAnswer(_:)))
            label?.addGestureRecognizer(tap)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(QuestionCell.tapImage(_:)))
        questionImageView.addGestureRecognizer(tap)
    }
}


extension UIButton
{
    func unselected()
    {
        self.setImage(UIImage(named: "unselected"), for: .normal)
    }
    func selected()
    {
        self.setImage(UIImage(named: "selected"), for: .normal)
    }
    func right()
    {
        self.setImage(UIImage(named: "right"), for: .normal)
    }
    func wrong()
    {
        self.setImage(UIImage(named: "wrong"), for: .normal)
    }
}
