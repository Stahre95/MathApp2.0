//
//  userScore.swift
//  MathApp2.0
//
//  Created by Johan Stahre on 2021-03-01.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct userScore : Codable, Identifiable {
    @DocumentID var id : String?
    var displayName : String
    var additionHighScore : Int = 0
    var subtractionHighScore : Int = 0
    var multiplyHighScore : Int = 0
    var divisionHighScore : Int = 0
    
    
}

