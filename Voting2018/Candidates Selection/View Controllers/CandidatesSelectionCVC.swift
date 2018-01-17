//
//  CandidatesSelectionCVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 16.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit

private let candidatesCellIdentifier = "CandidatesSelectionCVCell"

class CandidatesSelectionCVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var buttonVote: UIButton!
    
    var candidates:[Candidate] = []
    var selectedCandidate:Candidate?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            collectionViewFlowLayout.estimatedItemSize = CGSize(width: 100, height: 100)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        NetworkManager.sI.getCandidates() { error, candidates in
            if let resultCandidates = candidates {
                self.candidates = resultCandidates
                self.collectionView?.reloadData()
            }
        }
    }

    

    // MARK: UICollectionViewDataSource

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidates.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: candidatesCellIdentifier, for: indexPath) as! CandidatesSelectionCVCell
    
        let candidate = candidates[indexPath.item]
        
        cell.setName(text: candidate.fullName)
        cell.setAge(number: candidate.age)
        cell.setAvatar(urlString: candidate.photoPath)
        cell.setWidth(screenWidth: self.view.frame.width)
        cell.setSelected(bool: selectedCandidate?.id == candidate.id )
        
        return cell
    }

    // MARK: UICollectionViewDelegate

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCandidate?.id == candidates[indexPath.item].id {
            selectedCandidate = nil
        } else {
            selectedCandidate = candidates[indexPath.item]
        }
        collectionView.reloadData()
    }
    
    
    
    //MARK: Actions
    
    @IBAction func actionButtonVote(_ sender: Any) {
    }
    
    
    
}
