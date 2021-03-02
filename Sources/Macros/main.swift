enum Kind {
    case ranged(Gun)
    case melee
    case initiative(Int)
    
}

struct Gun {
    let name: String
    let level: Int
    let hitBonus: Int
    let damage: String
    let head: String
    let gizards: String
}

let fancyWinchester = Gun(name: "Fancified '76", level: 4, hitBonus: 1, damage: "4d8!! + 2", head: "2d8!!", gizards: "1d8!!")

struct Macro {
    let name: String
    let kind: Kind
    let label: String
    
    init(_ name: String, kind: Kind, label: String = "") {
        self.name = name
        self.kind = kind
        self.label = label
    }
    
    var location: String {
        switch kind {
            case .initiative:
                return ""
                
            default:
                return
                    """
                    --?? $LOC == 1 OR $LOC == 2 ?? Hits vs ?{Target} *1 | For [^DAM] in the Right Leg
                    --?? $LOC == 3 OR $LOC == 4 ?? Hits vs ?{Target} *2 | For [^DAM] in the Left Leg
                    --?? $LOC == 11 OR $LOC == 12 ?? Hits vs ?{Target} *3 | For [^DAM] in the Right Arm
                    --?? $LOC == 13 OR $LOC == 14 ?? Hits vs ?{Target} *4 | For [^DAM] in the Left Leg
                    --?? $LOC >= 15 AND $LOC <= 19 ?? Hits vs ?{Target} *5 | For [^DAM] in the Upper Guts
                    --?? $LOC >= 5 AND $LOC <= 9 ?? Hits vs ?{Target} *6 | For [^DAM] in the Lower Guts
                    --?? $LOC == 10 ?? Hits vs ?{Target} *7 | For [^DAM] + [^GIZ] in the Gizzards
                    --?? $LOC == 20 ?? Hits vs ?{Target} *8 | For [^DAM] + [^HEAD] in the Head
                    --skipto*2|Done

                    --:Missed| Skip here for a miss
                    --Missed :| $$#900|***[^ATK] is a miss vs ?{Target}!***$$

                    --:Done|

                    """

            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 1 OR $LOC == 2 ) ?? Hits For:| [^DAM] in the Right Leg
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 3 OR $LOC == 4 ) ?? Hits For:| [^DAM] in the Left Leg
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 11 OR $LOC == 12 ) ?? Hits For:| [^DAM] in the Right Arm
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 13 OR $LOC == 14 ) ?? Hits For:| [^DAM] in the Left Leg
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC >= 15 AND $LOC <= 19 ) ?? Hits For:| [^DAM] in the Upper Guts
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC >= 5 AND $LOC <= 9 ) ?? Hits For:| [^DAM] in the Lower Guts
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 10 ) ?? Hits For:| [^DAM] + [^GIZ] in the Gizzards
            //                    --?? ( $ATK >= ?{Target} ) AND ( $LOC == 20 ) ?? Hits For:| [^DAM] + [^HEAD] in the Head

        }
    }
    
    var left: String {
        switch kind {
            case .melee: return "Fightin"
            case .ranged: return "Shoots The Varmint"
            case .initiative: return "Initiative"
        }
    }
    
    var right: String {
        switch kind {
            case .melee: return label
            case .ranged(let gun): return gun.name
            case .initiative: return "@{quilvl}@{quidtype}"
        }
    }

    var body: String {
        switch kind {
            case .initiative:
                let ranges: [(String,String)] = [
                    ("< 1", "***bugger all*** cards"),
                    ("== 1", "a ***solitary*** one card"),
                    ("== 2", "an ***unremarkable*** two cards"),
                    ("== 3", "an ***exiting*** three cards"),
                    ("== 4", "an ***implausible*** four cards"),
                    ("> 4", "a ***truly astonishing*** five cards")
                ]

                var text = ""
                for (test, label) in ranges {
                    text += "--?? $INIT \(test) ?? !Cards:| Has \(label).\n"
                }
                return text
                
            case .ranged:
                
                var tests: [String] = []
                var labels: [String] = []
                var skip = 2
                let count = 10
                for n in 1 ... count {
                    tests.insert("--?! $ATK / \(n+1) -ge ?{Target} !? skipto*\(count-n+2)|RaiseLabel\(n)", at: 0)
                    labels.insert(
                        """
                        --:RaiseLabel\(n)|
                        --!Raises *\(n) |  [^ATK] is \(n) raises vs ?{Target}
                        --skipto*\((2*count)-n+3)|Done
                        """, at: 0)
                    skip += 1
                }
                
                let raiseTests = tests.joined(separator: "\n")
                let raiseLabels = labels.joined(separator: "\n")
                
                return
                    """
                    --?? $ATK < ?{Target|5} ?? skipto*1|Missed
                    
                    --?? $LOC == 1 OR $LOC == 2 ?? Hits *1 | [^DAM] in the Right Leg
                    --?? $LOC == 3 OR $LOC == 4 ?? Hits *2 | [^DAM] in the Left Leg
                    --?? $LOC == 11 OR $LOC == 12 ?? Hits *3 | [^DAM] in the Right Arm
                    --?? $LOC == 13 OR $LOC == 14 ?? Hits *4 | [^DAM] in the Left Leg
                    --?? $LOC >= 15 AND $LOC <= 19 ?? Hits *5 | [^DAM] in the Upper Guts
                    --?? $LOC >= 5 AND $LOC <= 9 ?? Hits *6 | [^DAM] in the Lower Guts
                    --?? $LOC == 10 ?? Hits *7 | [^DAM] + [^GIZ] in the Gizzards
                    --?? $LOC == 20 ?? Hits *8 | [^DAM] + [^HEAD] in the Head
                    
                    \(raiseTests)
                    --skipto*\(count+2)|Done

                    \(raiseLabels)

                    --:Missed| Skip here for a miss
                    --Missed :| $$#900|***[^ATK] is a miss vs ?{Target}!***$$

                    --:Done|


                    """
                
            default:
                return ""
        }
    }

    var botch: String {
        switch kind {
            case .initiative(let level):
                return "--?? $INIT.ones > \(level / 2) ?? Arse: |  That was a botch!\n"

            case .ranged(let gun):
                return "--?? $ATK.ones > \(gun.level / 2) ?? FFS: |  That was a botch!\n"
            default:
                return ""
        }
    }
    
    var rolls: String {
        switch kind {
            case .melee:
                return "loc: [[ [$LOC] 1d20 + 2 ]] str: [[ [$STR] 3d8!!k1 + ?{Damage Mod|0} ]] + wep: [[ [$WEP] 2d8!! ]] head: [[ [$HEAD] 2d8!! ]] giz: [[ [$GIZ] 1d8!! ]]"

            case .ranged(let gun):
                return
                    """
                    --Attack:| [[ [$ATK] \(gun.level)@{defdtype}!!k1 +  \(gun.hitBonus) + ?{Modifier|0} ]] vs ?{Target|5}
                    --Location:| [[ [$LOC] [NH] 1d20 ]]
                    --Damage:| [[ [$DAM] [NH] \(gun.damage) ]]
                    --Head:| + [[ [$HEAD] [NH] \(gun.head) ]]
                    --Gizards:| +  [[ [$GIZ] [NH] \(gun.gizards) ]]
                    """

            case .initiative(let level):
                return "[[ [$INIT] 1 + floor( ( \(level)@{quidtype}!!k1 + ?{bonus|0} ) / 5 ) ]]"
        }
    }
    
    var macro: String {
        """
        !power {{
        
        --name | @{nickname}
        --leftsub | \(left)
        --rightsub | \(right)
        
        \(botch)\(body)--~~~
        \(rolls)
        
        }}
        
        """
    }
}

let macros = [
//    Macro("bowie", kind: .melee),
//    Macro("brawlin", kind: .melee),
//    Macro("cutlass", kind: .melee),
//    Macro("initiative", kind: .initiative(4)),
    Macro("winchester", kind: .ranged(fancyWinchester)),
]

for macro in macros {
//    print("\n\n\(macro.name).roll20:\n")
    print(macro.macro)
}
