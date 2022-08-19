//
//  ReviewCell.swift
//  MovieList
//
//  Created by Toygun Çil on 18.08.2022.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewComment: UILabel!
    @IBOutlet weak var reviewUserName: UILabel!
    
    func configureReviewCell(with comment: Comment?) {
        reviewUserName.text = comment?.aouthor
        reviewComment.text = comment?.content
    }
}
