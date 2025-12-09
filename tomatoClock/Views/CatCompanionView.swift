// Cat companion view
// Created by Copilot

import SwiftUI

struct CatCompanionView: View {
    let mood: CatMood
    let statusText: String

    @State private var isTapped: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 160, height: 160)
                    .shadow(radius: 10)

                Text(catEmoji)
                    .font(.system(size: 80))
                    .scaleEffect(isTapped ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isTapped)
            }
            .onTapGesture {
                isTapped.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTapped.toggle()
                }
            }

            Text(statusText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 16)
    }

    private var catEmoji: String {
        switch mood {
        case .idle:
            return "😺"
        case .focusing:
            return "😼"
        case .resting:
            return "😸"
        case .celebrating:
            return "😻"
        }
    }

    private var backgroundColor: Color {
        switch mood {
        case .idle:
            return Color(.systemGray6)
        case .focusing:
            return Color.orange.opacity(0.2)
        case .resting:
            return Color.green.opacity(0.2)
        case .celebrating:
            return Color.pink.opacity(0.2)
        }
    }
}
