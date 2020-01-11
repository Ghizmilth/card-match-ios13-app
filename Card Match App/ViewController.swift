//
//  ViewController.swift
//  Card Match App
//
//  Created by Hidaner Ferrer on 11/26/19.
//  Copyright © 2019 Hidaner Ferrer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000
    
//    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
        cardArray = model.getCards();
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
       
        //Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }

    //MARK: - Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        //Conver to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //SEt label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //Wehn the timer has reached zero 0...
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if there are any cards left
            checkGameEnded()
            
        }
    
    }
    //MARK: UICollectionVIew Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        //Get the card that the colelection view is trying to display
        let card = cardArray[indexPath.row]
        
        //Set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //CHeck if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        //Ge tthe cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        //Flip card
        
        if card.isFlipped == false && card.isMatched == false {
            
            
            
            //Flip the card
            cell.flip()
            
            //Play flip sound
            SoundManager.playSound(.flip)
            
            //Set the status of the card
            card.isFlipped = true
            
            //Determin if it's the frist card or second card that's flippep over
            if firstFlippedCardIndex == nil {
                //Tjhis is the first card bien gflipped
                firstFlippedCardIndex = indexPath
            }
            else {
                //This is the second card being flipped
                
                //TODO: Perfomr the matching logic
                checkForMatches(indexPath)
            }
        }
    } // MARK: Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        //GEt the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            //It's a match
            
            //Play flip sound
            SoundManager.playSound(.match)
            
            //Set the statuises of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //Remove the cards fromt he grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Check if there are nay crads left unmatched
            checkGameEnded()
        }
        else {
           //It;s not a match
            
            //Play flip sound
            SoundManager.playSound(.nomatch)
             
           //Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
           //FLip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //Tell the collectionview to reload the cell of the first card it it if nil
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        //Determine if here are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        //If not, then user has won, stop timer
        
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
        }
        else {

            //If there unmatched cards left, check if there's any time left
            if milliseconds > 0 {
                return
            }
            
            title = "Game over!"
            message = "You've lost"
        }
        
           //Show won/lost messaging
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String){
     
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
} //End ViewCOntroller Class

