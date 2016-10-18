//
//  ViewController.swift
//  TestCollectionView
//
//  Created by tester on 10/17/16.
//  Copyright © 2016 tester. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [CellEntity] = []
    var selectedItems: [NSIndexPath] = []
    var tappedItemIndexPath: NSIndexPath?
    
    private let fullScreenAnimationController = FullScreenAnimationController()
    private let fullScreenSegueId = "fullScreenSegue"
    private var allowsMultipleSelection = false {
        didSet {
            collectionView.allowsMultipleSelection = allowsMultipleSelection
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGestureRecogniser)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        collectionView.addGestureRecognizer(tapRecognizer)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == fullScreenSegueId), let destinationViewController = segue.destinationViewController as? FullScreenViewController {
            destinationViewController.transitioningDelegate = self
            if let index = tappedItemIndexPath?.row {
                destinationViewController.data = data[index]
            }
        }
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
            if let indexPath = collectionView.indexPathForItemAtPoint(gesture.locationInView(collectionView)){
                self.tappedItemIndexPath = indexPath
                if !self.allowsMultipleSelection {
                    performSegueWithIdentifier(fullScreenSegueId, sender: nil)
                }else{
                    if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                        if cell.selected {
                            cell.selected = false
                            selectedItems.remove(indexPath)
                            cell.backgroundColor = nil
                        }else{
                            cell.selected = true
                            selectedItems.append(indexPath)
                            cell.backgroundColor = UIColor.blackColor()
                        }
                    }
                }
            }
    }
    
    func getFrameForTappedItem() -> CGRect {
        if tappedItemIndexPath != nil {
            if let attributes = self.collectionView.layoutAttributesForItemAtIndexPath(tappedItemIndexPath!) {
                let cellFrameInSuperview = collectionView.convertRect(attributes.frame, toView: self.view)
                return cellFrameInSuperview
            }
        }
        return CGRect.zero
    }
    
    @IBAction func insertAction(sender: AnyObject) {
        var indexPaths = collectionView.indexPathsForVisibleItems()
        indexPaths.sortInPlace{$0.row>$1.row}
        let cellEntity = CellEntity(colour: UIColor.randomColor(), text: "Hello world")
        data.insert(cellEntity,atIndex: indexPaths.first?.row ?? 0)
        collectionView.insertItemsAtIndexPaths([indexPaths.first ?? NSIndexPath(forItem: 0, inSection: 0)])
    }
    
    @IBAction func removeAction(sender: AnyObject) {
        if !self.allowsMultipleSelection {
            self.editButton.title = "Remove"
            self.allowsMultipleSelection = true
        } else {
            if selectedItems.count > 0 {
                selectedItems.sortInPlace{$0.row>$1.row}
                for index in selectedItems{
                    data.removeAtIndex(index.row)
                }
                collectionView.performBatchUpdates({
                    self.collectionView.deleteItemsAtIndexPaths(self.selectedItems)
                    }, completion: nil)
            }
            self.editButton.title = "Select"
            self.allowsMultipleSelection = false
            self.selectedItems.removeAll()
        }
    }
    
    @IBAction func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("colouredCell", forIndexPath: indexPath) as! ColouredCollectionViewCell
        cell.imageView.image = UIImage(color: data[indexPath.row].colour)
        cell.label.text = data[indexPath.row].text
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if cell.selected {
            cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = nil
        }
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let temp = data[sourceIndexPath.row]
        data[sourceIndexPath.row] = data[destinationIndexPath.row]
        data[destinationIndexPath.row] = temp
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fullScreenAnimationController.originFrame = collectionView.layoutAttributesForItemAtIndexPath(tappedItemIndexPath!)!.frame
        return fullScreenAnimationController
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.CGImage else { return nil }
        self.init(CGImage: cgImage)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = indexOf(object) {
            removeAtIndex(index)
        }
    }
}

