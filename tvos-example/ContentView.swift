import SwiftUI

struct ContentView: View {
    // Sample data
    let items = [
        (imageName: "thumbnail1", description: "A different TestingBot Logo"),
        (imageName: "thumbnail2", description: "Just another TestingBot Logo"),
    ]

    @State private var selectedItem: (imageName: String, description: String)? = nil
    @State private var input1: String = ""
    @State private var input2: String = ""
    @FocusState private var focusedButton: Int?
    
    var body: some View {
        NavigationView {
            HStack {
                // Thumbnails Grid
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                        ForEach(items.indices, id: \.self) { index in
                            let isSelected = selectedItem?.imageName == items[index].imageName
                            ThumbnailView(
                                imageName: items[index].imageName,
                                description: items[index].description,
                                onButtonTap: {
                                    // Update the selected item when button is clicked
                                    selectedItem = items[index]
                                },
                                isFocused: focusedButton == index,
                                isSelected: isSelected
                            )
                            .frame(width: 300, height: 400)
                            .padding()
                            .focused($focusedButton, equals: index)
                        }
                    }

                    // Input Fields
                    VStack(spacing: 10) {
                        TextField("Enter first number", text: $input1)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .accessibilityIdentifier("inputField1")
                        
                        TextField("Enter second number", text: $input2)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .accessibilityIdentifier("inputField2")

                        HStack {
                                Text("Sum:")
                                    .font(.headline)
                                    .accessibilityIdentifier("sumLabel")
                                TextField("Result", text: .constant(calculateSum()))
                                    .disabled(true)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .accessibilityIdentifier("resultField")
                            }
                    }
                    .padding(.horizontal)
                }

                // Details View
                if let selectedItem = selectedItem {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(selectedItem.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .accessibilityIdentifier("detailsImage")

                        Text("Details")
                            .font(.largeTitle)
                            .bold()
                            .accessibilityIdentifier("detailsTitle")

                        Text(selectedItem.description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .accessibilityIdentifier("detailsDescription")

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                } else {
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("TestingBot tvOS Demo App")
            .accessibilityIdentifier("mainNavigationView")
        }
    }

    // Function to calculate the sum of input fields
    private func calculateSum() -> String {
        let num1 = Double(input1) ?? 0
        let num2 = Double(input2) ?? 0
        return String(num1 + num2)
    }
}

struct ThumbnailView: View {
    let imageName: String
    let description: String
    let onButtonTap: () -> Void
    let isFocused: Bool
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .background(isSelected ? Color.green.opacity(0.5) : (isFocused ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2)))
                .cornerRadius(10)
                .accessibilityIdentifier("\(imageName)Thumbnail")

            Text(description)
                .font(.headline)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("\(imageName)Description")

            Button("Tap Me", action: onButtonTap)
                .buttonStyle(LighterBlueButtonStyle(isFocused: isFocused, isSelected: isSelected))
                .accessibilityIdentifier("\(imageName)Button")
        }
    }
}

struct LighterBlueButtonStyle: ButtonStyle {
    let isFocused: Bool
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isSelected ? Color.green.opacity(0.5) : (isFocused ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2)))
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0) // Slightly enlarge when pressed
            .animation(.easeInOut, value: isFocused) // Smooth animation on focus
    }
}
