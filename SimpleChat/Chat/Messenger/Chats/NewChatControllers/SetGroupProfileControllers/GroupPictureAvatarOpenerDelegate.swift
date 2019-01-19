//
//  GroupPictureAvatarOpenerDelegate.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

extension GroupProfileTableViewController: AvatarOpenerDelegate {
    func avatarOpener(avatarPickerDidPick image: UIImage) {
        groupProfileTableHeaderContainer.profileImageView.image = image
    }
    
    func avatarOpener(didPerformDeletionAction: Bool) {
        groupProfileTableHeaderContainer.profileImageView.image = nil
    }
}

