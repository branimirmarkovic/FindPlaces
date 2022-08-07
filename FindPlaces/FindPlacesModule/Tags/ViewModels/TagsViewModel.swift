//
//  TagsViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class TagsViewModel {

    private let loader: TagsLoader

    private var tags: [TagViewModel] = []
    private var isThereMoreTags: Bool = false

    var onLoadStart: (() -> Void)?
    var didLoad:(()-> Void)?
    var onError: ((String) -> Void)?

    init(loader: TagsLoader) {
        self.loader = loader
    }

    func load() {
        onLoadStart?()
        loader.load {[weak self] result in
            guard let self = self else {return}
            switch result  {
            case .success(let tags):
                self.tags = tags.tags.map({TagViewModel(tag: $0)})
                self.isThereMoreTags = tags.more
                self.didLoad?()
            case .failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }

    var tagsCount: Int {
        tags.count
    }

    var areMoreTagsAvailable: Bool {
        isThereMoreTags
    }


    func tag(at index: Int) -> TagViewModel? {
        guard index < tags.count else {return nil}
        return self.tags[index]
    }

    func selectedTag(at index: Int,reloadWith placesViewModel: PlacesViewModel) {
        let tagLabel = tags[index].tagSearchLabel
        placesViewModel.load(type: tagLabel)
    }
    
    // MARK: - Private Methods
    
    private func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }
}
