//
//  OutgoingTextMessageCell.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit


class OutgoingTextMessageCell: BaseMessageCell {
    
    let textView: SimpleChatTextView = {
        let textView = SimpleChatTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets.init(top: 10, left: 7, bottom: 10, right: 7)
        textView.dataDetectorTypes = .all
        textView.textColor = .white
        textView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.underlineStyle.rawValue: NSUnderlineStyle.single.rawValue])
        
        return textView
    }()
    
    func setupData(message: Message) {
        
        self.message = message
        guard let messageText = message.text else { return }
        textView.text = messageText
        
        bubbleView.frame = CGRect(x: frame.width - message.estimatedFrameForText!.width - 40, y: 0,
                                  width: message.estimatedFrameForText!.width + 30, height: frame.size.height).integral
        textView.frame.size = CGSize(width: bubbleView.frame.width.rounded(), height: bubbleView.frame.height.rounded())
        
        setupTimestampView(message: message, isOutgoing: true)
    }
    
    override func setupViews() {
        bubbleView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:))) )
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(textView)
        contentView.addSubview(deliveryStatus)
        bubbleView.image = blueBubbleImage
    }
    
    override func prepareViewsForReuse() {
        bubbleView.image = blueBubbleImage
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
