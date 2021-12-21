//
//  CollectionViewLayoutProvider.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class CollectionViewLayoutProvider {

    static  func mainPageLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return tagsSection()
            default:
                return placesSection()
            }
        }
    }

    static func placesPageLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
        return placesSection()
        }
    }

    private static func tagsSection() -> NSCollectionLayoutSection {
        let itemInsets: CGFloat = 10
        let sectionInsets: CGFloat = 20

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInsets, leading: itemInsets, bottom: itemInsets, trailing: itemInsets)

        let widhtDimension = NSCollectionLayoutDimension.fractionalWidth(1)
        let heightDimension = NSCollectionLayoutDimension.fractionalWidth(1/3)

        let groupSize = NSCollectionLayoutSize(widthDimension: widhtDimension, heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInsets, leading: sectionInsets, bottom: sectionInsets, trailing: sectionInsets)
        return section
    }

    private static func placesSection() -> NSCollectionLayoutSection {

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
