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
    var veAdditionHighScore : Int = 0
    var eAdditionHighScore : Int = 0
    var hAdditionHighScore : Int = 0
    var vhAdditionHighScore : Int = 0
    var veSubtractionHighScore : Int = 0
    var eSubtractionHighScore : Int = 0
    var hSubtractionHighScore : Int = 0
    var vhSubtractionHighScore : Int = 0
    var veMultiplyHighScore : Int = 0
    var eMultiplyHighScore : Int = 0
    var hMultiplyHighScore : Int = 0
    var vhMultiplyHighScore : Int = 0
    var veDivisionHighScore : Int = 0
    var eDivisionHighScore : Int = 0
    var hDivisionHighScore : Int = 0
    var vhDivisionHighScore : Int = 0
    
    
}

