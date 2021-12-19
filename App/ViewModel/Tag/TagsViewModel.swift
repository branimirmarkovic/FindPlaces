//
//  TagsViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class TagsViewModel {

    var loader: TagsLoader

    private var tags: [TagViewModel] = []
    private var isThereMoreTags: Bool = false

    var onLoad:(([TagViewModel])-> Void)?
    var onError: ((String) -> Void)?

    init(loader: TagsLoader) {
        self.loader = loader
    }

    func load() {
        loader.load {[weak self] result in
            guard let self = self else {return}
            switch result  {
            case .success(let tags):
                self.tags = tags.results.map({TagViewModel(tag: $0)})
                self.isThereMoreTags = tags.more
                self.onLoad?(self.tags)
            case .failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }

    var tagsCount: Int {
        tags.count
    }

    var isMoreBadgeVisible: Bool {
        isThereMoreTags
    }

    func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }

    func tag(at index: Int) -> TagViewModel? {
        guard index < tags.count else {return nil}
        return self.tags[index]
    }

    func selectedTag(at index: Int, placesViewModel: PlacesViewModel) {
        let tagLabel = tags[index].tagSearchLabel
        placesViewModel.load(type: tagLabel)
    }
}
