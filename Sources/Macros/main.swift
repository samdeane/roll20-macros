
// @{repeating_fightin_$1_fightinlvl}
// melee level index

enum Kind {
    case ranged(Weapon)
    case melee(Weapon)
    case initiative(Int)
    
}

struct Weapon {
    let name: String
    let level: Int
    let hitBonus: Int
    let damage: String
    let head: String
    let gizards: String
    let audio: String?
}


let fancyWinchester = Weapon(name: "Fancified '76", level: 6, hitBonus: 1, damage: "4d8!! + 2", head: "2d8!!", gizards: "1d8!!", audio: "Rifle")
let cutlass = Weapon(name: "Cutlass", level: 6, hitBonus: 0, damage: "2d8!!", head: "2d8!!", gizards: "1d8!!", audio: "Cutlas")

struct Macro {
    let name: String
    let kind: Kind
    let label: String
    let fixedTarget: Int?
    
    init(_ name: String, kind: Kind, label: String = "", fixedTarget: Int? = nil) {
        self.name = name
        self.kind = kind
        self.label = label
        self.fixedTarget = fixedTarget
    }
    
    var target: String {
        return (fixedTarget == nil) ? "?{Target}" : "\(fixedTarget!)"
    }
    
    var targetInput: String {
        return (fixedTarget == nil) ? "vs ?{Target|5}" : "\(fixedTarget!)"
    }
    var versusTarget: String {
        return (fixedTarget == nil) ? "vs \(target)" : ""
    }
    
    func raises(count: Int) -> (String, String) {
        var tests: [String] = []
        var labels: [String] = []
        var skip = 2
        for n in 1 ... count {
            tests.insert("--?! $ATK / \(n+1) -ge \(target) !? skipto*\(count-n+2)|RaiseLabel\(n)", at: 0)
            labels.insert(
                """
                --:RaiseLabel\(n)|
                --Raises: *\(n) | \(n) \(versusTarget)
                --skipto*\((2*count)-n+3)|Done
                """, at: 0)
            skip += 1
        }
        
        let raiseTests = tests.joined(separator: "\n")
        let raiseLabels = labels.joined(separator: "\n")
        return (raiseTests, raiseLabels)
    }
    
    var location: String {
        switch kind {
            case .initiative:
                return ""
                
            default:
                return
                    """
                    --?? $LOC == 1 OR $LOC == 2 ?? Hits \(versusTarget) *1 | For \(damage) in the Right Leg
                    --?? $LOC == 3 OR $LOC == 4 ?? Hits \(versusTarget) *2 | For \(damage) in the Left Leg
                    --?? $LOC == 11 OR $LOC == 12 ?? Hits \(versusTarget) *3 | For \(damage) in the Right Arm
                    --?? $LOC == 13 OR $LOC == 14 ?? Hits \(versusTarget) *4 | For \(damage) in the Left Leg
                    --?? $LOC >= 15 AND $LOC <= 19 ?? Hits \(versusTarget) *5 | For \(damage) in the Upper Guts
                    --?? $LOC >= 5 AND $LOC <= 9 ?? Hits \(versusTarget) *6 | For \(damage) in the Lower Guts
                    --?? $LOC == 10 ?? Hits \(versusTarget) *7 | For \(damage) + [^GIZ] in the Gizzards
                    --?? $LOC == 20 ?? Hits \(versusTarget) *8 | For \(damage) + [^HEAD] in the Head

                    """

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
            case .melee(let weapon): return weapon.name
            case .ranged(let weapon): return weapon.name
            case .initiative: return "@{quilvl}@{quidtype}"
        }
    }

    var damage: String {
        switch kind {
            case .melee:
                return "[^DAM] + [^STR]"
                
            default:
                return "[^DAM]"
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
                
            case .ranged, .melee:
                let count = 10
                let (raiseTests, raiseLabels) = raises(count: count)
                return """
                    --?? $ATK < \(target) ?? skipto*1|Missed
                    
                    \(location)
                    --~~~
                    --Attack:| \(attack)

                    \(raiseTests)
                    --skipto*\(count+2)|Done
                    \(raiseLabels)

                    --:Missed| Skip here for a miss
                    --Missed :| $$#900|***[^ATK] is a miss \(versusTarget)!***$$

                    --:Done|


                    """
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
    
    var attack: String {
        switch kind {
            case .melee(let weapon):
                return "[[ [$ATK] \(weapon.level)@{nimdtype}!!k1 + \(weapon.hitBonus) + ?{Modifier|0} ]]"
            case .ranged(let weapon):
                return "[[ [$ATK] \(weapon.level)@{defdtype}!!k1 + \(weapon.hitBonus) + ?{Modifier|0} ]]"
            default:
                return ""
        }
    }
    
    var rolls: String {
        switch kind {
            case .melee(let weapon):
                return
                    """
                    --Location:| [[ [$LOC] [NH] 1d20 ]]
                    --Damage:| Weapon [[ [$DAM] [NH] \(weapon.damage) ]] Strength [[ [$STR] [NH] 3d8!!k1 ]]
                    --Extra:| +Head [[ [$HEAD] [NH] \(weapon.head) ]] +Gizzards  [[ [$GIZ] [NH] \(weapon.gizards) ]]
                    """

            case .ranged(let weapon):
                return
                    """
                    --Location:| [[ [$LOC] [NH] 1d20 ]]
                    --Damage:| [[ [$DAM] [NH] \(weapon.damage) ]]
                    --Extra:| +Head [[ [$HEAD] [NH] \(weapon.head) ]] +Gizzards  [[ [$GIZ] [NH] \(weapon.gizards) ]]
                    """

            case .initiative(let level):
                return "[[ [$INIT] 1 + floor( ( \(level)@{quidtype}!!k1 + ?{bonus|0} ) / 5 ) ]]"
        }
    }
    
    var audio: String {
        switch kind {
            case .melee(let weapon), .ranged(let weapon):
                if let audio = weapon.audio {
                    return "--soundfx*1|_audio,play,nomenu|\(audio)"
                }
                
            default:
                break
        }
        return ""
    }
    
    var macro: String {
        """
        !power {{
        
        --name | @{nickname}
        --leftsub | \(left)
        --rightsub | \(right)
        
        \(botch)\(body)--~~~
        \(rolls)
        \(audio)
        }}
        
        """
    }
}

let macros = [
    //    Macro("initiative", kind: .initiative(4)),
    //    Macro("bowie", kind: .melee, fixedTarget: 5),
    //    Macro("brawlin", kind: .melee, fixedTarget: 5),
    Macro("cutlass", kind: .melee(cutlass), fixedTarget: 5),
//    Macro("winchester", kind: .ranged(fancyWinchester), fixedTarget: 5),
]

for macro in macros {
//    print("\n\n\(macro.name).roll20:\n")
    print(macro.macro)
}
