

// let l = List::Elem(2, Box::new(List::Empty));
// enum List {
//     Empty,
//     Elem(i32, Box<List>),
// }

struct Node {
    elem: i32,
    prev: Option<Box<Node>>,
    next: Option<Box<Node>>
}

fn main() {
    let mut x = Node { elem: 1, prev: Option::None, next: Option::None };
    let y = Node { elem: 2, prev: Option::None, next: Option::None };
    x.next = Option::Some(Box::new(y));
    x.next.unwrap().prev = Option::Some(Box::new(x));
}