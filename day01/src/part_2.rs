use std::io;

use itertools::Itertools;

fn main() {
    let (col_a, col_b): (Vec<_>, Vec<_>) = io::stdin()
        .lines()
        .map(|line| {
            line.unwrap()
                .split_ascii_whitespace()
                .map(|s| s.parse::<i32>().unwrap())
                .collect_tuple()
                .unwrap()
        })
        .unzip();

    let answer: usize = col_a
        .iter()
        .map(|a| col_b.iter().filter(|b| a == *b).count() * (*a as usize))
        .sum();

    println!("{answer}");
}
