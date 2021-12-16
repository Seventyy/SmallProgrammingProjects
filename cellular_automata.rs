fn main() {
    let mut map:[[bool; 39]; 20];
    
    let mut test_line:[bool; 39] = [false; 39];
    print(&test_line);

    map[1][19] = true;    
    for i in map {
        
    }
}

fn calculate_next(previous:&[bool; 39]) -> [bool; 39] {
    let mut next:[bool; 39] = [false; 39];
    for i in previous { // array out of bounds
        
    }
    next
}

fn print (row:&[bool;39]) {
    let mut line:String = String::new();
    for cell in row {
        if *cell {
            line += "[]";
        } else {
            line += "  ";
        }
    }
    println!("{}", line);
}











































//Vector based \/

/*/// 
/// r30
///
/// *** **- *-* *-- -** -*- --* --- 
///  -   -   -   *   *   *   *   -
///


fn main() {
    let length:i32 = 20;
    let mut rows:Vec<Vec<bool>> = Vec::new();

    // debug
    let mut a:Vec<bool> = Vec::new();
    a.push(false);
    a.push(true);

    let mut b:Vec<bool> = Vec::new();
    b.push(false);
    b.push(false);

    print(&a);
    rows.push(a);

    print(&b);
    tick(&b);
    rows.push(b);
    //
}

fn tick(state:&Vec<bool>) -> Vec<bool> {
    let mut alternate_state:Vec<bool> = Vec::new();
    
    for i in 0usize..alternate_state.len()+2 {
        if alternate_state.get(i){
            
    }
        
    let mut new_state:Vec<bool> = Vec::new();
    new_state    
}

fn print(row:&Vec<bool>) {
    let mut line:String = String::new();
    for cell in row {
        if *cell {
            line += "[]";
        } else {
            line += "  ";
        }
    }
    println!("{}", line);
}
*/
/*
fn tick(map:Vec<bool>)
{
    let mut cells:Vec<bool> = Vec::new();
    
    map.push(cells);

}

fn print(map:Vec<>)
{
    for row in rows
    {
        
    }
}
*/
