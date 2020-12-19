//
//  SessionView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct SessionView: View {
    
    @EnvironmentObject var tutorsModel: TutorsModel
    @Environment (\.self.presentationMode) var presentationMode
    @State var calendarSelection = Calendar.current.component(.weekday, from: Date())
    @State var session = Session(id: "", day: "", time: "", tutors: [""])
    @State var isShowingTutors = false
    @State var tutorIsPresented = false
    @State var isShowingRecap = false
    @State var infoForTutor = Tutor(id: "not-found", grade: nil, email: nil, bio: nil, awards: nil, strengths: nil, pronouns: nil, gradient: "", times: nil, classes: nil)
    var subject: Subject
    var course: Class
    @EnvironmentObject var model: ClassModel
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Class")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(3)
                        
                        Text(course.levels + " " + course.name)//was capitalized
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Date")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(formatDate())
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Time")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(session.time)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Tutor")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if session.tutors.first! != "" {
                            HStack {
                                
                                Button {
                                    self.infoForTutor = getTutor(tutorID: session.selectedTutor)
                                    self.tutorIsPresented = true
                                } label: {
                                    Image("info")
                                        .foregroundColor(self.cs().watermelon)
                                }
                                
                                Text(session.selectedTutor)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                if session.tutors.count != 1 {
                                    Button {
                                        withAnimation(Animation.easeOut(duration: 0.3)) {
                                            self.isShowingTutors.toggle()
                                        }
                                    } label: {
                                        Image("switch")
                                            .foregroundColor(self.cs().watermelon)
                                    }
                                }
                            }
                        }
                        
                        if session.tutors.count != 1 {
                            if isShowingTutors {
                                
                                ForEach(session.tutors, id: \.self) {tutor in
                                    if tutor != session.selectedTutor {
                                        HStack {
                                            
                                            Button {
                                                
                                                self.infoForTutor = getTutor(tutorID: tutor)
                                                self.tutorIsPresented = true
                                            } label: {
                                                Image("info")
                                            }
                                            
                                            
                                            Text(tutor)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            
                                            Spacer()
                                            
                                            Button {
                                                withAnimation(Animation.easeOut(duration: 0.3)) {
                                                    let generator = UISelectionFeedbackGenerator()
                                                    generator.prepare()
                                                    generator.selectionChanged()
                                                    self.session.selectedTutor = tutor
                                                    self.isShowingTutors = false
                                                }
                                            } label: {
                                                Image("check")
                                            }
                                        }.padding(.top, 10)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //selector
                    VStack {
                        
                        VStack {
                            
                            Text(getMonthAndYear())
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { reader in
                                    
                                    HStack {
                                        
                                        ForEach(getDaysInWeek()) {day in
                                            
                                            VStack {
                                                
                                                Text(day.weekday)
                                                    .fontWeight(.semibold)
                                                
                                                Button {
                                                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                                                        self.calendarSelection = day.dayOfWeek
                                                    }
                                                } label: {
                                                    Text(String(day.id))
                                                        .foregroundColor(day.id < getDayNumber() ? Color(UIColor.quaternaryLabel) : calendarSelection != day.dayOfWeek ? Color(UIColor.label) : .white)
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .background(Circle().frame(width: 28, height: 28)
                                                                        .foregroundColor(calendarSelection == day.dayOfWeek ? self.cs().watermelon : .clear))
                                                }.padding(.vertical, 5)
                                            }.padding(.horizontal, 10)
                                            .disabled(day.id < getDayNumber())
                                        }
                                    }.onAppear {
                                        reader.scrollTo(getDayNumber())
                                    }
                                }
                            }.centered()
                            
                            Divider()
                                .padding(.vertical)
                            
                            if !getSessionsForSelectedDate().isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                        
                                        ForEach(getSessionsForSelectedDate()) {session in
                                            
                                            Button {
                                                
                                                withAnimation(Animation.easeInOut(duration: 0.3)) {
                                                    
                                                    self.session = session
                                                    
                                                }
                                            } label: {
                                                if self.session.id == session.id {
                                                    Text(session.time)
                                                        .foregroundColor(.white)
                                                        .padding(.vertical, 2)
                                                        .padding(.horizontal, 10)
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                                        .foregroundColor(self.cs().watermelon))
                                                } else {
                                                    Text(session.time)
                                                        .foregroundColor(self.cs().watermelon)
                                                        .padding(.vertical, 2)
                                                        .padding(.horizontal, 10)
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                                        .strokeBorder(lineWidth: 2)
                                                                        .foregroundColor(self.cs().watermelon))
                                                }
                                            }.padding(.trailing, 5)
                                        }
                                    }
                                }.centered()
                            } else {
                                Text("Sorry, no sessions for this day.")
                                    .italic()
                                    .centered()
                                    .padding(.vertical, 2)
                            }
                            
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(Color(UIColor.secondarySystemBackground)))
                    }
                    
                    Button {
                        
                        model.createSession(at: session.id,
                                            with: session.selectedTutor,
                                            using: tutorsModel,
                                            subject: subject,
                                            course: course, completion: {
                                                self.isShowingRecap = true
                                            })
                        
                    } label: {
                        
                        HStack {
                            
                            Image("check")
                                .renderingMode(.template)
                                .foregroundColor(session.id != "" ? .white : Color(UIColor.quaternaryLabel))
                            
                            Text("Confirm")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(session.id != "" ? .white : Color(UIColor.quaternaryLabel))
                                
                        }.padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .background(RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(session.id != "" ? self.cs().watermelon : Color(UIColor.quaternarySystemFill)))
                    }.centered()
                    .padding(.bottom)
                    
                }.padding(.top)
            }.padding(.horizontal)
            .background(NavigationLink(destination: RecapView(course: course,
                                                              date: formatDate(),
                                                              time: session.time,
                                                              tutor: getTutor(tutorID: session.selectedTutor)), isActive: $isShowingRecap, label: {EmptyView()}))
            .sheet(isPresented: $tutorIsPresented, content: {TutorDetailView(tutor: infoForTutor, isFromModal: true)})
            .customNavBar(proxy: geometry, title: "Book a Session", leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                AnyView(Image("left"))
            }))
        }
