//
//  debouncedSearch.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/20/23.
//

import Foundation
import Combine

public final class DebouncedTextField: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    @Published var preventAfterSelect: Bool = false
    private var bag = Set<AnyCancellable>()
    
    public init(dueTime: TimeInterval = 0.5) {
        $text
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: {[weak self] value in
                if !(self?.preventAfterSelect ?? false) {
                    self?.debouncedText = value
                } else {
                    self?.preventAfterSelect = false
                }
            })
            .store(in: &bag)
    }
}
