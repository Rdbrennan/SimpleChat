//
//  AddGroupMembersController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class AddGroupMembersController: SelectParticipantsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButton(with: "Add")
        setupNavigationItemTitle(title: "Add users")
    }
    
    override func rightBarButtonTapped() {
        super.rightBarButtonTapped()
        
        addNewMembers()
    }
}
