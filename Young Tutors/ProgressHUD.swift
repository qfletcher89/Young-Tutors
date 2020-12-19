//
//  ProgressHUD.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/10/20.
//

import SwiftUI
import SwiftUIVisualEffects

public enum TTProgressHUDType {
    case Loading
    case Success
    case Warning
    case Error
}

struct IndefiniteAnimatedView: View {
    var animatedViewSize: CGSize
    var animatedViewForegroundColor:Color
    
    var lineWidth: CGFloat
    
    @State private var isAnimating = false
    
    private var foreverAnimation: Animation {
        Animation.easeInOut(duration: 1.5)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        let gradient = Gradient(colors: [animatedViewForegroundColor, .clear])
        let radGradient = AngularGradient(gradient: gradient, center: .center, angle: .degrees(-5))
        
        Circle()
            .trim(from: 0.0, to: 0.97)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(radGradient)
            .frame(width: animatedViewSize.width-lineWidth/2, height: animatedViewSize.height-lineWidth/2)
            .rotationEffect(Angle(degrees: self.isAnimating ? 270 : -90.0))
            .animation(self.isAnimating ? foreverAnimation : .default)
            .padding(lineWidth/2)
            .onAppear { self.isAnimating = true }
            .onDisappear { self.isAnimating = false }
    }
}

struct ImageView: View {
    var type: TTProgressHUDType
    
    var imageViewSize:CGSize
    var imageViewForegroundColor:Color
    
    var successImage: String
    var warningImage: String
    var errorImage: String
    
    var body: some View {
        imageForHUDType()!
            .resizable()
            .frame(width: imageViewSize.width * 0.5, height: imageViewSize.height * 0.5)
//            .foregroundColor(imageViewForegroundColor.opacity(0.8))
            .vibrancyEffect()
            .vibrancyEffectStyle(.fill)
    }
    
    func imageForHUDType() -> Image? {
        switch type {
        case .Success:
            return Image(systemName: successImage)
        case .Warning:
            return Image(systemName: warningImage)
        case .Error:
            return Image(systemName: errorImage)
        default:
            return nil
        }
    }
}

struct LabelView: View {
    var title:String?
    var caption:String?
    
