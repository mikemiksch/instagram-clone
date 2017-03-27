//
//  Stretch Goals.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/27/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import Foundation

// Write a function that takes in a sentence as a String and determines how many words there are in it.

func wordCounter(_ input: String) -> Int {
    let words = input.characters.split { $0 == " " }
    print(words.count)
    return words.count
}


