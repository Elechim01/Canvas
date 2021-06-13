//
//  Home.swift
//  Canvas (iOS)
//
//  Created by Michele Manniello on 13/06/21.
//

import SwiftUI

struct Home: View {
    @State var toggle = false
    var body: some View {
        if #available(iOS 15.0, *){
            ZStack{
                //  Wave From View.....
                WaveFrom(color: .cyan.opacity(0.8), amplify: 150, isRevrsed: false)
                WaveFrom(color: (toggle ? Color.purple : Color.cyan).opacity(0.6), amplify: 140, isRevrsed: true)
                VStack{
                    HStack{
                        Text("Wave's")
                            .font(.largeTitle.bold())
                        Spacer()
                        Toggle(isOn: $toggle) {
                            Image(systemName: "eyedropper.halffull")
                                .font(.title2)
                        }
                        .toggleStyle(.button)
                        .tint(.purple)
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea(.all,edges: .bottom)
        }else{
            Text("Hola amgio")
        }
    }
//     context.draw(Text("\(offset)"), at: CGPoint(x: size.width / 2, y: 100))
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
struct WaveFrom: View{
//    Custom color...
    var color : Color
    var amplify: CGFloat
//    revers motion....
    var isRevrsed : Bool
    var body: some View{
        if #available(iOS 15.0, *){
            //        Using Time Line View for periodic Updates....
            TimelineView(.animation) { timeLine in
                
                //            Canvas View for drawing Wave....
                Canvas{ context, size in
//                   getting Current Time...
                    let timeNow = timeLine.date.timeIntervalSinceReferenceDate
//                    animating the wave using current time...
                    let angle = timeNow.remainder(dividingBy: 2)
//                    clculating offsett....
                    let offset = angle * size.width
                   
//                    you can see it now shifts to screen width...
                    
//                    you canl see it moves between -1.5 - 1.5......
//                    ie 3/2 = 1.5
//                    if 2 means -1 to 1.....
//                    moving the whole view...
//                    simple and easy wave animation..
                    context.translateBy(x: isRevrsed ? -offset: offset, y: 0)
//                    Using SwiftUI Path for drawing wave...
                    context.fill(getPath(size: size), with: .color(color))
//                    drawing curve front and back
//                    so that translation will be look like wave anmation...
                    context.translateBy(x: -size.width, y: 0)
                    context.fill(getPath(size: size), with: .color(color))
                    context.translateBy(x: size.width * 2, y: 0)
                    context.fill(getPath(size: size), with: .color(color))
                }
            }
        }else{
            Text("Hola")
        }
    }
    func getPath(size : CGSize)->Path{
         return Path{ path in
             let midHeight = size.height / 2
             let width = size.width
//                        moving the wave to center leading...
             path.move(to: CGPoint(x: 0, y: midHeight))
//                        drawing curve...
//                        For bottom
             path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width * 0.4, y: midHeight + amplify), control2: CGPoint(x: width * 0.65, y: midHeight - amplify))
//                        filling the bottom remainig  area...
             path.addLine(to: CGPoint(x: width, y: size.height))
             path.addLine(to: CGPoint(x: 0, y: size.height))
         }
    }
    
}
