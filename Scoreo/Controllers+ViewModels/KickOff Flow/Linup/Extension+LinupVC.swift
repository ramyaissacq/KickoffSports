//
//  Extension+LinupVC.swift
//  Scoreo
//
//  Created by Remya on 11/10/22.
//

import Foundation
import UIKit

extension LinupViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return getTableRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BenchTableViewCell
        if let obj = getTableRowObject(row: indexPath.row) as? PreviewLineup{
            cell.configureCell(obj: obj)
        }
        else if let obj = getTableRowObject(row: indexPath.row) as? Lineup{
            cell.configureCell(obj: obj)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if linup != nil{
            var obj:Lineup?
            if selectedIndex == 0{
                obj = linup?.homeLineup?[indexPath.row]
            }
            else{
                obj = linup?.awayLineup?[indexPath.row]
            }
            gotoProfile(obj: obj)
        }
    }
    
    
    func getTableRowObject(row:Int)->Any?{
        if previewLinup != nil{
            if selectedIndex == 0{
                return previewLinup?.homeLineup?[row]
            }
            else{
                return previewLinup?.awayLineup?[row]
            }
        }
        else{
            if selectedIndex == 0{
               return linup?.homeLineup?[row]
            }
            else{
                return linup?.awayLineup?[row]
            }
            
        }
     
    }
    
    
    
    func getTableRows()->Int{
        if previewLinup != nil{
            if selectedIndex == 0{
                return previewLinup?.homeLineup?.count ?? 0
            }
            else{
                return previewLinup?.awayLineup?.count ?? 0
            }
        }
        else{
            
            if selectedIndex == 0{
                return linup?.homeLineup?.count ?? 0
            }
            else{
                return linup?.awayLineup?.count ?? 0
            }
            
        }
    }
}
