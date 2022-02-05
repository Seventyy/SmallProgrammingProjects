fn main() {
    let test_data = vec![8,2,5,4,2,8,5,9,1,3,6,7];
    quick_sort(test_data.clone());
}

fn quick_sort(data:Vec<i32>) -> Vec<i32> {
    if data.len() == 0 {
        return vec![];
    }
    let pivot = data[data.len()-1]; 
    data.pop();

    
    let mut smaller = Vec::new();
    let mut greater = Vec::new();
    for i in data {
        if i < pivot {
            smaller.push(i);
        } else {
            greater.push(i);
        }
    }
    
    //quick_sort(&smaller).extend(pivot); //  quick_sort(&greater)
    vec![1,2,3]
}
