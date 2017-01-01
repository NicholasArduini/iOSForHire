//
//  RatingControl.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    var alignLeft = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var enabled = true
    var ratingButtons = [UIButton]()
    let spacing = 5
    let starCount = 5
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStarImage, for: .normal)
            button.setImage(filledStarImage, for: .selected)
            button.setImage(filledStarImage, for: [.highlighted, .selected])
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchDown)
            ratingButtons += [button]
            addSubview(button)
        }
        
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        let widthX = Int(frame.size.width) / Int((starCount+1))
        var buttonX = widthX
        
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerated() {
            var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
            if(alignLeft){
                buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            } else {
                buttonFrame.origin.x = CGFloat(buttonX - widthX/6)
            }
            
            button.frame = buttonFrame
            buttonX += widthX
        }
        
        updateButtonSelectionStates()
    }

    func ratingButtonTapped(button: UIButton) {
        if(enabled){
            rating = ratingButtons.index(of: button)! + 1
            updateButtonSelectionStates()
        }
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }

}
