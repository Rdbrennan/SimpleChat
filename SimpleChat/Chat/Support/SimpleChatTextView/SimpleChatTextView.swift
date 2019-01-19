//
//  FalconTextView.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class SimpleChatTextView: UITextView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: convertToUITextDirection(UITextLayoutDirection.left.rawValue)) else { return false }
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        
        return attributedText.attribute(NSAttributedString.Key.link, at: startIndex, effectiveRange: nil) != nil
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUITextDirection(_ input: Int) -> UITextDirection {
	return UITextDirection(rawValue: input)
}
