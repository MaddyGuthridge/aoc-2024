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

    let answer: i32 = col_a
        .iter()
        .sorted()
        .zip(col_b.iter().sorted())
        .map(|(a, b)| (a - b).abs())
        .sum();

    println!("{answer}");
}
