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
    var onError: ((Error) -> Void)?

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
                self.onError?(error)
            }
        }
    }

    var tagsCount: Int {
        tags.count
    }

    var isMoreBadgeVisible: Bool {
        isThereMoreTags
    }
}
