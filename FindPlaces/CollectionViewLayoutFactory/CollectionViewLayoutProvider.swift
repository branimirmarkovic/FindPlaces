//
//  CollectionViewLayoutProvider.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


protocol CollectionViewLayoutFactory {
    func doubleSectionLayout() -> UICollectionViewLayout
    func listLayout() -> UICollectionViewLayout
}

class DefaultCollectionViewLayoutProvider: CollectionViewLayoutFactory {
    
    func doubleSectionLayout() -> UICollectionViewLayout {
        mainPageLayout()
    }
    
    func listLayout() -> UICollectionViewLayout {
        placesPageLayout()
    }
    
    private  func mainPageLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [self] sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.tagsSection()
            default:
                return self.placesSection()
            }
        }
    }

    private func placesPageLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.placesSection()
        }
    }

    private  func tagsSection() -> NSCollectionLayoutSection {
        let sectionInsets: CGFloat = 10

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let widhtDimension = NSCollectionLayoutDimension.estimated(1)
        let heightDimension = NSCollectionLayoutDimension.absolute(40)

        let groupSize = NSCollectionLayoutSize(widthDimension: widhtDimension, heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsets + 15, leading: sectionInsets, bottom: sectionInsets, trailing: sectionInsets)
        section.interGroupSpacing = sectionInsets
        return section
    }

    private func placesSection() -> NSCollectionLayoutSection {

        let itemInsets: CGFloat = 10
        let sectionInsets: CGFloat = 20

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3)))

        item.contentInsets = NSDirectionalEdgeInsets(top: itemInsets, leading: itemInsets, bottom: itemInsets, trailing: itemInsets)

        let widhtDimension = NSCollectionLayoutDimension.fractionalWidth(1)
        let heightDimension = NSCollectionLayoutDimension.fractionalWidth(1/3)

        let groupSize = NSCollectionLayoutSize(widthDimension: widhtDimension, heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsets, leading: sectionInsets, bottom: sectionInsets, trailing: sectionInsets)
        return section
    }
}