    var body: some View {
        if title != nil || caption != nil {
            VStack(spacing: 4) {
                if let title = title {
                    Text(title)
                        .font(.system(size: 21.0, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                }
                if let caption = caption {
                    Text(caption)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .vibrancyEffect()
            .vibrancyEffectStyle(.fill)
        } else {
            EmptyView()
        }
    }
}

public struct TTProgressHUD: View {
    @Binding var isVisible: Bool
    var config: TTProgressHUDConfig
    
    @Environment(\.colorScheme) var colorScheme
    
    public init(_ isVisible:Binding<Bool>, config: TTProgressHUDConfig){
        self._isVisible = isVisible
        self.config = config
    }
    
    public var body: some View {
        let hideTimer = Timer.publish(every: config.autoHideInterval, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            ZStack{
                if isVisible {
                    config.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    //                    ZStack {
                    //                        Color.white
                    //                            .blurEffect()
                    //                            .blurEffectStyle(.systemChromeMaterial)
                    
                    VStack(spacing: 20) {
                        if config.type == .Loading {
                            IndefiniteAnimatedView(animatedViewSize: config.imageViewSize,
                                                   animatedViewForegroundColor: config.imageViewForegroundColor,
                                                   lineWidth: config.lineWidth)
                        } else {
                            ImageView(type: config.type,
                                      imageViewSize: config.imageViewSize,
                                      imageViewForegroundColor: config.imageViewForegroundColor,
                                      successImage: config.successImage,
                                      warningImage: config.warningImage,
                                      errorImage: config.errorImage)
                        }
                        LabelView(title: config.title, caption: config.caption)
                    }.frame(width: config.imageViewSize.width + 40, height: config.imageViewSize.width + 40)
                    .background(
                        BlurView()

                    )
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
//                    .onAppear(){
//                        if config.hapticsEnabled {
//                            generateHapticNotification(for: config.type)
//                        }
//                    }
                    //                    }
                    //                    .overlay(
                    //                        // Fix reqired since .border can not be used with
                    //                        // RoundedRectangle clip shape
                    //                        RoundedRectangle(cornerRadius: config.cornerRadius)
                    //                            .stroke(config.borderColor, lineWidth: config.borderWidth)
                    //                    )
                    //                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                    //                    .aspectRatio(1, contentMode: .fit)
                    //                    .padding(geometry.size.width / 7)
//                    .shadow(color: config.shadowColor, radius: config.shadowRadius)
                }
                
            }
                        .animation(.spring())
            .onTapGesture {
                if config.allowTapToHide {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
            .onReceive(hideTimer) { _ in
                if config.shouldAutoHide {
                    withAnimation {
                        isVisible = false
                    }
                }
                // Only one call required
                hideTimer.upstream.connect().cancel()
            }
        }
    }
}



public struct TTProgressHUDConfig
{
    var type = TTProgressHUDType.Loading
    var title:String?
    var caption:String?
    
    var minSize:CGSize
    var cornerRadius:CGFloat
    
    var backgroundColor:Color
    
    var titleForegroundColor:Color
    var captionForegroundColor:Color
    
    var shadowColor:Color
    var shadowRadius:CGFloat
    
    var borderColor:Color
    var borderWidth:CGFloat
    
    var lineWidth:CGFloat
    
    var imageViewSize:CGSize // indefinite animated view and image share the size
    var imageViewForegroundColor:Color // indefinite animated view and image share the color
    
    var successImage:String
    var warningImage:String
    var errorImage:String
    
    // Auto hide
    var shouldAutoHide:Bool
    var allowTapToHide:Bool
    var autoHideInterval:TimeInterval
    
    // Haptics
    var hapticsEnabled:Bool
    
    // All public structs need a public init
    public init(type:TTProgressHUDType         = .Loading,
                title:String?                  = nil,
                caption:String?                = nil,
                minSize:CGSize                 = CGSize(width: 100.0, height: 100.0),
                cornerRadius:CGFloat           = 12.0,
                backgroundColor:Color          = .clear,
                titleForegroundColor:Color     = .primary,
                captionForegroundColor:Color   = .secondary,
                shadowColor:Color              = .clear,
                shadowRadius:CGFloat           = 0.0,
                borderColor:Color              = .clear,
                borderWidth:CGFloat            = 0.0,
                lineWidth:CGFloat              = 10.0,
                imageViewSize:CGSize           = CGSize(width: 100, height: 100), // indefinite animated view and image share the size
                imageViewForegroundColor:Color = .primary,                        // indefinite animated view and image share the color
                successImage:String            = "checkmark.circle",
                warningImage:String            = "exclamationmark.circle",
                errorImage:String              = "xmark.circle",
                shouldAutoHide:Bool            = false,
                allowTapToHide:Bool            = false,
                autoHideInterval: TimeInterval = 10.0,
                hapticsEnabled:Bool            = true)
    {
        self.type = type
        
        self.title = title
        self.caption = caption
        
        self.minSize = minSize
        self.cornerRadius = cornerRadius
        
        self.backgroundColor = backgroundColor
        
        self.titleForegroundColor = titleForegroundColor
        self.captionForegroundColor = captionForegroundColor
        
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        
        self.lineWidth = lineWidth
        
        self.imageViewSize = imageViewSize
        self.imageViewForegroundColor = imageViewForegroundColor
        
        self.successImage = successImage
        self.warningImage = warningImage
        self.errorImage = errorImage
        
        self.shouldAutoHide = shouldAutoHide
        self.allowTapToHide = allowTapToHide
        self.autoHideInterval = autoHideInterval
        
        self.hapticsEnabled = hapticsEnabled
    }
}

struct BlurView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
