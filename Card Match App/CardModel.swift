//
//  CardModel.swift
//  Card Match App
//
//  Created by Hidaner Ferrer on 11/26/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        
        //CDeclare array to store numbers we;ve already geerated
        var generatedNumbersArray = [Int]()
        
        //We are going to declare and array to store the generated cards
        var generatedCardsArray = [Card]()
        
        //Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            let randomNumber = arc4random_uniform(13) + 1
            
            
            //Ensure that the random number isn't one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                // Log the number
                           
                print(randomNumber)
                
                //Store number into the generated numbers array
                
                generatedNumbersArray.append(Int(randomNumber))
                          
                //Create a first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                           
                //Create second pair of cards
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
                
                
            }
            
           
         
            //Make it so we only have unique card pairs of cards
            
        }
        
        //Randomize the array
        
        for i in 0...generatedCardsArray.count-1 {
        
            //Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            //Swap two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        
        }
        
        // return the array
        return generatedCardsArray
    }
    
}
