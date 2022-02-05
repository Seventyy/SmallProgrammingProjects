fn main() {
    //let mut map:[[bool; 39]; 20];
    
    let mut first_line:[bool; 39] = [false; 39];
    first_line[19] = true;    
    let mut current_line:[bool; 39] = first_line;
   
    let test_arr = [0,1,2,3,4,5,6,7];

    for i in &test_arr[2..5] {
        println!("{}", i);
    }

    for i in 0i32..139 {
         print(&current_line);
         current_line = calculate_next(&current_line);        
    }
}

fn calculate_next(previous:&[bool; 39]) -> [bool; 39] {
    let mut next:[bool; 39] = [false; 39];
    for i in 0usize..37 { 
        if &previous[i..i+3] == (true, true, false) |
        &previous[i..i+3] == (true, false, false) |        
        &previous[i..i+3] == (false, true, false) |
        &previous[i..i+3] == (false, false, true) {
            next[i] = true;
        }


    }
    for i in 0usize..37 {
        match &previous[i..i+3] {
            (true, true, false) => next[i] = true;
            (true, false, false) => next[i] = true;
            (false, true, false) => next[i] = true;
            (false, false, true) => next[i] = true;
        }
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