//        .navigationTitle("")
//        .navigationBarHidden(true)
    }
    
    func getTutor(tutorID: String) -> Tutor {
        
        var funcTutor = Tutor(id: "not-found", grade: nil,
                          email: nil,
                          bio: nil,
                          awards: nil,
                          strengths: nil,
                          pronouns: nil,
                          gradient: "",
                          times: nil,
                          classes: nil)
        
        for tutor in self.tutorsModel.tutors {
            
            if tutor.id == tutorID {
                funcTutor = tutor
            }
            
        }
        
        return funcTutor
        
    }
    
    func getMonthAndYear() -> String {
        
        let calendar = Calendar.current
        
        let monthNumber = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        var month = ""
        
        month = calendar.monthSymbols[monthNumber - 1]
        
        return "\(month) \(year)"
    }
    
    func getDaysInWeek() -> [Day] {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        let weekDay = calendar.component(.weekday, from: Date()) - 1
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day - weekDay
        
        var daysArray = [Day]()
        
        for _ in 0..<7 {
            
            let date = calendar.date(from: components)
            
            let dayOfWeek = calendar.component(.weekday, from: date!)
            let dayOfWeekSymbol = calendar.shortWeekdaySymbols[dayOfWeek - 1]
            daysArray.append(Day(id: components.day!, weekday: dayOfWeekSymbol, dayOfWeek: dayOfWeek))
            
            components.day = components.day! + 1
        }
        
        return daysArray
    }
    
    func getSessionsForSelectedDate() -> [Session] {
        
        var sessionArray = [Session]()
        
        for session in course.sessions {
            
            if session.day == String(calendarSelection) {
                
                sessionArray.append(session)
                
            }
        }
        
        return sessionArray
        
    }
    
    func getDayNumber() -> Int {
        
        let calendar = Calendar.current
        let weekday = calendar.component(.day, from: Date())
        
        return weekday
        
    }
    
    func formatDate() -> String{
        
        var weekday = Calendar.current.weekdaySymbols[calendarSelection - 1]
        let todayInt = Calendar.current.component(.weekday, from: Date())
        if calendarSelection == todayInt {
            weekday = "Today"
        }
        
        let offset = calendarSelection - todayInt
        guard offset >= 0 else {
            fatalError("the offset was negative, meaning the today int was bigger than the day")
            
        }
        
        var formattedDate = weekday
        
        if let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) {
            
            let monthInt = Calendar.current.component(.month, from: date)
            let month = Calendar.current.monthSymbols[monthInt - 1]
            let day = Calendar.current.component(.day, from: date)
            
            formattedDate = "\(weekday), \(month) \(day)"
            
        }
        
        return formattedDate
        
    }
    
}

struct Day: Identifiable {
    
    //31st
    var id: Int
    //Thur
    var weekday: String
    //5
    var dayOfWeek: Int
    
}
