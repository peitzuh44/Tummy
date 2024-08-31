//
//  TagLayout.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

struct TagLayout: Layout {
    // Layout Properties
    var alignment: Alignment = .center
    
    // Horizontal and vertical spacing
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            if index == (row.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        return .init(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for row in rows {
            // resetting origin X to zero for each row
            origin.x = 0
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                //updating origin x
                origin.x += (viewSize.width + spacing)
            }
            
            origin.y += (row.maxHeight(proposal) + spacing)
            
        }
        
    }
    
    // Generate rows base on avaliable size
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subViews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        
        // Origin
        
        var origin = CGRect.zero.origin
        
        for view in subViews {
            let viewSize = view.sizeThatFits(proposal)
            
            // Pushing to a new row
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                origin.x = 0
                row.append(view)
                origin.x += (viewSize.width + spacing)
            } else {
                // adding item to the same row
                row.append(view)
                origin.x += (viewSize.width + spacing)

            }
        }
        
        // Check for any exhaust row
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        return rows
        
    }
    

}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap{
            view in
            return view.sizeThatFits(proposal).height
        }
        .max() ?? 0
    }
}

