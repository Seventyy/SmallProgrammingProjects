fn main()
{
    let mut a: i32 = 7;
    a+=1;
    println!("it is {}, innit?", divide(a.into(), 3.0));
    for i in 3u32..9 {
        println!("Number {} divided by 5 is {}.", i, divide (i.into(), 5f64);
    }
}

fn divide(a:f64, b:f64) -> f64
{
    println!("dividing...");
    if b == 0f64
    {
        println!("dividing by zero");
        0f64
    }
    else
    {
        a/b
    }
}
